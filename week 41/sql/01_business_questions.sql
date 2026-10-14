-- Week 41 Exercise 1: TrailShop business questions
-- Run against the Week 40 trailshop database. Read-only SELECT queries.

-- 1. Products in Footwear
SELECT p.name, p.price, p.stock
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id
WHERE c.name = 'Footwear'
ORDER BY p.name;

-- 2. Products priced between 50 and 150
SELECT name, price
FROM products
WHERE price BETWEEN 50 AND 150
ORDER BY price ASC;

-- 3. Customer last names beginning M or K
SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE 'M%'
   OR last_name LIKE 'K%'
ORDER BY last_name, first_name;

-- 4. Pending or shipped orders, newest first
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status IN ('pending', 'shipped')
ORDER BY order_date DESC;

-- 5. Product names containing Pro/pro
SELECT name, price, stock
FROM products
WHERE name ILIKE '%pro%'
ORDER BY name;

-- 6. Total product count
SELECT COUNT(*) AS total_products
FROM products;

-- 7. Average product price
SELECT ROUND(AVG(price), 2) AS average_price
FROM products;

-- 8. Most expensive and cheapest products
SELECT 'Most expensive' AS price_type, name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products)
UNION ALL
SELECT 'Cheapest' AS price_type, name, price
FROM products
WHERE price = (SELECT MIN(price) FROM products);

-- 9. Order count per customer
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY order_count DESC, c.last_name, c.first_name;

-- 10. Revenue by order status
SELECT o.status,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.status
ORDER BY o.status;

-- 11. Products with category names
SELECT p.name AS product_name, c.name AS category_name
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories c ON c.category_id = pc.category_id
ORDER BY c.name, p.name;

-- 12. Orders with customer names
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       o.order_date,
       o.status
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- 13. Detailed items in order 1
SELECT p.name AS product_name,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
WHERE oi.order_id = 1
ORDER BY p.name;

-- 14. Customers with no orders
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.last_name, c.first_name;

-- 15. Category inventory summary over 500
SELECT c.name AS category_name,
       COUNT(p.product_id) AS number_of_products,
       ROUND(AVG(p.price), 2) AS average_price,
       SUM(p.price * p.stock) AS total_inventory_value
FROM categories c
JOIN product_categories pc ON pc.category_id = c.category_id
JOIN products p ON p.product_id = pc.product_id
GROUP BY c.category_id, c.name
HAVING SUM(p.price * p.stock) > 500
ORDER BY total_inventory_value DESC;
