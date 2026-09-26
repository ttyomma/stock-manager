const tableBody = document.querySelector("#products-table-body");
const tableStatus = document.querySelector("#table-status");
const searchInput = document.querySelector("#search-input");
const refreshButton = document.querySelector("#refresh-button");
const productDialog = document.querySelector("#product-dialog");
const productForm = document.querySelector("#product-form");
const formTitle = document.querySelector("#form-title");
const formError = document.querySelector("#form-error");
const supplierDialog = document.querySelector("#supplier-dialog");
const supplierForm = document.querySelector("#supplier-form");
const supplierFormError = document.querySelector("#supplier-form-error");

let products = [];
let sortState = { key: "product_id", direction: "asc" };
let suppliers = [];
let supplierProducts = [];
let lowStockOnly = false;

async function readResponse(response) {
	const contentType = response.headers.get("content-type") || "";
	if (contentType.includes("application/json")) return response.json();
	const text = await response.text();
	throw new Error(response.ok ? "Сервер повернув некоректну відповідь" : `Помилка сервера (${response.status})`);
}

const formatCurrency = (value) => new Intl.NumberFormat("uk-UA", {
	style: "currency",
	currency: "UAH",
	maximumFractionDigits: 0,
}).format(Number(value) || 0);

const formatNumber = (value) => new Intl.NumberFormat("uk-UA").format(Number(value) || 0);

function updateMetrics(items) {
	const stockCount = items.reduce((total, product) => total + Number(product.stock_quantity || 0), 0);
	const inventoryValue = items.reduce((total, product) => (
		total + Number(product.purchase_price || 0) * Number(product.stock_quantity || 0)
	), 0);
	const lowStockCount = items.filter((product) => Number(product.stock_quantity || 0) <= 10).length;

	document.querySelector("#product-count").textContent = formatNumber(items.length);
	document.querySelector("#stock-count").textContent = formatNumber(stockCount);
	document.querySelector("#inventory-value").textContent = formatCurrency(inventoryValue);
	document.querySelector("#low-stock-count").textContent = formatNumber(lowStockCount);
}

function createCell(value, className = "") {
	const cell = document.createElement("td");
	cell.textContent = value;
	if (className) cell.className = className;
	return cell;
}

function renderProducts(items) {
	tableBody.replaceChildren();

	if (!items.length) {
		tableStatus.textContent = "За цим запитом товарів не знайдено.";
		tableStatus.classList.remove("d-none");
		return;
	}

	tableStatus.classList.add("d-none");
	items.forEach((product) => {
		const row = document.createElement("tr");
		const stock = Number(product.stock_quantity || 0);
		const stockClass = stock <= 10 ? "stock-low" : "stock-ok";

		row.append(
			createCell(product.product_id),
			createCell(product.product_name, "product-name"),
			createCell(product.category || "—"),
			createCell(formatCurrency(product.purchase_price), "text-end"),
			createCell(formatCurrency(product.sale_price), "text-end"),
			createCell(formatNumber(stock), `text-end ${stockClass}`),
			createActionsCell(product),
		);
		tableBody.append(row);
	});
}

function createActionsCell(product) {
	const cell = document.createElement("td");
	cell.className = "text-end action-cell";

	const editButton = document.createElement("button");
	editButton.className = "table-action edit-action";
	editButton.type = "button";
	editButton.textContent = "Редагувати";
	editButton.addEventListener("click", () => openProductForm(product));

	const deleteButton = document.createElement("button");
	deleteButton.className = "table-action delete-action";
	deleteButton.type = "button";
	deleteButton.textContent = "Видалити";
	deleteButton.addEventListener("click", () => deleteProduct(product));

	cell.append(editButton, deleteButton);
	return cell;
}

function openProductForm(product = null) {
	productForm.reset();
	formError.textContent = "";
	formTitle.textContent = product ? "Редагувати товар" : "Новий товар";
	const supplierSelect = document.querySelector("#supplier-id");
	supplierSelect.replaceChildren(new Option("Оберіть постачальника", ""));
	suppliers.forEach((supplier) => supplierSelect.add(new Option(supplier.company_name, supplier.supplier_id)));
	if (product) {
		document.querySelector("#product-id").value = product.product_id;
		supplierSelect.value = product.supplier_id;
		document.querySelector("#product-name").value = product.product_name;
		document.querySelector("#category").value = product.category;
		document.querySelector("#purchase-price").value = product.purchase_price;
		document.querySelector("#sale-price").value = product.sale_price;
		document.querySelector("#stock-quantity").value = product.stock_quantity;
	}
	productDialog.showModal();
}

function getProductFormData() {
	return {
		supplier_id: Number(document.querySelector("#supplier-id").value),
		product_name: document.querySelector("#product-name").value.trim(),
		category: document.querySelector("#category").value.trim(),
		purchase_price: Number(document.querySelector("#purchase-price").value),
		sale_price: Number(document.querySelector("#sale-price").value),
		stock_quantity: Number(document.querySelector("#stock-quantity").value),
	};
}

