
UPDATE products AS p
SET price = ROUND(p.price * 1.10, 2)
FROM product_categories AS pc
JOIN categories AS c ON c.category_id = pc.category_id
WHERE pc.product_id = p.product_id
  AND c.name = 'Footwear';

SELECT p.product_id, p.name, p.price
FROM products AS p
JOIN product_categories AS pc ON pc.product_id = p.product_id
JOIN categories AS c ON c.category_id = pc.category_id
WHERE c.name = 'Footwear'
ORDER BY p.product_id;

-- 2. Change customer #3's email (assumes the sample data was inserted into an empty database).
UPDATE customers
SET email = 'eero.lahtinen.new@email.com'
WHERE customer_id = 3;
SELECT * FROM customers WHERE customer_id = 3;

-- 3. Change order #2 from shipped to delivered.
UPDATE orders
SET status = 'delivered'
WHERE order_id = 2 AND status = 'shipped';
SELECT * FROM orders WHERE order_id = 2;

-- 4. Set HydroFlask 1L stock to 85.
UPDATE products
SET stock = 85
WHERE name = 'HydroFlask 1L';
SELECT name, stock FROM products WHERE name = 'HydroFlask 1L';

-- 5. Add a description to the first product whose description is NULL (Headlamp in seed data).
UPDATE products
SET description = 'A useful outdoor product for hiking and camping'
WHERE product_id = (
    SELECT product_id
    FROM products
    WHERE description IS NULL
    ORDER BY product_id
    LIMIT 1
);
SELECT product_id, name, description
FROM products
WHERE description IS NULL;
