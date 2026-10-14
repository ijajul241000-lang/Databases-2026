# Week 42 — Exercises: Review and Exam 1 Preparation (Optional)

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task — Review and Verify (Optional)

Before the exam, verify that your TrailShop database is complete and correct.

### Task 1.1: Schema Verification

Run the following checks and fix any issues:

1. Confirm all 6 tables exist: `\dt`
2. Confirm column definitions: `\d categories`, `\d customers`, `\d products`, `\d product_categories`, `\d orders`, `\d order_items`
3. Verify all PRIMARY KEY constraints exist
4. Verify all FOREIGN KEY constraints exist
5. Verify CHECK constraints on `price`, `stock`, `quantity`, `status`
6. Verify NOT NULL constraints on required columns

Run these checks in `psql`:

```sql
\dt
\d categories
\d customers
\d products
\d product_categories
\d orders
\d order_items
```

Use this query to review keys and table constraints in SQL:

```sql
SELECT tc.table_name,
       tc.constraint_name,
       tc.constraint_type,
       kcu.column_name
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.key_column_usage kcu
  ON kcu.constraint_catalog = tc.constraint_catalog
 AND kcu.constraint_schema = tc.constraint_schema
 AND kcu.constraint_name = tc.constraint_name
 AND kcu.table_name = tc.table_name
WHERE tc.table_schema = 'public'
  AND tc.table_name IN ('categories', 'customers', 'products',
                        'product_categories', 'orders', 'order_items')
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;

SELECT conrelid::regclass AS table_name,
       conname AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid IN (
    'categories'::regclass, 'customers'::regclass, 'products'::regclass,
    'product_categories'::regclass, 'orders'::regclass, 'order_items'::regclass
)
ORDER BY table_name, constraint_name;

SELECT table_name, column_name, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('categories', 'customers', 'products',
                     'product_categories', 'orders', 'order_items')
ORDER BY table_name, ordinal_position;
```

### Task 1.2: Data Verification

1. Verify that each table contains data using this row-count query:

```sql
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_categories', COUNT(*) FROM product_categories
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;
```

2. Run a query that joins all 6 tables to confirm relationships work:

```sql
SELECT c.first_name, cat.name AS category, p.name AS product,
       oi.quantity, o.status
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories cat ON cat.category_id = pc.category_id
ORDER BY c.first_name, o.order_id;
```

3. Test referential integrity: try to INSERT into `product_categories` with a non-existent `category_id` — confirm it fails
4. Test CHECK constraint: try to UPDATE a product price to -5 — confirm it fails

The following PostgreSQL test blocks catch the expected errors, so the checks do not leave the session in an aborted transaction:

```sql
DO $$
DECLARE
    existing_product_id INTEGER;
BEGIN
    SELECT product_id INTO existing_product_id
    FROM products
    ORDER BY product_id
    LIMIT 1;

    IF existing_product_id IS NULL THEN
        RAISE NOTICE 'Skipped foreign-key test: products table is empty.';
    ELSE
        BEGIN
            INSERT INTO product_categories (product_id, category_id)
            VALUES (existing_product_id, -2147483000);
            RAISE EXCEPTION 'Test failed: invalid category_id was accepted.';
        EXCEPTION WHEN foreign_key_violation THEN
            RAISE NOTICE 'PASS: invalid category_id was rejected by the foreign key.';
        END;
    END IF;
END;
$$;

DO $$
DECLARE
    existing_product_id INTEGER;
BEGIN
    SELECT product_id INTO existing_product_id
    FROM products
    ORDER BY product_id
    LIMIT 1;

    IF existing_product_id IS NULL THEN
        RAISE NOTICE 'Skipped CHECK test: products table is empty.';
    ELSE
        BEGIN
            UPDATE products SET price = -5
            WHERE product_id = existing_product_id;
            RAISE EXCEPTION 'Test failed: negative product price was accepted.';
        EXCEPTION WHEN check_violation THEN
            RAISE NOTICE 'PASS: negative product price was rejected by the CHECK constraint.';
        END;
    END IF;
END;
$$;
```

---

## Exercise 2: PetStore Mini-Case (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It is practice for Exam 1.

This is a complete practice case similar to what you might see on the exam. Work through it from start to finish.

### 2.1 Business Description

**PetStore** is a small shop selling pet supplies. They need a database to track:

