# Week 40 — SQL Fundamentals: Answers

## Task 1.1 — Create the Database

```sql
CREATE DATABASE trailshop;
```

Connect to the database in `psql`:

```sql
\c trailshop
```

## Task 1.2 — Create All Tables

```sql
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories (
    product_id INTEGER NOT NULL
        REFERENCES products(product_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL
        REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL
        REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0)
);
```

## Task 1.3 — Insert Sample Data

### Categories

```sql
INSERT INTO categories (name, description) VALUES
    ('Footwear', 'Hiking boots, trail runners, and sandals'),
    ('Backpacks', 'Day packs and hiking backpacks'),
    ('Tents', 'Camping tents for outdoor adventures'),
    ('Clothing', 'Outdoor clothing for all seasons'),
    ('Accessories', 'Water bottles, headlamps, and other gear');
```

### Customers

```sql
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Anna', 'Virtanen', 'anna.v@email.com'),
    ('Mikko', 'Korhonen', 'mikko.k@email.com'),
    ('Sara', 'Makinen', 'sara.m@email.com'),
    ('Juha', 'Nieminen', 'juha.n@email.com'),
    ('Laura', 'Hamalainen', 'laura.h@email.com');
```

### Products

```sql
INSERT INTO products (name, description, price, stock) VALUES
    ('TrailMaster X4', 'Professional hiking boots', 149.99, 25),
    ('LiteStep Pro', 'Lightweight trail running shoes', 89.99, 40),
    ('Summit 45L', 'Large hiking backpack with rain cover', 199.99, 15),
    ('DayTripper 20L', 'Compact day pack', 59.99, 50),
    ('CloudNest 2P', 'Lightweight two-person camping tent', 349.99, 10),
    ('StormShield 4P', 'Four-person camping tent', 499.99, 5),
    ('ThermoLayer Jacket', 'Warm outdoor jacket', 129.99, 30),
    ('RainGuard Pro', 'Waterproof outdoor jacket', 179.99, 20),
    ('HydroFlask 1L', 'Insulated stainless steel water bottle', 34.99, 100),
    ('LumaBeam 800', NULL, 44.99, 60);
```

### Product Categories

```sql
INSERT INTO product_categories (product_id, category_id) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 2),
    (5, 3),
    (6, 3),
    (7, 4),
    (8, 4),
    (8, 5),
    (9, 5),
    (10, 5);
```

### Orders

```sql
INSERT INTO orders (customer_id, status) VALUES
    (1, 'delivered'),
    (2, 'shipped'),
    (1, 'pending'),
    (3, 'delivered'),
    (4, 'pending');
```

### Order Items

```sql
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
```

## Task 1.4 — Practice UPDATE

```sql
-- 1. Increase the price of all Footwear products by 10%
UPDATE products
SET price = ROUND(price * 1.10, 2)
WHERE product_id IN (
    SELECT product_id
    FROM product_categories
    WHERE category_id = (
        SELECT category_id
        FROM categories
        WHERE name = 'Footwear'
    )
);

-- 2. Change customer #3's email
UPDATE customers
SET email = 'sara.new@email.com'
WHERE customer_id = 3;

-- 3. Change order #2 from shipped to delivered
UPDATE orders
SET status = 'delivered'
WHERE order_id = 2
  AND status = 'shipped';

-- 4. Set HydroFlask 1L stock to 85
UPDATE products
SET stock = 85
WHERE name = 'HydroFlask 1L';

-- 5. Add a description to products with NULL descriptions
UPDATE products
SET description = 'Rechargeable headlamp with 800 lumens'
WHERE description IS NULL;
```

## Task 1.5 — Practice DELETE

```sql
-- 1. Delete the most recently created order
DELETE FROM orders
WHERE order_id = (
    SELECT MAX(order_id)
    FROM orders
);

-- 2. Try deleting a product referenced by order_items
-- This should fail because of the foreign key constraint.
DELETE FROM products
WHERE product_id = 1;

-- 3. Delete the Accessories category
-- Its product-category links will be deleted, but the products remain.
DELETE FROM categories
WHERE name = 'Accessories';

-- Verify that the linked products still exist.
SELECT *
FROM products
WHERE product_id IN (8, 9, 10);

-- 4. Delete the customer who has no orders
DELETE FROM customers
WHERE customer_id = 5;
```

