# Store Database Project

## 📌 Overview

This project demonstrates how to design and query a simple retail sales database in **SQL Server** using **SSMS (SQL Server Management Studio)**.
The database simulates a small store selling groceries, beverages, and produce.

It includes:

* **Products**: items sold by the store
* **Customers**: registered buyers
* **Sales**: transactions linking products and customers

The project also provides practice queries (Q1–Q8) to analyze sales and customer data.

---

## 🗄 Database Schema

### Tables

1. **products**

   * `id` (PK, identity)
   * `name` (varchar)
   * `category` (varchar)
   * `price` (decimal, with constraint `price >= 0`)

2. **customers**

   * `id` (PK, identity)
   * `first_name` (varchar)
   * `last_name` (varchar)
   * `email` (unique)

3. **sales**

   * `id` (PK, identity)
   * `sale_date` (date)
   * `product_id` (FK → products.id)
   * `customer_id` (FK → customers.id)
   * `qty` (int, with constraint `qty > 0`)

---

## ⚙️ Setup Instructions

1. Open **SQL Server Management Studio (SSMS)**.
2. Create a new query window.
3. Copy & paste the SQL script (`store_db.sql`).
4. Execute the script:

   * Creates the database `store_db`.
   * Creates the `products`, `customers`, and `sales` tables.
   * Inserts sample data.

---

## 🔍 Exercises (Queries)

Run these one by one to answer the lab questions:

1. **List all products sorted by price (high → low).**

   ```sql
   SELECT name, price 
   FROM products 
   ORDER BY price DESC;
   ```

2. **Find all customers with a given last name (e.g., 'Okafor').**

   ```sql
   SELECT id, first_name, last_name, email 
   FROM customers 
   WHERE last_name = 'Okafor';
   ```

3. **Show all sales on a specific date (e.g., '2025-08-26').**

   ```sql
   SELECT s.id, s.sale_date, p.name AS product,
          CONCAT(c.first_name, ' ', c.last_name) AS customer,
          s.qty, p.price, (s.qty * p.price) AS line_total
   FROM sales s
   JOIN products p ON p.id = s.product_id
   JOIN customers c ON c.id = s.customer_id
   WHERE s.sale_date = '2025-08-26'
   ORDER BY s.id;
   ```

4. **Total quantity sold per product.**

   ```sql
   SELECT p.name, SUM(s.qty) AS total_qty
   FROM sales s
   JOIN products p ON p.id = s.product_id
   GROUP BY p.id, p.name
   ORDER BY total_qty DESC;
   ```

5. **Total spend per customer.**

   ```sql
   SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,
          ROUND(SUM(s.qty * p.price), 2) AS total_spend
   FROM customers c
   JOIN sales s ON s.customer_id = c.id
   JOIN products p ON p.id = s.product_id
   GROUP BY c.id, c.first_name, c.last_name
   ORDER BY total_spend DESC;
   ```

6. **Top 3 best-selling categories by quantity.**

   ```sql
   SELECT TOP 3 p.category, SUM(s.qty) AS total_qty
   FROM sales s
   JOIN products p ON p.id = s.product_id
   GROUP BY p.category
   ORDER BY total_qty DESC;
   ```

7. **Customers with no purchases.**

   ```sql
   SELECT c.id, c.first_name, c.last_name, c.email
   FROM customers c
   LEFT JOIN sales s ON s.customer_id = c.id
   WHERE s.id IS NULL;
   ```

8. **Daily revenue.**

   ```sql
   SELECT s.sale_date, ROUND(SUM(s.qty * p.price), 2) AS total_revenue
   FROM sales s
   JOIN products p ON p.id = s.product_id
   GROUP BY s.sale_date
   ORDER BY s.sale_date;
   ```

---

## 📷 Deliverables

* Execute each query (Q1–Q8) in SSMS.
* Take **screenshots of the results**.
* Combine all screenshots into **one Word/PDF document** for submission.

---

## ✅ Notes

* Script uses **IDENTITY(1,1)** for auto-increment.
* `TOP 3` is used instead of `LIMIT` (SQL Server syntax).
* Constraints (`CHECK`) ensure valid prices and quantities.
* Sample data covers multiple products, repeat customers, and one customer with no purchases (for Q7).
