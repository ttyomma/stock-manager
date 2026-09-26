const formatCurrency = (value) => new Intl.NumberFormat("uk-UA", {
	style: "currency",
	currency: "UAH",
	maximumFractionDigits: 0,
}).format(Number(value) || 0);

const formatNumber = (value) => new Intl.NumberFormat("uk-UA").format(Number(value) || 0);

async function readResponse(response) {
	const contentType = response.headers.get("content-type") || "";
	if (contentType.includes("application/json")) return response.json();
	await response.text();
	throw new Error(`Помилка сервера (${response.status})`);
}

function renderRows(elementId, rows, columns) {
	const body = document.querySelector(`#${elementId}`);
	body.replaceChildren();
	rows.forEach((row) => {
		const tableRow = document.createElement("tr");
		columns.forEach((column) => {
			const cell = document.createElement("td");
			const value = column(row);
			if (value instanceof Node) cell.append(value);
			else cell.textContent = value;
			tableRow.append(cell);
		});
		body.append(tableRow);
	});
}

function createPhone(phone) {
	const phoneElement = document.createElement("span");
	phoneElement.className = "phone-value";
	phoneElement.textContent = phone || "—";
	phoneElement.title = "Наведіть курсор, щоб показати номер";
	return phoneElement;
}

function renderSupplierReport(rows) {
	renderRows("supplier-products-body", rows, [
		(row) => row.product_name,
		(row) => row.company_name,
		(row) => {
			const contact = document.createElement("span");
			contact.textContent = `${row.contact_person}, `;
			contact.append(createPhone(row.phone));
			return contact;
		},
	]);
}

function renderSales(rows) {
	const body = document.querySelector("#sales-body");
	body.replaceChildren();
	rows.forEach((sale) => {
		const row = document.createElement("tr");
		row.className = "receipt-row";
		row.tabIndex = 0;
		row.setAttribute("role", "button");
		row.append(
			createCell(sale.sale_id),
			createCell(sale.customer_name || "Звичайний покупець"),
			createCell(new Date(sale.sale_date).toLocaleString("uk-UA")),
			createCell(formatCurrency(sale.total_amount), "text-end"),
		);
		const actionCell = createCell("Переглянути", "text-end table-action edit-action");
		row.append(actionCell);
		row.addEventListener("click", () => openReceipt(sale.sale_id));
		row.addEventListener("keydown", (event) => {
			if (event.key === "Enter" || event.key === " ") openReceipt(sale.sale_id);
		});
		body.append(row);
	});
}

function createCell(value, className = "") {
	const cell = document.createElement("td");
	cell.textContent = value;
	if (className) cell.className = className;
	return cell;
}

async function openReceipt(saleId) {
	const dialog = document.querySelector("#receipt-dialog");
	const itemsBody = document.querySelector("#receipt-items-body");
	itemsBody.replaceChildren();
	document.querySelector("#receipt-title").textContent = `Чек №${saleId}`;
	document.querySelector("#receipt-meta").textContent = "Завантаження деталей...";
	dialog.showModal();

	try {
		const response = await fetch(`/api/reports/sales/${saleId}`);
		const result = await readResponse(response);
		if (!response.ok) throw new Error(result.error || "Не вдалося завантажити чек");
		document.querySelector("#receipt-meta").textContent = `${result.sale.customer_name || "Звичайний покупець"} · ${new Date(result.sale.sale_date).toLocaleString("uk-UA")} · ${formatCurrency(result.sale.total_amount)}`;
		result.items.forEach((item) => {
			const row = document.createElement("tr");
			row.append(
				createCell(item.product_name),
				createCell(formatNumber(item.quantity)),
				createCell(formatCurrency(item.unit_price), "text-end"),
				createCell(formatCurrency(item.line_total), "text-end"),
			);
			itemsBody.append(row);
		});
	} catch (error) {
		document.querySelector("#receipt-meta").textContent = error.message;
	}
}

async function loadReports() {
	const status = document.querySelector("#sales-status");
	try {
		const [categoryResponse, salesResponse] = await Promise.all([
			fetch("/api/reports/sales-by-category"),
			fetch("/api/reports/sales"),
		]);
		const categoryRows = await readResponse(categoryResponse);
		const sales = await readResponse(salesResponse);
		renderRows("category-sales-body", categoryRows, [
			(row) => row.category,
			(row) => formatNumber(row.items_sold),
			(row) => formatCurrency(row.revenue),
		]);
		renderSales(sales);
		status.classList.add("d-none");
	} catch (error) {
		status.textContent = error.message;
		status.classList.add("status-error");
	}
}

document.querySelector("#refresh-reports-button").addEventListener("click", loadReports);
document.querySelector("#close-receipt-button").addEventListener("click", () => document.querySelector("#receipt-dialog").close());
document.querySelectorAll("[data-report-view]").forEach((button) => {
	button.addEventListener("click", () => {
		const view = button.dataset.reportView;
		document.querySelectorAll("[data-report-view]").forEach((tab) => {
			tab.classList.toggle("is-active", tab === button);
			tab.setAttribute("aria-selected", tab === button ? "true" : "false");
		});
		document.querySelector("#analytics-view").hidden = view !== "analytics";
		document.querySelector("#receipts-view").hidden = view !== "receipts";
	});
});
loadReports();