## Task 1.6 — Practice ALTER TABLE

```sql
-- 1. Add a phone column to customers
ALTER TABLE customers
ADD COLUMN phone VARCHAR(20);

-- 2. Add a weight_grams column to products
ALTER TABLE products
ADD COLUMN weight_grams INTEGER;

-- 3. Require weight_grams to be greater than zero when provided
ALTER TABLE products
ADD CONSTRAINT chk_products_weight_grams
CHECK (weight_grams > 0);

-- 4. Rename stock to quantity_in_stock
ALTER TABLE products
RENAME COLUMN stock TO quantity_in_stock;

-- Rename the column back for later exercises
ALTER TABLE products
RENAME COLUMN quantity_in_stock TO stock;
```

## Exercise 2 — Theory Review Questions

### 1. What does SQL stand for, and why was the language designed to look like English?

SQL stands for Structured Query Language. It was designed to use readable, English-like commands so people could work with relational databases without needing to use a complicated programming language for every query.

### 2. Explain the difference between DDL and DML. Give two example commands for each.

DDL means Data Definition Language. It is used to create or change the structure of a database. Examples are `CREATE TABLE` and `ALTER TABLE`. DML means Data Manipulation Language. It is used to read or change the data inside tables. Examples are `INSERT` and `UPDATE`.

### 3. What is the difference between DCL and TCL? When would you use each?

DCL means Data Control Language and is used to manage permissions. For example, `GRANT` gives a user permission and `REVOKE` removes permission. TCL means Transaction Control Language and controls transactions. Commands such as `COMMIT` and `ROLLBACK` are used to save or undo a group of changes.

### 4. Why must you create tables in a specific order? What determines that order?

Tables must be created in dependency order because a foreign key can only reference a table that exists. Tables without dependencies are created first. Tables that reference them, such as `product_categories` and `order_items`, are created afterwards.

### 5. What is the difference between a column-level constraint and a table-level constraint? When must you use a table-level constraint?

A column-level constraint is written next to a column definition. A table-level constraint is written after the column definitions. A table-level constraint is needed for rules involving multiple columns, such as a composite primary key or a unique combination of columns.

### 6. Explain the difference between `DELETE FROM products;` and `TRUNCATE TABLE products;`. When would you prefer each?

`DELETE FROM products;` removes all product rows and processes them as deleted rows. `TRUNCATE TABLE products;` empties the table more directly and is usually faster for removing every row. I would use `DELETE` when I need a condition or row-level triggers, and `TRUNCATE` when I intentionally need to empty a whole table. Foreign-key dependencies can affect whether either command is allowed.

### 7. What does `ON DELETE CASCADE` do on a foreign key? Give a real-world scenario where it's appropriate and one where it would be dangerous.

`ON DELETE CASCADE` automatically deletes related child rows when a referenced parent row is deleted. It is useful for deleting order items when their order is deleted. It can be dangerous if used for customer records and purchase history, because deleting a customer could unintentionally remove important order information.

### 8. Why should you store `unit_price` in the `order_items` table instead of just looking it up from the `products` table?

The product price can change over time. Storing `unit_price` in `order_items` preserves the price the customer actually paid, so old orders remain accurate even when the current product price changes.

### 9. What is the difference between SERIAL and GENERATED ALWAYS AS IDENTITY? Which would you use in a new project and why?

`SERIAL` is PostgreSQL-specific shorthand that creates an integer column with a sequence-backed default. `GENERATED ALWAYS AS IDENTITY` uses the SQL-standard identity-column feature and prevents ordinary manual values from being inserted into the generated column. For a new project, I would usually use `GENERATED ALWAYS AS IDENTITY` because it is standard and makes the intended behavior clearer, while still understanding `SERIAL` because it is common in PostgreSQL examples.

### 10. Explain why `UPDATE products SET price = 9.99;` is dangerous. What steps should you take before running any UPDATE statement?

The statement has no `WHERE` clause, so it changes the price of every product to 9.99. Before running an update, I would use a `SELECT` with the same condition to check the rows, confirm the `WHERE` clause, and use a transaction so I can roll back the change if something goes wrong.

## Exercise 3 — SQL Writing Exercises