- **Product categories**: name (e.g., "Dog Food", "Cat Toys", "Fish Supplies")
- **Products**: name, description, price, stock quantity, which category they belong to
- **Customers**: first name, last name, email, phone
- **Sales**: which customer bought what product, how many, the price at time of sale, and the date

### 2.2 ER Diagram (Conceptual)

Draw or describe the ER diagram for PetStore:

- Entities: categories, products, customers, sales
- Relationships: products belong to categories (M:1), sales link customers and products (junction-like)

**ER model description:** `pet_categories` has a one-to-many relationship with `pet_products`: each product belongs to one category, and a category can contain many products. `pet_customers` has a one-to-many relationship with `pet_sales`, and `pet_products` also has a one-to-many relationship with `pet_sales`. The `pet_sales` entity connects each customer to a product and stores quantity, sale-time unit price, and sale date.

### 2.3 CREATE TABLE Statements

Write the CREATE TABLE statements:

```sql
CREATE TABLE pet_categories (
    category_id   SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE pet_products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(200) NOT NULL,
    description   TEXT,
    price         NUMERIC(8,2) NOT NULL CHECK (price > 0),
    stock         INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    category_id   INTEGER NOT NULL REFERENCES pet_categories(category_id)
);

CREATE TABLE pet_customers (
    customer_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    phone         VARCHAR(20)
);

CREATE TABLE pet_sales (
    sale_id       SERIAL PRIMARY KEY,
    customer_id   INTEGER NOT NULL REFERENCES pet_customers(customer_id),
    product_id    INTEGER NOT NULL REFERENCES pet_products(product_id),
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(8,2) NOT NULL CHECK (unit_price > 0),
    sale_date     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### 2.4 Sample Data

```sql
INSERT INTO pet_categories (name) VALUES
    ('Dog Food'), ('Cat Toys'), ('Fish Supplies'), ('Bird Cages'), ('Small Animal');

INSERT INTO pet_products (name, price, stock, category_id) VALUES
    ('Premium Kibble 10kg', 45.99, 30, 1),
    ('Grain-Free Wet Food 12-pack', 29.99, 50, 1),
    ('Laser Pointer', 12.99, 100, 2),
    ('Feather Wand', 8.99, 75, 2),
    ('Aquarium Filter 50L', 34.99, 20, 3),
    ('Tropical Fish Flakes', 6.99, 200, 3),
    ('Parakeet Cage Large', 89.99, 10, 4),
    ('Hamster Wheel', 14.99, 40, 5);

INSERT INTO pet_customers (first_name, last_name, email, phone) VALUES
    ('Liisa', 'Koivisto', 'liisa.k@email.com', '040-1234567'),
    ('Markus', 'Lehtinen', 'markus.l@email.com', NULL),
    ('Tiina', 'Järvinen', 'tiina.j@email.com', '050-9876543');

INSERT INTO pet_sales (customer_id, product_id, quantity, unit_price) VALUES
    (1, 1, 2, 45.99),
    (1, 3, 1, 12.99),
    (2, 5, 1, 34.99),
    (2, 6, 3, 6.99),
    (3, 4, 2, 8.99),
    (1, 7, 1, 89.99);
```

### 2.5 Practice Queries with Solutions

Write SQL for each, then check against the solution.

**Q1: List all products with their category names, sorted by category then price.**

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT pc.name AS category, pp.name AS product, pp.price
> FROM pet_products pp
> INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
> ORDER BY pc.name, pp.price;
> ```

<details>
<summary>Solution</summary>

```sql
SELECT pc.name AS category, pp.name AS product, pp.price
FROM pet_products pp
INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
ORDER BY pc.name, pp.price;
```

</details>

**Q2: How much has each customer spent in total?**

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.first_name || ' ' || c.last_name AS customer,
>        SUM(s.quantity * s.unit_price) AS total_spent
> FROM pet_customers c
> INNER JOIN pet_sales s ON c.customer_id = s.customer_id
> GROUP BY c.customer_id, c.first_name, c.last_name
> ORDER BY total_spent DESC;
> ```

<details>
<summary>Solution</summary>

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       SUM(s.quantity * s.unit_price) AS total_spent
FROM pet_customers c
INNER JOIN pet_sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
```

</details>