async function saveProduct(event) {
	event.preventDefault();
	const productId = document.querySelector("#product-id").value;
	const method = productId ? "PUT" : "POST";
	const endpoint = productId ? `/api/products/${productId}` : "/api/products";

	try {
		const response = await fetch(endpoint, {
			method,
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(getProductFormData()),
		});
		const result = await readResponse(response);
		if (!response.ok) throw new Error(result.error || "Не вдалося зберегти товар");
		productDialog.close();
		await loadProducts();
	} catch (error) {
		formError.textContent = error.message;
	}
}

async function deleteProduct(product) {
	if (!window.confirm(`Видалити товар «${product.product_name}»?`)) return;

	try {
		const response = await fetch(`/api/products/${product.product_id}`, { method: "DELETE" });
		if (!response.ok) {
			const result = await readResponse(response);
			throw new Error(result.error || "Не вдалося видалити товар");
		}
		await loadProducts();
	} catch (error) {
		tableStatus.textContent = error.message;
		tableStatus.classList.remove("d-none");
		tableStatus.classList.add("status-error");
	}
}

async function loadSuppliers() {
	const response = await fetch("/api/suppliers");
	if (!response.ok) throw new Error("Не вдалося завантажити постачальників");
	suppliers = await readResponse(response);
}

async function loadSupplierPreview() {
	const response = await fetch("/api/reports/supplier-products");
	if (!response.ok) throw new Error("Не вдалося завантажити звіт постачальників");
	supplierProducts = await readResponse(response);
	filterSupplierProducts();
}

function renderSupplierProducts(rows) {
	const body = document.querySelector("#supplier-preview-body");
	const status = document.querySelector("#supplier-preview-status");
	body.replaceChildren();
	rows.forEach((reportRow) => {
		const row = document.createElement("tr");
		row.append(
			createCell(reportRow.product_name),
			createCell(reportRow.company_name),
			createCell(reportRow.contact_person),
			createCell(reportRow.phone, "phone-value"),
			createCell(formatNumber(reportRow.stock_quantity), "text-end"),
		);
		body.append(row);
	});
	status.textContent = rows.length ? `${rows.length} товарів у звіті` : "За цим запитом товарів не знайдено.";
}

function filterSupplierProducts() {
	const query = searchInput.value.trim().toLowerCase();
	const filteredRows = supplierProducts.filter((reportRow) => [
		reportRow.product_name,
		reportRow.company_name,
		reportRow.contact_person,
		reportRow.phone,
	].some((value) => String(value || "").toLowerCase().includes(query))
		&& (!lowStockOnly || Number(reportRow.stock_quantity || 0) <= 10));
	renderSupplierProducts(filteredRows);
}

async function loadFinancialMetrics() {
	const response = await fetch("/api/reports/financial");
	if (!response.ok) throw new Error("Не вдалося завантажити фінансові показники");
	const financial = await readResponse(response);
	document.querySelector("#total-revenue").textContent = formatCurrency(financial.total_revenue);
	document.querySelector("#sale-count").textContent = formatNumber(financial.sale_count);
	document.querySelector("#average-check").textContent = formatCurrency(financial.average_check);
}

function renderRows(elementId, rows, columns) {
	const body = document.querySelector(`#${elementId}`);
	body.replaceChildren();
	rows.forEach((row) => {
		const tableRow = document.createElement("tr");
		columns.forEach((column) => {
			const cell = document.createElement("td");
			cell.textContent = column(row);
			tableRow.append(cell);
		});
		body.append(tableRow);
	});
}

async function loadReports() {
	try {
		const [supplierResponse, categoryResponse, financialResponse] = await Promise.all([
			fetch("/api/reports/supplier-products"),
			fetch("/api/reports/sales-by-category"),
			fetch("/api/reports/financial"),
		]);
		const supplierRows = await readResponse(supplierResponse);
		const categoryRows = await readResponse(categoryResponse);
		const financial = await readResponse(financialResponse);
		renderRows("supplier-products-body", supplierRows, [
			(row) => row.product_name,
			(row) => row.company_name,
			(row) => `${row.contact_person}, ${row.phone}`,
		]);
		renderRows("category-sales-body", categoryRows, [
			(row) => row.category,
			(row) => formatNumber(row.items_sold),
			(row) => formatCurrency(row.revenue),
		]);
		document.querySelector("#total-revenue").textContent = formatCurrency(financial.total_revenue);
		document.querySelector("#sale-count").textContent = formatNumber(financial.sale_count);
		document.querySelector("#average-check").textContent = formatCurrency(financial.average_check);
	} catch (error) {
		console.error(error);
	}
}

async function saveSupplier(event) {
	event.preventDefault();
	supplierFormError.textContent = "";
	try {
		const response = await fetch("/api/suppliers", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				company_name: document.querySelector("#company-name").value,
				phone: document.querySelector("#supplier-phone").value,
				contact_person: document.querySelector("#contact-person").value,
			}),
		});
		const result = await readResponse(response);
		if (!response.ok) throw new Error(result.error || "Не вдалося додати постачальника");
		supplierDialog.close();
		supplierForm.reset();
		await loadSuppliers();
		await loadSupplierPreview();
	} catch (error) {
		supplierFormError.textContent = error.message;
	}
}

