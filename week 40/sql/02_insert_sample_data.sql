

BEGIN;

INSERT INTO categories (name, description) VALUES
    ('Footwear', 'Shoes and boots for outdoor activities'),
    ('Backpacks', 'Packs and bags for travel and hiking'),
    ('Tents', 'Shelters for camping'),
    ('Clothing', 'Outdoor clothing and layers'),
    ('Accessories', 'Useful outdoor accessories');

-- The first five customers have one order each. The sixth has no orders and is
-- included for the customer-delete practice task.
INSERT INTO customers (name, email) VALUES
    ('Mikko Korhonen', 'mikko.korhonen@email.com'),
    ('Anna Virtanen', 'anna.virtanen@email.com'),
    ('Eero Lahtinen', 'eero.lahtinen@email.com'),
    ('Maria Salminen', 'maria.salminen@email.com'),
    ('Petri Kallio', 'petri.kallio@email.com'),
    ('Liisa Niemi', 'liisa.niemi@email.com');

INSERT INTO products (name, description, price, stock) VALUES
    ('Trail Runner Shoes', 'Lightweight shoes for trail running', 89.99, 25),
    ('Hiking Boots', 'Water-resistant boots for hiking', 149.99, 12),
    ('Daypack 20L', 'Small backpack for day trips', 49.99, 40),
    ('Trekking Backpack 50L', 'Large backpack for multi-day hikes', 179.99, 8),
    ('Solo Tent', 'Lightweight one-person tent', 199.99, 7),
    ('Family Tent', 'Spacious tent for family camping', 399.99, 4),
    ('Rain Jacket', 'Waterproof outdoor jacket', 119.99, 18),
    ('Thermal Shirt', 'Warm base-layer shirt', 39.99, 30),
    ('HydroFlask 1L', 'Reusable one-litre water bottle', 34.99, 50),
    ('Headlamp', NULL, 29.99, 22),
    ('Hiking Socks', 'Comfortable socks for hiking', 20.99, 60);

-- Resolve the foreign keys by names instead of relying on hard-coded IDs.
WITH links(product_name, category_name) AS (
    VALUES
        ('Trail Runner Shoes', 'Footwear'),
        ('Trail Runner Shoes', 'Clothing'),
        ('Hiking Boots', 'Footwear'),
        ('Daypack 20L', 'Backpacks'),
        ('Trekking Backpack 50L', 'Backpacks'),
        ('Solo Tent', 'Tents'),
        ('Family Tent', 'Tents'),
        ('Rain Jacket', 'Clothing'),
        ('Thermal Shirt', 'Clothing'),
        ('HydroFlask 1L', 'Accessories'),
        ('Headlamp', 'Accessories'),
        ('Hiking Socks', 'Footwear'),
        ('Hiking Socks', 'Clothing')
)
INSERT INTO product_categories (product_id, category_id)
SELECT p.product_id, c.category_id
FROM links l
JOIN products p ON p.name = l.product_name
JOIN categories c ON c.name = l.category_name;

-- Insert in this order so order #2 is the 'shipped' order for Task 1.4.
INSERT INTO orders (customer_id, status, order_date) VALUES
    ((SELECT customer_id FROM customers WHERE email = 'mikko.korhonen@email.com'),
        'delivered', CURRENT_TIMESTAMP - INTERVAL '10 days'),
    ((SELECT customer_id FROM customers WHERE email = 'anna.virtanen@email.com'),
        'shipped', CURRENT_TIMESTAMP - INTERVAL '5 days'),
    ((SELECT customer_id FROM customers WHERE email = 'eero.lahtinen@email.com'),
        'processing', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ((SELECT customer_id FROM customers WHERE email = 'maria.salminen@email.com'),
        'pending', CURRENT_TIMESTAMP - INTERVAL '1 day'),
    ((SELECT customer_id FROM customers WHERE email = 'petri.kallio@email.com'),
        'cancelled', CURRENT_TIMESTAMP);

-- The order and product rows are matched by unique emails and product names.
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'mikko.korhonen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Trail Runner Shoes'), 1, 89.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'mikko.korhonen@email.com'),
     (SELECT product_id FROM products WHERE name = 'HydroFlask 1L'), 2, 34.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'anna.virtanen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Hiking Boots'), 1, 149.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'anna.virtanen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Daypack 20L'), 1, 49.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'eero.lahtinen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Trekking Backpack 50L'), 1, 179.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'eero.lahtinen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Thermal Shirt'), 2, 39.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'maria.salminen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Rain Jacket'), 1, 119.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'maria.salminen@email.com'),
     (SELECT product_id FROM products WHERE name = 'Headlamp'), 1, 29.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'petri.kallio@email.com'),
     (SELECT product_id FROM products WHERE name = 'Solo Tent'), 1, 199.99),
    ((SELECT o.order_id FROM orders o JOIN customers c USING (customer_id) WHERE c.email = 'petri.kallio@email.com'),
     (SELECT product_id FROM products WHERE name = 'Hiking Socks'), 3, 20.99);

COMMIT;

-- Verify the sample rows with sql/07_verify_data.sql.