**Q3: Which categories have products that have never been sold?**

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT DISTINCT pc.name AS category
> FROM pet_products pp
> INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
> LEFT JOIN pet_sales s ON pp.product_id = s.product_id
> WHERE s.sale_id IS NULL
> ORDER BY pc.name;
> ```

<details>
<summary>Solution</summary>

```sql
SELECT DISTINCT pc.name AS category
FROM pet_products pp
INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
LEFT JOIN pet_sales s ON pp.product_id = s.product_id
WHERE s.sale_id IS NULL;
```

</details>

**Q4: What is the total revenue per category?**

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT pc.name AS category,
>        COALESCE(SUM(s.quantity * s.unit_price), 0) AS revenue
> FROM pet_categories pc
> LEFT JOIN pet_products pp ON pc.category_id = pp.category_id
> LEFT JOIN pet_sales s ON pp.product_id = s.product_id
> GROUP BY pc.category_id, pc.name
> ORDER BY revenue DESC;
> ```

<details>
<summary>Solution</summary>

```sql
SELECT pc.name AS category,
       COALESCE(SUM(s.quantity * s.unit_price), 0) AS revenue
FROM pet_categories pc
LEFT JOIN pet_products pp ON pc.category_id = pp.category_id
LEFT JOIN pet_sales s ON pp.product_id = s.product_id
GROUP BY pc.name
ORDER BY revenue DESC;
```

</details>

**Q5: Find the most purchased product (by total quantity sold).**

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT pp.name AS product,
>        SUM(s.quantity) AS total_sold
> FROM pet_products pp
> INNER JOIN pet_sales s ON pp.product_id = s.product_id
> GROUP BY pp.product_id, pp.name
> ORDER BY total_sold DESC
> LIMIT 1;
> ```

<details>
<summary>Solution</summary>

```sql
SELECT pp.name, SUM(s.quantity) AS total_sold
FROM pet_products pp
INNER JOIN pet_sales s ON pp.product_id = s.product_id
GROUP BY pp.product_id, pp.name
ORDER BY total_sold DESC
LIMIT 1;
```

</details>

---

## Exercise 3: Additional Practice — Mixed Topics (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It is practice for Exam 1.

These 10 questions cover material from Weeks 36–41. Write your answers without looking at notes first, then check.

### 3.1 (Week 36 — Theory)

Name three problems of file-based data management and explain how a database solves each one.

> [!NOTE]
> **_Your Answer_**
>
> Three common problems are data duplication, inconsistent information, and difficulty sharing or protecting data. If the same customer details are copied into several files, changing one copy may leave the others wrong. A database stores shared information in related tables and uses constraints to keep it consistent. A DBMS also controls access and supports backup and recovery.

### 3.2 (Week 37 — Theory)

What is the difference between a candidate key and a primary key? Can a table have multiple candidate keys?

> [!NOTE]
> **_Your Answer_**
>
> A candidate key is any minimal column or group of columns that can uniquely identify a row. The primary key is the candidate key chosen as the main identifier for the table. A table can have several candidate keys, but it has only one primary key. The other candidate keys can be protected with UNIQUE constraints.

### 3.3 (Week 37 — Theory)

State the referential integrity rule. What happens in PostgreSQL if you try to INSERT a row that violates it?

> [!NOTE]
> **_Your Answer_**
>
> Referential integrity means a foreign-key value must match an existing key in the referenced table, unless NULL is allowed. If an INSERT refers to a customer, product, or other parent row that does not exist, PostgreSQL rejects the statement with a foreign-key constraint error.

### 3.4 (Week 38 — Design)

A library lends books to members. A member can borrow many books; a book can be borrowed by many members (over time). Draw or describe the ER model, including the junction entity.

> [!NOTE]
> **_Your Answer_**
>
> There are three entities: Member, Book, and Borrowing. A member can have many borrowing records, and a book can appear in many borrowing records over time. Borrowing is the junction entity that connects members and books and stores details such as borrowed date, due date, and returned date. This resolves the many-to-many relationship between Member and Book.

### 3.5 (Week 39 — Design)

For the library scenario above, write the CREATE TABLE statements (at least 3 tables with appropriate keys and constraints).

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> CREATE TABLE members (
>     member_id SERIAL PRIMARY KEY,
>     first_name VARCHAR(100) NOT NULL,
>     last_name VARCHAR(100) NOT NULL,
>     email VARCHAR(255) NOT NULL UNIQUE
> );
>
> CREATE TABLE books (
>     book_id SERIAL PRIMARY KEY,
>     title VARCHAR(200) NOT NULL,
>     author VARCHAR(150) NOT NULL,
>     isbn CHAR(13) NOT NULL UNIQUE,
>     price NUMERIC(8,2) NOT NULL CHECK (price > 0)
> );
>
> CREATE TABLE borrowings (
>     borrowing_id SERIAL PRIMARY KEY,
>     member_id INTEGER NOT NULL REFERENCES members(member_id),
>     book_id INTEGER NOT NULL REFERENCES books(book_id),
>     borrowed_at DATE NOT NULL DEFAULT CURRENT_DATE,
>     due_date DATE,
>     returned_at DATE,
>     CHECK (due_date IS NULL OR due_date >= borrowed_at),
>     CHECK (returned_at IS NULL OR returned_at >= borrowed_at)
> );
> ```

