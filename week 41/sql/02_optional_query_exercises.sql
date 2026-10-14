

-- 3.1: Products with stock less than 15
SELECT name, price
FROM products
WHERE stock < 15
ORDER BY name;

-- 3.2: Customers registered in 2026
SELECT first_name, last_name, created_at::date AS registration_date
FROM customers
WHERE created_at >= TIMESTAMPTZ '2026-01-01 00:00:00+00'
  AND created_at <  TIMESTAMPTZ '2027-01-01 00:00:00+00'
ORDER BY created_at;

-- 3.3: Products without descriptions
SELECT product_id, name
FROM products
WHERE description IS NULL;

-- 3.4: Products in category 1 or 2 priced above 100 and in stock
SELECT p.product_id, p.name, p.price, p.stock
FROM products p
WHERE p.price > 100
  AND p.stock > 0
  AND EXISTS (
      SELECT 1
      FROM product_categories pc
      WHERE pc.product_id = p.product_id
        AND pc.category_id IN (1, 2)
  )
ORDER BY p.price DESC;

-- 3.5: Delivered orders or orders from customer 1
SELECT order_id, customer_id, status
FROM orders
WHERE status = 'delivered'
   OR customer_id = 1
ORDER BY order_id;

-- 3.6: Minimum, maximum, and average price per category
SELECT c.name AS category_name,
       MIN(p.price) AS minimum_price,
       MAX(p.price) AS maximum_price,
       ROUND(AVG(p.price), 2) AS average_price
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN products p ON p.product_id = pc.product_id
GROUP BY c.category_id, c.name
ORDER BY c.name;

-- 3.7: Count of customers who placed orders
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders;

-- 3.8: Total quantity sold
SELECT COALESCE(SUM(quantity), 0) AS total_quantity_sold
FROM order_items;

-- 3.9: All products with category names, including unlinked products
SELECT p.name AS product_name, c.name AS category_name
FROM products p
LEFT JOIN product_categories pc ON pc.product_id = p.product_id
LEFT JOIN categories c ON c.category_id = pc.category_id
ORDER BY p.name, c.name;

-- 3.10: Order item counts and order totals
SELECT o.order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       o.order_date,
       COALESCE(SUM(oi.quantity), 0) AS number_of_items,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.order_date
ORDER BY o.order_id;

-- 3.11: Products never ordered
SELECT p.product_id, p.name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.name;

-- 3.12: Categories with average price above 100
SELECT c.name AS category_name,
       ROUND(AVG(p.price), 2) AS average_price
FROM categories c
JOIN product_categories pc ON pc.category_id = c.category_id
JOIN products p ON p.product_id = pc.product_id
GROUP BY c.category_id, c.name
HAVING AVG(p.price) > 100
ORDER BY average_price DESC;

-- 3.13: Customers with more than one order
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

-- 3.14: Page 2 of products, page size 3
SELECT product_id, name, price, stock
FROM products
ORDER BY product_id
LIMIT 3 OFFSET 3;

-- 3.15: Sales summary by category
SELECT c.name AS category_name,
       COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue,
       COUNT(DISTINCT oi.product_id) AS distinct_products_sold
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN order_items oi ON oi.product_id = pc.product_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC, c.name;