### 3.1 CREATE TABLE

```sql
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL UNIQUE,
    contact_name VARCHAR(150),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    country VARCHAR(100) NOT NULL DEFAULT 'Finland'
);
```

### 3.2 CREATE TABLE with Foreign Key

```sql
CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### 3.3 INSERT — Single Row

```sql
INSERT INTO categories (name, description)
VALUES ('Electronics', 'GPS devices, solar chargers, and tech gear');
```

### 3.4 INSERT — Multiple Rows

```sql
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Eero', 'Lahtinen', 'eero.l@email.com'),
    ('Maria', 'Salminen', 'maria.s@email.com'),
    ('Petri', 'Kallio', 'petri.k@email.com');
```

### 3.5 INSERT with RETURNING

```sql
WITH new_product AS (
    INSERT INTO products (name, price, stock)
    VALUES ('NorthStar GPS', 229.99, 12)
    RETURNING product_id, created_at
),
assigned_category AS (
    INSERT INTO product_categories (product_id, category_id)
    SELECT product_id, 6
    FROM new_product
    RETURNING product_id
)
SELECT new_product.product_id, new_product.created_at
FROM new_product
JOIN assigned_category
    ON assigned_category.product_id = new_product.product_id;
```

### 3.6 UPDATE — Simple

```sql
UPDATE customers
SET email = 'mikko.korhonen@newmail.com'
WHERE customer_id = 2;
```

### 3.7 UPDATE — Expression

```sql
UPDATE products
SET stock = stock - 1
WHERE stock > 0;
```

### 3.8 UPDATE — Multiple Columns

```sql
ALTER TABLE orders
ADD COLUMN cancelled_at TIMESTAMPTZ;

UPDATE orders
SET status = 'cancelled',
    cancelled_at = CURRENT_TIMESTAMP
WHERE order_id = 3;
```

### 3.9 DELETE — With Condition

```sql
DELETE FROM orders
WHERE status = 'cancelled';
```

### 3.10 ALTER TABLE

```sql
-- a) Add discount_percent with a default and CHECK constraint
ALTER TABLE products
ADD COLUMN discount_percent NUMERIC(5,2)
DEFAULT 0
CHECK (discount_percent >= 0 AND discount_percent <= 100);

-- b) Drop the description column from categories
ALTER TABLE categories
DROP COLUMN description;

-- c) Prevent a customer from reviewing the same product twice
ALTER TABLE product_reviews
ADD CONSTRAINT uq_product_reviews_customer_product
UNIQUE (customer_id, product_id);
```

## Exercise 4 — Error Diagnosis

### 4.1 Error(s) Identified and Corrected SQL

The opening parenthesis after `CREATE TABLE warehouses` is missing, and the statement needs to close the column list correctly.

```sql
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);
```

### 4.2 Error(s) Identified and Corrected SQL

The product name is a string, so it must use single quotes in PostgreSQL rather than double quotes.

```sql
INSERT INTO products (name, price, stock)
VALUES ('Alpine Sleeping Bag', 89.99, 20);
```

### 4.3 Error(s) Identified and Corrected SQL

A comma is missing after the `order_id` foreign-key definition.

```sql
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    shipped_date DATE NOT NULL,
    carrier VARCHAR(100)
);
```

### 4.4 Error(s) Identified and Corrected SQL

There should be only one `SET` keyword. Separate column assignments with a comma.

```sql
UPDATE products
SET price = price * 0.9,
    stock = stock + 10
WHERE product_id = 3;
```

### 4.5 Error(s) Identified and Corrected SQL

The statement defines two primary keys. A table can have only one primary-key constraint. Keep `wishlist_id` as the primary key and make the customer/product combination unique instead.

```sql
CREATE TABLE wishlists (
    wishlist_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    added_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (customer_id, product_id)
);
```

## Verification Queries

```sql
\dt
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM product_categories;
SELECT * FROM orders;
SELECT * FROM order_items;
```

> **Note:** Run the SQL in a fresh `trailshop` database and check the results. Some exercises intentionally demonstrate a foreign-key error or modify/delete earlier sample data, so run the sample-data setup before the practice sections. Exercise 3.5 assumes `Electronics` has `category_id = 6`, as stated in the assignment.
