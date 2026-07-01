CREATE DATABASE retail_db;
USE retail_db;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(20)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    sales_amount DECIMAL(10,2),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

SELECT * FROM customers LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM orders LIMIT 5;

-- Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

--  Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Total Products
SELECT COUNT(*) AS total_products
FROM products;

-- Total Products Sold
SELECT SUM(quantity)
FROM orders;

-- Total Revenue
SELECT SUM(sales_amount) AS total_revenue
FROM orders;
-- Unique Customers
SELECT COUNT(DISTINCT customer_id)
AS unique_customers
FROM orders;

-- Average Order Value
SELECT AVG(sales_amount)
FROM orders;

-- Maximum Sale
SELECT MAX(sales_amount)
FROM orders;

-- Minimum Sale
SELECT MIN(sales_amount)
FROM orders;

-- Total Units Sold
SELECT SUM(quantity)
AS total_units_sold
FROM orders;

-- Monthly Revenue
SELECT
MONTH(order_date) month_no,
SUM(sales_amount) revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month_no;

-- Monthly Orders
SELECT
MONTH(order_date),
COUNT(*)
FROM orders
GROUP BY MONTH(order_date);

-- Yearly Revenue
SELECT
YEAR(order_date),
SUM(sales_amount)
FROM orders
GROUP BY YEAR(order_date);

-- Quarterly Revenue
SELECT
QUARTER(order_date),
SUM(sales_amount)
FROM orders
GROUP BY QUARTER(order_date);

-- Best Revenue Month
SELECT
MONTH(order_date),
SUM(sales_amount) revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY revenue DESC
LIMIT 1;

-- Worst Revenue Month
SELECT
MONTH(order_date),
SUM(sales_amount) revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY revenue
LIMIT 1;

-- Average Monthly Revenue
SELECT AVG(monthly_revenue)
FROM
(SELECT
MONTH(order_date),
SUM(sales_amount) monthly_revenue
FROM orders
GROUP BY MONTH(order_date)) t;

-- Top 10 Products By Revenue
SELECT
c.customer_name,
SUM(o.sales_amount) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- Category Contribution %
SELECT
p.category,
ROUND(
100*SUM(o.sales_amount)/
(SUM(SUM(o.sales_amount)) OVER()),
2
) contribution_pct
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY p.category;

-- Product Revenue Ranking
SELECT
product_id,
SUM(sales_amount),
RANK() OVER(ORDER BY 
SUM(sales_amount) DESC
) product_rank
FROM orders
GROUP BY product_id;

-- Average Product Revenue
SELECT AVG(product_revenue)
FROM(SELECT product_id,
SUM(sales_amount) product_revenue
FROM orders
GROUP BY product_id)t;

-- Most Sold Product
SELECT
p.product_name,
SUM(o.quantity) qty
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY p.product_name
ORDER BY qty DESC
LIMIT 1;

-- Revenue By Category
SELECT
p.category,
SUM(o.sales_amount)
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY p.category;
select  * from customers;

-- Monthly Revenue Trend
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS month,
SUM(sales_amount) AS revenue
FROM orders
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY month;

-- Query 22: Revenue By State
SELECT
c.state,
SUM(o.sales_amount) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.state
ORDER BY revenue DESC;

-- Query 23: Revenue By City
SELECT
c.city,
SUM(o.sales_amount) AS revenue
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- Query 24: Dense Rank Customers
SELECT
customer_id,
SUM(sales_amount) AS revenue,
DENSE_RANK() OVER(
ORDER BY SUM(sales_amount) DESC
) AS customer_rank
FROM orders
GROUP BY customer_id;

-- Bottom 10 Products By Revenue
SELECT
p.product_name,
SUM(o.sales_amount) revenue
FROM orders o
JOIN products p
ON o.product_id=p.product_id
GROUP BY p.product_name
ORDER BY revenue ASC
LIMIT 10;

-- Customer Lifetime Value
SELECT customer_id,
SUM(sales_amount) AS lifetime_value
FROM orders
GROUP BY customer_id
ORDER BY lifetime_value DESC;

-- Revenue By Segment
SELECT
c.segment,
SUM(o.sales_amount)
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.segment;

-- Revenue By Region
SELECT
c.region,
SUM(o.sales_amount)
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.region;

-- Customer Rank
SELECT
customer_id,
SUM(sales_amount) AS revenue,
ROW_NUMBER() OVER(
ORDER BY SUM(sales_amount) DESC
) AS rn
FROM orders
GROUP BY customer_id;

-- Monthly Sales CTE
WITH monthly_sales AS
(SELECT MONTH(order_date) AS month_no,
SUM(sales_amount) AS revenue
FROM orders
GROUP BY MONTH(order_date))
SELECT * FROM monthly_sales;

-- Running Total Revenue
SELECT order_date,
SUM(sales_amount) AS revenue,
SUM(SUM(sales_amount))
OVER(ORDER BY order_date)
AS running_total
FROM orders
GROUP BY order_date;