### 3.6 (Week 40 — DDL)

Write an ALTER TABLE statement that adds a `discount_percent NUMERIC(4,2) CHECK (discount_percent BETWEEN 0 AND 50)` column to a `products` table.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> ALTER TABLE products
> ADD COLUMN discount_percent NUMERIC(4,2)
> CHECK (discount_percent BETWEEN 0 AND 50);
> ```

### 3.7 (Week 40 — DML)

Write an INSERT statement that adds 3 rows to a `books` table with columns: title (VARCHAR), author (VARCHAR), isbn (CHAR(13)), price (NUMERIC). Make up realistic data.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> INSERT INTO books (title, author, isbn, price) VALUES
>     ('Database Design Basics', 'Laura Green', '9781234567890', 29.95),
>     ('SQL Made Simple', 'Peter North', '9781234567891', 34.50),
>     ('Learning PostgreSQL', 'Maria Jensen', '9781234567892', 39.99);
> ```

### 3.8 (Week 41 — Querying)

Explain in plain English what this query returns:

```sql
SELECT c.name, COUNT(p.product_id)
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN products p ON p.product_id = pc.product_id
GROUP BY c.name
HAVING COUNT(p.product_id) = 0;
```

> [!NOTE]
> **_Your Answer_**
>
> The query lists categories that currently have no products linked to them. The LEFT JOIN keeps every category even when it has no matching product. COUNT(p.product_id) is zero for those categories, and HAVING filters the result to only those zero-count groups.

### 3.9 (Week 41 — Querying)