function filterProducts() {
	const query = searchInput.value.trim().toLowerCase();
	const filteredProducts = products.filter((product) => (
		(!lowStockOnly || Number(product.stock_quantity || 0) <= 10)
		&& (String(product.product_name || "").toLowerCase().includes(query)
		|| String(product.category || "").toLowerCase().includes(query))
	));
	const sortedProducts = [...filteredProducts].sort((firstProduct, secondProduct) => {
		const firstValue = Number(firstProduct[sortState.key]);
		const secondValue = Number(secondProduct[sortState.key]);
		const difference = firstValue - secondValue;
		return sortState.direction === "asc" ? difference : -difference;
	});
	renderProducts(sortedProducts);
}

function setLowStockFilter(enabled) {
	lowStockOnly = enabled;
	const card = document.querySelector("#low-stock-card");
	card.classList.toggle("is-active", enabled);
	card.setAttribute("aria-pressed", String(enabled));
	handleSearch();
}

function updateCatalogTitle(view) {
	document.querySelector("#inventory-title").textContent = view === "suppliers"
		? "Товари та постачальники"
		: "Товари на складі";
}

function handleSearch() {
	const supplierViewIsActive = document.querySelector('[data-table-view="suppliers"]').classList.contains("is-active");
	if (supplierViewIsActive) filterSupplierProducts();
	else filterProducts();
}

function updateSortButtons() {
	document.querySelectorAll(".sort-button").forEach((button) => {
		const isActive = button.dataset.sort === sortState.key;
		const header = button.closest("th");
		const indicator = button.querySelector("span");
		button.classList.toggle("is-active", isActive);
		header.setAttribute("aria-sort", isActive
			? (sortState.direction === "asc" ? "ascending" : "descending")
			: "none");
		indicator.textContent = isActive ? (sortState.direction === "asc" ? "↑" : "↓") : "↕";
	});
}

function sortProducts(key) {
	if (sortState.key === key) {
		sortState.direction = sortState.direction === "asc" ? "desc" : "asc";
	} else {
		sortState = { key, direction: "asc" };
	}
	updateSortButtons();
	filterProducts();
}

async function loadProducts() {
	tableStatus.textContent = "Завантаження даних...";
	tableStatus.classList.remove("d-none", "status-error");
	refreshButton.disabled = true;

	try {
		const response = await fetch("/api/products");
		if (!response.ok) throw new Error("Помилка відповіді сервера");

		products = await response.json();
		updateMetrics(products);
		filterProducts();
	} catch (error) {
		tableBody.replaceChildren();
		tableStatus.textContent = "Не вдалося завантажити товари. Спробуйте оновити дані.";
		tableStatus.classList.add("status-error");
		updateMetrics([]);
		console.error(error);
	} finally {
		refreshButton.disabled = false;
	}
}

searchInput.addEventListener("input", handleSearch);
refreshButton.addEventListener("click", () => Promise.all([
	loadProducts(),
	loadSupplierPreview(),
	loadFinancialMetrics(),
]));
document.querySelectorAll(".sort-button").forEach((button) => {
	button.addEventListener("click", () => sortProducts(button.dataset.sort));
});
document.querySelectorAll(".switcher-button").forEach((button) => {
	button.addEventListener("click", () => {
		const view = button.dataset.tableView;
		document.querySelectorAll("[data-table-view]").forEach((tab) => {
			tab.classList.toggle("is-active", tab === button);
			tab.setAttribute("aria-selected", tab === button ? "true" : "false");
		});
		document.querySelector("#inventory-view").hidden = view !== "inventory";
		document.querySelector("#suppliers-view").hidden = view !== "suppliers";
		updateCatalogTitle(view);
		handleSearch();
	});
});
document.querySelector("#low-stock-card").addEventListener("click", () => setLowStockFilter(!lowStockOnly));
document.querySelector("#low-stock-card").addEventListener("keydown", (event) => {
	if (event.key === "Enter" || event.key === " ") setLowStockFilter(!lowStockOnly);
});
document.querySelector("#add-product-button").addEventListener("click", () => openProductForm());
document.querySelector("#add-supplier-button").addEventListener("click", () => supplierDialog.showModal());
document.querySelector("#close-dialog-button").addEventListener("click", () => productDialog.close());
document.querySelector("#cancel-dialog-button").addEventListener("click", () => productDialog.close());
document.querySelector("#close-supplier-button").addEventListener("click", () => supplierDialog.close());
document.querySelector("#cancel-supplier-button").addEventListener("click", () => supplierDialog.close());
productForm.addEventListener("submit", saveProduct);
supplierForm.addEventListener("submit", saveSupplier);
Promise.all([loadSuppliers(), loadProducts(), loadSupplierPreview(), loadFinancialMetrics()]).catch((error) => console.error(error));
