-- 1) CREATE DATABASE
IF DB_ID('store_db') IS NOT NULL
    DROP DATABASE store_db;
GO
CREATE DATABASE store_db;
GO
USE store_db;
GO

-- 2) TABLES
IF OBJECT_ID('sales', 'U') IS NOT NULL DROP TABLE sales;
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
GO

CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
        CONSTRAINT chk_price CHECK (price >= 0)
);

CREATE TABLE customers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE sales (
    id INT IDENTITY(1,1) PRIMARY KEY,
    sale_date DATE NOT NULL,
    product_id INT NOT NULL FOREIGN KEY REFERENCES products(id),
    customer_id INT NOT NULL FOREIGN KEY REFERENCES customers(id),
    qty INT NOT NULL
        CONSTRAINT chk_qty CHECK (qty > 0)
);

-- 3) DATA
INSERT INTO products (name, category, price) VALUES
 ('Ofada Rice 1kg', 'Grains', 3750.00),
 ('Palm Oil 1L', 'Groceries', 2200.00),
 ('Garri 2kg', 'Grains', 2600.00),
 ('Beans (Brown) 1kg', 'Grains', 1800.00),
 ('Spaghetti 500g', 'Pasta', 950.00),
 ('Tomato Paste 70g', 'Canned', 350.00),
 ('Soft Drink 50cl', 'Beverages', 400.00),
 ('Bottled Water 75cl', 'Beverages', 250.00),
 ('Yam Tubers (Medium)', 'Produce', 1800.00),
 ('Groundnut Oil 1L', 'Groceries', 2500.00);

INSERT INTO customers (first_name, last_name, email) VALUES
 ('Oluwaseun', 'Adeniyi', 'seun@example.com'),
 ('Amara', 'Okafor', 'amara@example.com'),
 ('Babatunde', 'Akinloye', 'baba@example.com'),
 ('Zainab', 'Musa', 'zainab@example.com'),
 ('Ngozi', 'Eze', 'ngozi@example.com'),
 ('Ibrahim', 'Lawal', 'ibrahim@example.com'); -- No purchases (for Q7)

INSERT INTO sales (sale_date, product_id, customer_id, qty) VALUES
 ('2025-08-22', 1, 1, 2),
 ('2025-08-22', 7, 2, 3),
 ('2025-08-23', 3, 3, 1),
 ('2025-08-23', 10, 4, 2),
 ('2025-08-24', 1, 5, 1),
 ('2025-08-24', 5, 1, 4),
 ('2025-08-25', 6, 2, 5),
 ('2025-08-25', 8, 3, 6),
 ('2025-08-26', 2, 4, 2),
 ('2025-08-26', 9, 5, 1),
 ('2025-08-26', 7, 1, 2),
 ('2025-08-27', 10, 2, 1),
 ('2025-08-27', 4, 3, 3),
 ('2025-08-27', 5, 4, 2),
 ('2025-08-28', 1, 5, 3),
 ('2025-08-28', 8, 1, 5);

-- 4) QUERIES (Q1–Q8)

-- Q1. List all products with price, sorted by price highest to lowest.
SELECT name, price FROM products ORDER BY price DESC;

-- Q2. Find all customers with last name = 'YourChoice'
-- Example:
SELECT id, first_name, last_name, email FROM customers WHERE last_name = 'Okafor';

-- Q3. Show all sales on a specific date (e.g., '2025-08-26')
SELECT s.id,
        s.sale_date,
        p.name AS product,
        CONCAT(c.first_name, ' ', c.last_name) AS customer,
        s.qty,
        p.price,
        (s.qty * p.price) AS line_total
FROM sales s
JOIN products p ON p.id = s.product_id
JOIN customers c ON c.id = s.customer_id
WHERE s.sale_date = '2025-08-26'
ORDER BY s.id;

-- Q4. Total quantity sold per product
SELECT p.name,
        SUM(s.qty) AS total_qty
FROM sales s
JOIN products p ON p.id = s.product_id
GROUP BY p.id, p.name
ORDER BY total_qty DESC;

-- Q5. Total spend per customer
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,
        ROUND(SUM(s.qty * p.price), 2) AS total_spend
FROM customers c
JOIN sales s   ON s.customer_id = c.id
JOIN products p ON p.id = s.product_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spend DESC;

-- Q6. Top 3 best-selling categories by quantity
SELECT TOP 3 p.category,
        SUM(s.qty) AS total_qty
FROM sales s
JOIN products p ON p.id = s.product_id
GROUP BY p.category
ORDER BY total_qty DESC;

-- Q7. Customers with NO purchases
SELECT c.id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN sales s ON s.customer_id = c.id
WHERE s.id IS NULL;

-- Q8. Daily revenue
SELECT s.sale_date,
        ROUND(SUM(s.qty * p.price), 2) AS total_revenue
FROM sales s
JOIN products p ON p.id = s.product_id
GROUP BY s.sale_date
ORDER BY s.sale_date;
