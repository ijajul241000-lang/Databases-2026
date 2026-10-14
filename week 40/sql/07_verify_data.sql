-- Check that all six required TrailShop tables exist and contain the sample rows.
SELECT * FROM categories ORDER BY category_id;
SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM products ORDER BY product_id;
SELECT * FROM product_categories ORDER BY product_id, category_id;
SELECT * FROM orders ORDER BY order_id;
SELECT * FROM order_items ORDER BY order_item_id;

-- Verify every product has at least one category.
SELECT p.product_id, p.name
FROM products p
LEFT JOIN product_categories pc ON pc.product_id = p.product_id
WHERE pc.product_id IS NULL;
-- Expected result: zero rows.

-- Counts for the submission checklist.
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_categories', COUNT(*) FROM product_categories
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
