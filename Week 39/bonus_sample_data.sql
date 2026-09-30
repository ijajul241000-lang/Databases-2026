

INSERT INTO categories (category_name, description) VALUES
('Hiking', 'Hiking equipment'),
('Camping', 'Camping equipment'),
('Climbing', 'Climbing equipment'),
('Running', 'Running equipment'),
('Accessories', 'Outdoor accessories');

INSERT INTO products (name, description, price, weight_kg, stock_quantity) VALUES
('Hiking Backpack', '40 litre hiking backpack', 89.90, 1.20, 20),
('Camping Tent', 'Two-person camping tent', 149.90, 2.50, 10),
('Sleeping Bag', 'Three-season sleeping bag', 79.90, 1.10, 15),
('Hiking Boots', 'Water-resistant hiking boots', 129.90, 1.80, 12),
('Climbing Rope', 'Outdoor climbing rope', 99.90, 3.20, 8),
('Running Shoes', 'Trail running shoes', 119.90, 0.80, 18),
('Headlamp', 'Rechargeable outdoor headlamp', 29.90, 0.15, 30),
('Water Bottle', 'Reusable outdoor water bottle', 19.90, 0.30, 40);

-- Product 1 belongs to two categories.
INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1),
(1, 5),
(2, 2),
(3, 2),
(4, 1),
(5, 3),
(6, 4),
(7, 5),
(8, 5);

INSERT INTO customers
(first_name, last_name, email, phone, street, city, postal_code, country)
VALUES
('Mika', 'Korhonen', 'mika@example.com', '0401234567', 'Main Street 1', 'Mikkeli', '50100', 'Finland'),
('Anna', 'Virtanen', 'anna@example.com', '0402345678', 'Lake Street 2', 'Helsinki', '00100', 'Finland'),
('John', 'Smith', 'john@example.com', '0403456789', 'Forest Road 3', 'Espoo', '02100', 'Finland');

INSERT INTO orders
(customer_id, status, shipping_street, shipping_city, shipping_postal_code, shipping_country)
VALUES
(1, 'pending', 'Main Street 1', 'Mikkeli', '50100', 'Finland'),
(1, 'shipped', 'Main Street 1', 'Mikkeli', '50100', 'Finland'),
(2, 'delivered', 'Lake Street 2', 'Helsinki', '00100', 'Finland'),
(3, 'processing', 'Forest Road 3', 'Espoo', '02100', 'Finland');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 89.90),
(1, 7, 2, 29.90),
(2, 2, 1, 149.90),
(2, 3, 1, 79.90),
(3, 4, 1, 129.90),
(3, 6, 1, 119.90),
(3, 8, 2, 19.90),
(4, 5, 1, 99.90),
(4, 7, 1, 29.90),
(4, 8, 1, 19.90);


