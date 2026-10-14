-- Week 40, Exercises 3 and 4: optional practice snippets.
-- These are examples, not a single script to run from top to bottom.
-- Read assignment_answers.md for each exercise's context and run one section at a time.
-- Some sections change or delete data or drop columns.

-- Exercise 3.1: suppliers table
-- CREATE TABLE suppliers (
--     supplier_id SERIAL PRIMARY KEY,
--     company_name VARCHAR(200) NOT NULL UNIQUE,
--     contact_name VARCHAR(150),
--     email VARCHAR(255) NOT NULL UNIQUE,
--     phone VARCHAR(20),
--     country VARCHAR(100) NOT NULL DEFAULT 'Finland'
-- );

-- Exercise 3.2: product_reviews table
-- CREATE TABLE product_reviews (
--     review_id SERIAL PRIMARY KEY,
--     product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
--     customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
--     rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
--     review_text TEXT,
--     created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
-- );

-- Exercise 3.3: insert category (run once, after core sample data)
-- INSERT INTO categories (name, description)
-- VALUES ('Electronics', 'GPS devices, solar chargers, and tech gear');

-- Exercise 3.4: insert three customers (run once)
-- INSERT INTO customers (name, email) VALUES
-- ('Eero Lahtinen', 'eero.l@email.com'),
-- ('Maria Salminen', 'maria.s@email.com'),
-- ('Petri Kallio', 'petri.k@email.com');

-- Exercise 3.5: insert NorthStar GPS and link it to category_id 6.
-- Assumes the five original categories have IDs 1-5 and Electronics has ID 6.
-- WITH new_product AS (
--     INSERT INTO products (name, description, price, stock)
--     VALUES ('NorthStar GPS', 'GPS device for outdoor navigation', 229.99, 12)
--     RETURNING product_id, created_at
-- ), linked_product AS (
--     INSERT INTO product_categories (product_id, category_id)
--     SELECT product_id, 6 FROM new_product
--     RETURNING product_id
-- )
-- SELECT np.product_id, np.created_at
-- FROM new_product np
-- JOIN linked_product lp ON lp.product_id = np.product_id;

-- Exercise 3.6: update customer #2's email
-- UPDATE customers
-- SET email = 'mikko.korhonen@newmail.com'
-- WHERE customer_id = 2;

-- Exercise 3.7: reduce stock only where stock is greater than zero
-- UPDATE products
-- SET stock = stock - 1
-- WHERE stock > 0;

-- Exercise 3.8: add cancelled_at and update order #3
-- ALTER TABLE orders ADD COLUMN cancelled_at TIMESTAMPTZ;
-- UPDATE orders
-- SET status = 'cancelled', cancelled_at = CURRENT_TIMESTAMP
-- WHERE order_id = 3;

-- Exercise 3.9: preview and then delete cancelled orders.
-- This can delete several orders and their order_items due to ON DELETE CASCADE.
-- SELECT * FROM orders WHERE status = 'cancelled';
-- DELETE FROM orders WHERE status = 'cancelled';

-- Exercise 3.10a: add discount percentage constraint
-- ALTER TABLE products
-- ADD COLUMN discount_percent NUMERIC(5,2) DEFAULT 0
-- CHECK (discount_percent >= 0 AND discount_percent <= 100);

-- Exercise 3.10b: this drops data/schema information and should be run last if needed.
-- ALTER TABLE categories DROP COLUMN description;

-- Exercise 3.10c: run after creating product_reviews
-- ALTER TABLE product_reviews
-- ADD CONSTRAINT product_reviews_customer_product_unique
-- UNIQUE (customer_id, product_id);

-- Exercise 4: corrected examples
-- 4.1
-- CREATE TABLE warehouses (
--     warehouse_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     city VARCHAR(100)
-- );

-- 4.2
-- INSERT INTO products (name, price, stock)
-- VALUES ('Alpine Sleeping Bag', 89.99, 20);

-- 4.3
-- CREATE TABLE shipments (
--     shipment_id SERIAL PRIMARY KEY,
--     order_id INTEGER REFERENCES orders(order_id),
--     shipped_date DATE NOT NULL,
--     carrier VARCHAR(100)
-- );

-- 4.4
-- UPDATE products
-- SET price = price * 0.9,
--     stock = stock + 10
-- WHERE product_id = 3;

-- 4.5
-- CREATE TABLE wishlists (
--     wishlist_id SERIAL PRIMARY KEY,
--     customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
--     product_id INTEGER NOT NULL REFERENCES products(product_id),
--     added_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     UNIQUE (customer_id, product_id)
-- );