Write a query that finds the top 3 customers by total spending, showing their full name and total amount spent.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.customer_id,
>        c.first_name || ' ' || c.last_name AS customer,
>        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
> FROM customers c
> INNER JOIN orders o ON o.customer_id = c.customer_id
> INNER JOIN order_items oi ON oi.order_id = o.order_id
> GROUP BY c.customer_id, c.first_name, c.last_name
> ORDER BY total_spent DESC
> LIMIT 3;
> ```

### 3.10 (Week 41 — Querying)

Explain why this query is invalid:

```sql
SELECT pc.category_id, p.name, AVG(p.price)
FROM products p
JOIN product_categories pc ON pc.product_id = p.product_id
GROUP BY pc.category_id;
```

> [!NOTE]
> **_Your Answer_**
>
> The query is invalid in PostgreSQL because p.name is selected but is neither inside an aggregate function nor included in GROUP BY. A category can contain several product names, so SQL cannot choose one name for the whole category group. Add p.name to GROUP BY if a separate result per product is wanted, or remove p.name if the goal is only an average price per category.

---

## Exercise 4: Timed Practice Exercise (30 minutes) (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It is practice for Exam 1.

Set a timer for 30 minutes. Complete as much as possible without looking at notes. If you can complete all queries within the time limit the exam will be extremely easy.

### Scenario: BookClub Database

A book club tracks its members, books, and reading sessions.

**Requirements:**

- Members: first_name, last_name, email (unique), join_date
- Books: title, author, isbn (unique, 13 chars), genre, page_count
- Reading sessions: which member read which book, start_date, end_date (nullable — still reading), rating (1-5, nullable — not yet rated)

### Tasks:

**Task A (5 min):** Write CREATE TABLE statements for all three tables with appropriate constraints.

**Task B (3 min):** Insert 3 members, 4 books, and 5 reading sessions.

**Task C (2 min):** Write an UPDATE that sets the end_date of member 1's reading of book 2 to today, and the rating to 4.

**Task D (5 min):** Write queries for:

1. All books that member 1 has read (show title, rating)
2. Average rating per book (only completed readings)
3. Members who have never rated any book below 3

**Task E (5 min):** Write a query showing: member name, number of books read, number of books currently reading (end_date IS NULL), average rating given.

**Task F (5 min):** Write a query finding books that NO member has read yet.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Task A: Create the BookClub tables
> CREATE TABLE members (
>     member_id SERIAL PRIMARY KEY,
>     first_name VARCHAR(100) NOT NULL,
>     last_name VARCHAR(100) NOT NULL,
>     email VARCHAR(255) NOT NULL UNIQUE,
>     join_date DATE NOT NULL DEFAULT CURRENT_DATE
> );
>
> CREATE TABLE books (
>     book_id SERIAL PRIMARY KEY,
>     title VARCHAR(200) NOT NULL,
>     author VARCHAR(150) NOT NULL,
>     isbn CHAR(13) NOT NULL UNIQUE,
>     genre VARCHAR(100) NOT NULL,
>     page_count INTEGER NOT NULL CHECK (page_count > 0)
> );
>
> CREATE TABLE reading_sessions (
>     reading_session_id SERIAL PRIMARY KEY,
>     member_id INTEGER NOT NULL REFERENCES members(member_id),
>     book_id INTEGER NOT NULL REFERENCES books(book_id),
>     start_date DATE NOT NULL DEFAULT CURRENT_DATE,
>     end_date DATE,
>     rating INTEGER CHECK (rating BETWEEN 1 AND 5),
>     CHECK (end_date IS NULL OR end_date >= start_date)
> );
>
> -- Task B: Insert 3 members, 4 books, and 5 reading sessions
> INSERT INTO members (first_name, last_name, email, join_date) VALUES
>     ('Aino', 'Virtanen', 'aino.v@example.com', CURRENT_DATE - 100),
>     ('Markus', 'Laine', 'markus.l@example.com', CURRENT_DATE - 80),
>     ('Sara', 'Niemi', 'sara.n@example.com', CURRENT_DATE - 60);
>
> INSERT INTO books (title, author, isbn, genre, page_count) VALUES
>     ('Database Basics', 'Mika Example', '9780000000001', 'Education', 240),
>     ('The Forest Path', 'Laura Example', '9780000000002', 'Fiction', 310),
>     ('SQL Made Clear', 'Pekka Example', '9780000000003', 'Education', 180),
>     ('Northern Stories', 'Anna Example', '9780000000004', 'Fiction', 220);
>
> INSERT INTO reading_sessions (member_id, book_id, start_date, end_date, rating) VALUES
>     (1, 1, CURRENT_DATE - 12, CURRENT_DATE - 5, 5),
>     (1, 2, CURRENT_DATE - 4, NULL, NULL),
>     (2, 2, CURRENT_DATE - 10, CURRENT_DATE - 3, 3),
>     (2, 3, CURRENT_DATE - 2, NULL, NULL),
>     (3, 4, CURRENT_DATE - 8, CURRENT_DATE - 1, 2);
>
> -- Task C: Finish member 1's reading of book 2 and give it a rating of 4
> UPDATE reading_sessions
> SET end_date = CURRENT_DATE,
>     rating = 4
> WHERE member_id = 1
>   AND book_id = 2
>   AND end_date IS NULL;
>
> -- Task D1: Books member 1 has completed reading
> SELECT b.title, rs.rating
> FROM reading_sessions rs
> INNER JOIN books b ON b.book_id = rs.book_id
> WHERE rs.member_id = 1
>   AND rs.end_date IS NOT NULL
> ORDER BY b.title;
>
> -- Task D2: Average rating per book, considering completed readings only
> SELECT b.title,
>        ROUND(AVG(rs.rating)::numeric, 2) AS average_rating
> FROM books b
> INNER JOIN reading_sessions rs ON rs.book_id = b.book_id
> WHERE rs.end_date IS NOT NULL
> GROUP BY b.book_id, b.title
> ORDER BY b.title;
>
> -- Task D3: Members who have never rated a book below 3
> SELECT m.member_id,
>        m.first_name,
>        m.last_name
> FROM members m
> WHERE NOT EXISTS (
>     SELECT 1
>     FROM reading_sessions rs
>     WHERE rs.member_id = m.member_id
>       AND rs.rating < 3
> )
> ORDER BY m.member_id;
>
> -- Task E: Reading counts and average rating for every member
> SELECT m.member_id,
>        m.first_name || ' ' || m.last_name AS member_name,
>        COUNT(DISTINCT CASE WHEN rs.end_date IS NOT NULL THEN rs.book_id END) AS books_read,
>        COUNT(DISTINCT CASE WHEN rs.end_date IS NULL THEN rs.book_id END) AS books_currently_reading,
>        ROUND(AVG(rs.rating)::numeric, 2) AS average_rating
> FROM members m
> LEFT JOIN reading_sessions rs ON rs.member_id = m.member_id
> GROUP BY m.member_id, m.first_name, m.last_name
> ORDER BY m.member_id;
>
> -- Task F: Books with no reading session recorded
> SELECT b.book_id, b.title
> FROM books b
> WHERE NOT EXISTS (
>     SELECT 1
>     FROM reading_sessions rs
>     WHERE rs.book_id = b.book_id
> )
> ORDER BY b.book_id;
> ```

