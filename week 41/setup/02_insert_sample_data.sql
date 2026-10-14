-- TrailShop sample data based on the supplied Week 40 chapter notes.
-- Run only once, after creating all six tables.

INSERT INTO categories (name, description) VALUES
    ('Footwear', 'Hiking boots, trail runners, and sandals'),
    ('Backpacks', 'Day packs, overnight packs, and expedition packs'),
    ('Tents', 'One-person to family-size tents'),
    ('Clothing', 'Outdoor clothing for all seasons'),
    ('Accessories', 'Water bottles, headlamps, trekking poles');

INSERT INTO customers (first_name, last_name, email) VALUES
    ('Anna', 'Virtanen', 'anna.v@email.com'),
    ('Mikko', 'Korhonen', 'mikko.k@email.com'),
    ('Sara', 'Mäkinen', 'sara.m@email.com'),
    ('Juha', 'Nieminen', 'juha.n@email.com'),
    ('Laura', 'Hämäläinen', 'laura.h@email.com');

INSERT INTO products (name, description, price, stock) VALUES
    ('TrailMaster X4', 'Professional hiking boot with waterproof lining', 149.99, 25),
    ('LiteStep Pro', 'Lightweight trail runner for day hikes', 89.99, 40),
    ('Summit 45L', 'Multi-day hiking backpack with rain cover', 199.99, 15),
    ('DayTripper 20L', 'Compact day pack with hydration sleeve', 59.99, 50),
    ('CloudNest 2P', 'Two-person ultralight tent', 349.99, 10),
    ('StormShield 4P', 'Four-season family tent', 499.99, 5),
    ('ThermoLayer Jacket', 'Insulated mid-layer for cold weather', 129.99, 30),
    ('RainGuard Pro', 'Waterproof breathable rain jacket', 179.99, 20),
    ('HydroFlask 1L', 'Insulated stainless steel water bottle', 34.99, 100),
    ('LumaBeam 800', 'Rechargeable headlamp, 800 lumens', 44.99, 60);

-- RainGuard Pro belongs to both Clothing and Accessories.
INSERT INTO product_categories (product_id, category_id) VALUES
    (1, 1), (2, 1),
    (3, 2), (4, 2),
    (5, 3), (6, 3),
    (7, 4), (8, 4), (8, 5),
    (9, 5), (10, 5);

INSERT INTO orders (customer_id, status) VALUES
    (1, 'delivered'),
    (2, 'shipped'),
    (1, 'pending'),
    (3, 'delivered'),
    (4, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 149.99),
    (1, 9, 2, 34.99),
    (2, 3, 1, 199.99),
    (2, 7, 1, 129.99),
    (3, 5, 1, 349.99),
    (4, 2, 1, 89.99),
    (4, 4, 1, 59.99),
    (4, 10, 1, 44.99),
    (5, 6, 1, 499.99),
    (5, 8, 1, 179.99);
