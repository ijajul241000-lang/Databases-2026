-- Run in the trailshop database after inserting sample data.
SELECT * FROM categories ORDER BY category_id;
SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM products ORDER BY product_id;
SELECT * FROM product_categories ORDER BY category_id, product_id;
SELECT * FROM orders ORDER BY order_id;
SELECT * FROM order_items ORDER BY order_item_id;

SELECT COUNT(*) AS category_count FROM categories;
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS product_count FROM products;
SELECT COUNT(*) AS product_category_link_count FROM product_categories;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS order_item_count FROM order_items;
