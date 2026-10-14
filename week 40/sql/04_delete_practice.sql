
BEGIN;
WITH latest_order AS (
    SELECT order_id
    FROM orders
    ORDER BY order_date DESC, order_id DESC
    LIMIT 1
)
DELETE FROM orders
WHERE order_id IN (SELECT order_id FROM latest_order);
-- ON DELETE CASCADE removes the linked order_items for this transaction.
SELECT * FROM order_items ORDER BY order_id, order_item_id;
ROLLBACK;

-- 2. Confirm which products are referenced by order_items.
SELECT p.product_id, p.name
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
ORDER BY p.product_id;
-- Intentionally not executed: the next statement should fail with a foreign-key
-- violation because order_items references the product with ON DELETE RESTRICT.
-- DELETE FROM products WHERE product_id = 1;

-- 3. Deleting a category removes product-category links but not products.
BEGIN;
DELETE FROM categories WHERE name = 'Accessories';
SELECT * FROM product_categories;
SELECT * FROM products ORDER BY product_id;
ROLLBACK;

-- 4. Create a customer with no orders, demonstrate deleting them, then undo both.
BEGIN;
INSERT INTO customers (name, email)
VALUES ('Test Customer', 'test.customer@email.com');
SELECT customer_id, name, email
FROM customers
WHERE email = 'test.customer@email.com';
DELETE FROM customers
WHERE email = 'test.customer@email.com';
SELECT * FROM customers WHERE email = 'test.customer@email.com';
ROLLBACK;