**Task G (5 min):** Write ALTER TABLE statements to:

1. Add a `pages_read INTEGER DEFAULT 0` column to reading sessions
2. Add a CHECK constraint ensuring pages_read <= the book's page_count (Hint: this requires a trigger or application logic — explain why a simple CHECK can't do cross-table validation)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> -- Add pages_read and validate that it is not negative
> ALTER TABLE reading_sessions
> ADD COLUMN pages_read INTEGER NOT NULL DEFAULT 0
> CHECK (pages_read >= 0);
>
> -- A CHECK constraint cannot compare pages_read with books.page_count,
> -- because PostgreSQL CHECK constraints cannot query another table.
> -- Use a trigger for the cross-table rule instead.
> CREATE OR REPLACE FUNCTION validate_pages_read_against_book()
> RETURNS TRIGGER
> LANGUAGE plpgsql
> AS $$
> DECLARE
>     total_pages INTEGER;
> BEGIN
>     SELECT page_count
>     INTO total_pages
>     FROM books
>     WHERE book_id = NEW.book_id;
>
>     IF NEW.pages_read > total_pages THEN
>         RAISE EXCEPTION 'pages_read (%) cannot exceed page_count (%) for book %',
>             NEW.pages_read, total_pages, NEW.book_id;
>     END IF;
>
>     RETURN NEW;
> END;
> $$;
>
> CREATE TRIGGER trg_validate_pages_read
> BEFORE INSERT OR UPDATE OF pages_read, book_id
> ON reading_sessions
> FOR EACH ROW
> EXECUTE FUNCTION validate_pages_read_against_book();
>
> -- Also prevent lowering a book's page_count below existing reading progress.
> CREATE OR REPLACE FUNCTION validate_updated_book_page_count()
> RETURNS TRIGGER
> LANGUAGE plpgsql
> AS $$
> BEGIN
>     IF EXISTS (
>         SELECT 1
>         FROM reading_sessions rs
>         WHERE rs.book_id = NEW.book_id
>           AND rs.pages_read > NEW.page_count
>     ) THEN
>         RAISE EXCEPTION 'page_count cannot be lower than pages already read for book %',
>             NEW.book_id;
>     END IF;
>
>     RETURN NEW;
> END;
> $$;
>
> CREATE TRIGGER trg_validate_book_page_count
> BEFORE UPDATE OF page_count
> ON books
> FOR EACH ROW
> EXECUTE FUNCTION validate_updated_book_page_count();
> ```

> [!NOTE]
> **_Your Answer_**
>
> A normal CHECK constraint can validate values in the current row, such as requiring pages_read to be zero or greater. It cannot look up page_count from the separate books table. That comparison needs a trigger or application-level validation. The trigger above checks the book's page count before a reading session is inserted or updated and also prevents a book's page count from being lowered below recorded progress.

---

## Submission Checklist

**Required**

- [ ] TrailShop database verified (schema + data + constraints tested)

**Recommended practice** (Exam 1 preparation)

- [ ] PetStore mini-case completed (tables created, data inserted, all 5 queries working)
- [ ] All 10 mixed-topic questions answered
- [ ] Timed practice completed (note how much you finished in 30 minutes)
- [ ] Self-assessment checklist from Theory filled in — study weak areas before the exam

---

*Completed responses are based on the provided Week 42 exercise sheet and chapter notes. SQL should be run in a fresh/appropriate PostgreSQL database and verified locally before submission.*
