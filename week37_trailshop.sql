-- Week 37 - TrailShop Database Exercises
-- Student project file
-- PostgreSQL / VS Code

-- ============================================================
-- PART 1: TRAILSHOP DATABASE SETUP
-- ============================================================

-- 
-- 

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description   TEXT DEFAULT ''
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    city        VARCHAR(100)
);

CREATE TABLE products (
    product_id     INTEGER PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE,
    price          NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    weight_kg      NUMERIC(6,2) CHECK (weight_kg > 0),
    category_id    INTEGER NOT NULL REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id    INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    status      VARCHAR(20) NOT NULL DEFAULT 'pending'
                CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_items (
    order_id   INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    PRIMARY KEY (order_id, product_id)
);

-- Sample data from the Week 37 theory material
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Footwear', 'Boots, shoes and socks'),
(2, 'Camping', 'Tents and camping equipment'),
(3, 'Climbing', 'Climbing equipment and shoes'),
(4, 'Hiking', 'Backpacks and hiking accessories'),
(5, 'Clothing', 'Outdoor clothing');

INSERT INTO customers (customer_id, first_name, last_name, email, city) VALUES
(501, 'Laura', 'Virtanen', 'laura.v@email.fi', 'Helsinki'),
(502, 'Mikko', 'Korhonen', 'mikko.k@email.fi', 'Tampere'),
(503, 'Anna', 'Mäkelä', 'anna.m@email.fi', 'Turku'),
(504, 'Juha', 'Nieminen', 'juha.n@email.fi', 'Oulu');

INSERT INTO products (product_id, name, price, stock_quantity, weight_kg, category_id) VALUES
(101, 'Alpine Pro Hiking Boots', 189.50, 42, 1.40, 1),
(102, 'TrailMaster X4 Tent', 249.99, 15, 3.20, 2),
(103, 'GripWall Climbing Shoes', 159.99, 19, 0.90, 3),
(104, 'Summit 45L Backpack', 129.00, 28, 1.10, 4),
(105, 'StormShield Rain Jacket', 99.95, 55, 0.70, 5),
(106, 'Basecamp 2P Tent', 199.00, 22, 2.80, 2),
(107, 'RockHold Harness', 89.99, 31, 0.80, 3),
(108, 'TrailRunner Socks (3-pack)', 24.99, 120, 0.20, 1);

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1001, 501, CURRENT_DATE, 'pending'),
(1002, 502, CURRENT_DATE, 'shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1001, 101, 1, 189.50),
(1001, 102, 2, 249.99),
(1002, 103, 1, 159.99);

-- ============================================================
-- PART 2: QUICK CHECKS
-- ============================================================

SELECT * FROM categories ORDER BY category_id;
SELECT * FROM products ORDER BY product_id;
SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM orders ORDER BY order_id;
SELECT * FROM order_items ORDER BY order_id, product_id;

-- ============================================================
-- PART 3: EXERCISE 3.1 - CONSTRAINT PREDICTIONS
-- ============================================================

-- Expected results:
-- 1 SUCCESS
-- 2 FAIL - salary CHECK (salary >= 0)
-- 3 FAIL - duplicate primary key emp_id = 100
-- 4 FAIL - foreign key: dept_id 5 does not exist
-- 5 FAIL - UNIQUE constraint on dept_name
-- 6 FAIL - NOT NULL constraint on employee name
-- 7 FAIL - referenced department cannot be deleted while employees exist
-- 8 SUCCESS

-- ============================================================
-- PART 4: BOOKSTORE DESIGN (EXERCISE 3.2)
-- ============================================================

DROP TABLE IF EXISTS book_authors CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS genres CASCADE;

CREATE TABLE genres (
    genre_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE authors (
    author_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL
);

CREATE TABLE books (
    book_id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    isbn            CHAR(13) NOT NULL UNIQUE,
    title           VARCHAR(200) NOT NULL,
    price           NUMERIC(10,2) NOT NULL CHECK (price > 0),
    publication_year INTEGER NOT NULL
        CHECK (publication_year BETWEEN 1450 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    genre_id        INTEGER NOT NULL REFERENCES genres(genre_id)
);

CREATE TABLE book_authors (
    book_id   INTEGER NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
    author_id INTEGER NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);

-- Example data for testing the bookstore design
INSERT INTO genres (genre_name) VALUES ('Fiction'), ('Science'), ('History');
INSERT INTO authors (first_name, last_name) VALUES ('George', 'Orwell'), ('Jane', 'Austen');
INSERT INTO books (isbn, title, price, publication_year, genre_id)
VALUES ('9780451524935', '1984', 12.99, 1949, 1);
INSERT INTO book_authors (book_id, author_id) VALUES (1, 1);

-- ============================================================
-- PART 5: LIBRARY SYSTEM DESIGN
-- ============================================================

DROP TABLE IF EXISTS borrowings CASCADE;
DROP TABLE IF EXISTS copies CASCADE;
DROP TABLE IF EXISTS library_books CASCADE;
DROP TABLE IF EXISTS library_members CASCADE;
DROP TABLE IF EXISTS library_genres CASCADE;

CREATE TABLE library_genres (
    genre_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE library_members (
    member_number INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(150) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    phone         VARCHAR(30)
);

CREATE TABLE library_books (
    book_id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    isbn            CHAR(13) NOT NULL UNIQUE,
    title           VARCHAR(200) NOT NULL,
    publication_year INTEGER NOT NULL
        CHECK (publication_year BETWEEN 1450 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    genre_id        INTEGER NOT NULL REFERENCES library_genres(genre_id)
);

CREATE TABLE copies (
    copy_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id   INTEGER NOT NULL REFERENCES library_books(book_id) ON DELETE RESTRICT,
    barcode   VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE borrowings (
    borrowing_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_number  INTEGER NOT NULL REFERENCES library_members(member_number),
    copy_id        INTEGER NOT NULL REFERENCES copies(copy_id),
    borrow_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date       DATE NOT NULL,
    return_date    DATE,
    CHECK (due_date = borrow_date + 14),
    CHECK (return_date IS NULL OR return_date >= borrow_date)
);

-- One copy should not be borrowed twice at the same time.
CREATE UNIQUE INDEX uq_active_borrowing_per_copy
ON borrowings (copy_id)
WHERE return_date IS NULL;

-- Note: "a member can borrow at most 5 copies at any given time"
-- cannot be enforced with a simple CHECK constraint. This normally
-- needs a trigger or application logic. The partial index above does
-- enforce the separate rule that one copy cannot have two active loans.

-- ============================================================
-- OPTIONAL TEST QUERIES
-- ============================================================

-- See table structure in VS Code / psql:
-- \d products
-- \d categories
-- \d order_items

-- Show all products with category names:
SELECT p.product_id, p.name, p.price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.product_id;

-- Find products with unknown weight:
SELECT product_id, name
FROM products
WHERE weight_kg IS NULL;

-- Show a NULL-safe display value:
SELECT name, COALESCE(weight_kg, 0) AS displayed_weight
FROM products;

