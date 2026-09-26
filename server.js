const dotenv = require("dotenv");
const express = require("express");
const { Pool } = require("pg");

dotenv.config();

const pool = new Pool({
	host: process.env.DB_HOST,
	port: process.env.DB_PORT,
	user: process.env.DB_USER,
	password: process.env.DB_PASSWORD,
	database: process.env.DB_NAME,
});

const app = express();

app.use(express.json());
app.use(express.static("public"));

app.get("/api/products", async (req, res) => {
	try {
		const result = await pool.query("SELECT * FROM trade.product ORDER BY product_id ASC");
		res.json(result.rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося отримати список товарів" });
	}
});

app.get("/api/suppliers", async (req, res) => {
	try {
		const result = await pool.query("SELECT * FROM trade.supplier ORDER BY company_name ASC");
		res.json(result.rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося отримати список постачальників" });
	}
});

app.post("/api/suppliers", async (req, res) => {
	const { company_name, phone, contact_person } = req.body;
	if (!company_name || !phone || !contact_person) {
		return res.status(400).json({ error: "Заповніть усі дані постачальника" });
	}

	try {
		const result = await pool.query(
			`INSERT INTO trade.supplier (company_name, phone, contact_person)
			 VALUES ($1, $2, $3) RETURNING *`,
			[company_name.trim(), phone.trim(), contact_person.trim()],
		);
		res.status(201).json(result.rows[0]);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося додати постачальника" });
	}
});

app.get("/api/reports/supplier-products", async (req, res) => {
	try {
		const result = await pool.query(
			`SELECT p.product_id, p.product_name, p.category, p.stock_quantity,
			        s.company_name, s.phone, s.contact_person
			 FROM trade.product p
			 JOIN trade.supplier s ON s.supplier_id = p.supplier_id
			 ORDER BY p.product_id ASC`,
		);
		res.json(result.rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося сформувати звіт постачальників" });
	}
});

app.get("/api/reports/sales-by-category", async (req, res) => {
	try {
		const result = await pool.query(
			`SELECT p.category,
			        COALESCE(SUM(si.quantity), 0)::integer AS items_sold,
			        COALESCE(SUM(si.quantity * si.unit_price), 0)::numeric(12, 2) AS revenue
			 FROM trade.sale_item si
			 JOIN trade.product p ON p.product_id = si.product_id
			 GROUP BY p.category
			 ORDER BY revenue DESC`,
		);
		res.json(result.rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося сформувати звіт продажів" });
	}
});

app.get("/api/reports/financial", async (req, res) => {
	try {
		const result = await pool.query(
			`SELECT COALESCE(SUM(total_amount), 0)::numeric(12, 2) AS total_revenue,
			        COUNT(*)::integer AS sale_count,
			        COALESCE(AVG(total_amount), 0)::numeric(12, 2) AS average_check
			 FROM trade.sale`,
		);
		res.json(result.rows[0]);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося сформувати фінансовий звіт" });
	}
});

app.get("/api/reports/sales", async (req, res) => {
	try {
		const result = await pool.query(
			`SELECT sale_id, customer_name, sale_date, total_amount
			 FROM trade.sale
			 ORDER BY sale_date DESC, sale_id DESC`,
		);
		res.json(result.rows);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося отримати список чеків" });
	}
});

app.get("/api/reports/sales/:id", async (req, res) => {
	try {
		const saleResult = await pool.query(
			`SELECT sale_id, customer_name, sale_date, total_amount
			 FROM trade.sale WHERE sale_id = $1`,
			[req.params.id],
		);
		if (!saleResult.rowCount) return res.status(404).json({ error: "Чек не знайдено" });

		const itemsResult = await pool.query(
			`SELECT si.sale_item_id, si.product_id, p.product_name, p.category,
			        si.quantity, si.unit_price,
			        (si.quantity * si.unit_price)::numeric(12, 2) AS line_total
			 FROM trade.sale_item si
			 JOIN trade.product p ON p.product_id = si.product_id
			 WHERE si.sale_id = $1
			 ORDER BY si.sale_item_id ASC`,
			[req.params.id],
		);
		res.json({ sale: saleResult.rows[0], items: itemsResult.rows });
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося отримати деталі чека" });
	}
});

function validateProduct(product) {
	const requiredFields = ["supplier_id", "product_name", "category", "purchase_price", "sale_price", "stock_quantity"];
	return requiredFields.every((field) => product[field] !== undefined && product[field] !== "");
}

app.post("/api/products", async (req, res) => {
	if (!validateProduct(req.body)) {
		return res.status(400).json({ error: "Заповніть усі поля товару" });
	}

	const { supplier_id, product_name, category, purchase_price, sale_price, stock_quantity } = req.body;
	try {
		const result = await pool.query(
			`INSERT INTO trade.product
			(supplier_id, product_name, category, purchase_price, sale_price, stock_quantity)
			VALUES ($1, $2, $3, $4, $5, $6)
			 RETURNING *`,
			[supplier_id, product_name, category, purchase_price, sale_price, stock_quantity],
		);
		res.status(201).json(result.rows[0]);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося додати товар" });
	}
});

app.put("/api/products/:id", async (req, res) => {
	if (!validateProduct(req.body)) {
		return res.status(400).json({ error: "Заповніть усі поля товару" });
	}

	const { supplier_id, product_name, category, purchase_price, sale_price, stock_quantity } = req.body;
	try {
		const result = await pool.query(
			`UPDATE trade.product
			SET supplier_id = $1, product_name = $2, category = $3,
			purchase_price = $4, sale_price = $5, stock_quantity = $6
			WHERE product_id = $7
			 RETURNING *`,
			[supplier_id, product_name, category, purchase_price, sale_price, stock_quantity, req.params.id],
		);
		if (!result.rowCount) return res.status(404).json({ error: "Товар не знайдено" });
		res.json(result.rows[0]);
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося оновити товар" });
	}
});

app.delete("/api/products/:id", async (req, res) => {
	try {
		const result = await pool.query(
			"DELETE FROM trade.product WHERE product_id = $1 RETURNING product_id",
			[req.params.id],
		);
		if (!result.rowCount) return res.status(404).json({ error: "Товар не знайдено" });
		res.status(204).send();
	} catch (error) {
		console.error(error);
		res.status(500).json({ error: "Не вдалося видалити товар" });
	}
});

app.listen(3000, () => {
	console.log("Server started on port 3000");
});
