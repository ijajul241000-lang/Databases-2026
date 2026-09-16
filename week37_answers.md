# Week 37 — Exercise Answers

These answers are written in simple, natural language so they are easy to understand and revise before submitting.

## Part 1 — TrailShop Project Task

### Task 1: Identify Keys

**1. Primary key of `products`**

The primary key is `product_id`. It is a good choice because each product gets one unique ID, and the ID does not depend on the product name or price changing.

**2. Primary key of `categories`**

The primary key is `category_id`. It uniquely identifies each category and is simple to use when other tables need to reference a category.

**3. Foreign key in `products`**

The foreign key is `category_id`. It references `categories.category_id`, so every product is connected to an existing category.

**4. Is `name` a candidate key?**

`name` can be a candidate key only if TrailShop guarantees that every product name is unique. It would be a poor primary key if names can be duplicated or changed later, because a primary key should be stable and unique.

**5. Superkey that is not a candidate key**

`(product_id, name)` is a superkey. It is not a candidate key because `product_id` alone already identifies the row, so `name` is extra and the key is not minimal.

**6. Composite key example**

For `order_items`, `(order_id, product_id)` can be a composite key. `order_id` alone is not unique because one order has several products, and `product_id` alone is not unique because the same product can appear in different orders.

**7. Is `email` a candidate key?**

Yes, `email` can be a candidate key when every customer must have a different email address. Unlike `customer_id`, email has business meaning and can change, so `customer_id` is usually the more stable primary key.

### Task 2: Business Rules

| Business Rule | Constraint Type | Table.Column | SQL |
|---|---|---|---|
| Every product must have a name | NOT NULL | products.name | `NOT NULL` |
| Product price must be greater than zero | CHECK | products.price | `CHECK (price > 0)` |
| Stock cannot be negative | CHECK | products.stock_quantity | `CHECK (stock_quantity >= 0)` |
| Customer email must be unique | UNIQUE | customers.email | `UNIQUE` |
| Every order must belong to an existing customer | FOREIGN KEY + NOT NULL | orders.customer_id | `REFERENCES customers(customer_id)` |

### Task 3: Integrity Violations

**A — FAIL.** `category_id` is the primary key, so it cannot be `NULL`. Expected error: `null value in column "category_id" ... violates not-null constraint`.

**B — SUCCESS.** Category `2` exists, the product ID is new, and the price and stock values satisfy the checks.

**C — FAIL.** The price is `-5.00`, which violates `CHECK (price > 0)`.

**D — FAIL.** Product ID `103` already exists, so the primary key constraint is violated. Expected error: duplicate key value violates unique constraint.

**E — FAIL.** Category `10` does not exist, so the foreign key on `category_id` is violated.

**F — FAIL.** `name` is `NOT NULL`, so a product cannot be inserted with a `NULL` name.

**G — FAIL.** Stock quantity `-3` violates `CHECK (stock_quantity >= 0)`.

**H — FAIL.** `quantity = 0` violates `CHECK (quantity > 0)`.

### Task 4: Foreign Key Actions

1. **RESTRICT:** The delete fails because products 102 and 106 still reference category 2.

   **CASCADE:** Category 2 is deleted and products 102 and 106 are also deleted.

   **SET NULL:** Category 2 is deleted and products 102 and 106 stay in the database, but their `category_id` becomes `NULL`.

2. I would use **`ON DELETE RESTRICT`** for `products.category_id`. A category should not disappear while products still depend on it, because deleting the category could accidentally remove or disconnect important product information. `SET NULL` could also be reasonable if TrailShop wants to keep products without a category.

## Part 2 — Theory Review

### Q1. Relation, tuple, attribute, domain

A **relation** is a table, such as the `products` table. A **tuple** is one row, for example product 101. An **attribute** is a column such as `price`, and a **domain** is the allowed set of values for an attribute, such as positive decimal numbers for price.

### Q2. Candidate key vs primary key

A candidate key is a minimal set of columns that can uniquely identify a row. A table can have more than one candidate key, but only one of them is selected as the primary key.

### Q3. Entity integrity

Entity integrity means every table must have a primary key and no part of the primary key can be `NULL`. A primary key cannot be `NULL` because then the database could not reliably identify that row.

### Q4. Referential integrity

Referential integrity means a foreign key must refer to an existing primary key, unless the foreign key is allowed to be `NULL`. For example, `INSERT INTO products (product_id, name, price, stock_quantity, category_id) VALUES (109, 'Test', 50, 5, 99);` fails because category 99 does not exist.

### Q5. Surrogate key vs natural key

A surrogate key is an artificial ID created mainly for identification, such as `book_id = 15`. A natural key comes from real-world data, such as an ISBN, so `ISBN` could be a natural key in a `books` table.

### Q6. NULL and `WHERE price = NULL`

`NULL` means the value is unknown or not applicable. `WHERE price = NULL` is wrong because comparisons with `NULL` produce `UNKNOWN`; the correct condition is `WHERE price IS NULL`.

### Q7. Junction table

A junction table is used to implement a many-to-many relationship. For example, `product_tags(product_id, tag_id)` connects many products with many tags.

### Q8. 1:1, 1:N, M:N relationships

A 1:1 relationship means one row matches one row, such as a product and one separate product-detail row. A 1:N relationship means one row can have many related rows, such as one category having many products. An M:N relationship means many rows can relate to many rows, such as products and tags, and it needs a junction table.

### Q9. CASCADE vs RESTRICT

`ON DELETE CASCADE` automatically deletes the related rows when the parent row is deleted. `ON DELETE RESTRICT` blocks the delete while related rows still exist; it is safer when accidental deletion would be a problem.

### Q10. Atomic entries

Atomic entries mean each cell contains one value, not a list of several values. For example, putting `"Footwear, Hiking"` into one category cell violates atomicity because two categories are stored in one field.

## True / False

1. **False** — A superkey does not have to be minimal; a candidate key is a minimal superkey.
2. **True** — A primary key may contain multiple columns.
3. **False** — `NULL = NULL` evaluates to `UNKNOWN`, not `TRUE`.
4. **False** — A foreign key may be `NULL` if the column allows it.
5. **True** — A foreign key must match an existing referenced key or be `NULL` when allowed.
6. **False** — Degree is the number of columns; cardinality is the number of rows.

## Matching Exercise

| # | Your Match |
|---|---|
| 1 | F |
| 2 | G |
| 3 | B |
| 4 | H |
| 5 | E |
| 6 | D |
| 7 | J |
| 8 | C |
| 9 | A |
| 10 | K |
| 11 | I |
| 12 | L |

## Part 3 — SQL Practice

### Exercise 3.1

1. **SUCCESS** — Carol is inserted into department 1.
2. **FAIL** — `CHECK (salary >= 0)` because salary is negative.
3. **FAIL** — primary key violation because employee 100 already exists.
4. **FAIL** — foreign key violation because department 5 does not exist.
5. **FAIL** — unique constraint on `departments.dept_name` because Engineering already exists.
6. **FAIL** — `NOT NULL` violation because `name` is `NULL`.
7. **FAIL** — foreign key violation because employees still reference department 1.
8. **SUCCESS** — salary 0 satisfies the `salary >= 0` check and department 2 exists.

### Exercise 3.2 — Bookstore CREATE TABLE

The runnable SQL is included in `week37_trailshop.sql` under **Part 4: BOOKSTORE DESIGN**.

The design uses four tables: `genres`, `books`, `authors`, and `book_authors`. The `book_authors` table is the junction table for the many-to-many relationship between books and authors.

## Part 4 — Library System Design

### 1. Tables and columns

**library_genres**
- `genre_id`
- `genre_name`

**library_books**
- `book_id`
- `isbn`
- `title`
- `publication_year`
- `genre_id`

**copies**
- `copy_id`
- `book_id`
- `barcode`

**library_members**
- `member_number`
- `name`
- `email`
- `phone`

**borrowings**
- `borrowing_id`
- `member_number`
- `copy_id`
- `borrow_date`
- `due_date`
- `return_date`

### 2. Primary keys

`genre_id`, `book_id`, `copy_id`, `member_number`, and `borrowing_id` are surrogate keys. They are simple IDs and do not depend on business information changing. ISBN, barcode, and email are better treated as natural or alternate keys and enforced with `UNIQUE` where required.

### 3. Foreign keys

- `library_books.genre_id` → `library_genres.genre_id`
- `copies.book_id` → `library_books.book_id`
- `borrowings.member_number` → `library_members.member_number`
- `borrowings.copy_id` → `copies.copy_id`

### 4. Candidate / alternate keys

`isbn` is a candidate key for books because each ISBN should identify one book edition. `barcode` is a candidate key for copies, and `email` can be an alternate key for members if the library requires unique member emails.

### 5. Business rules and constraints

| Rule | Constraint / Method |
|---|---|
| Every book has a unique ISBN | `UNIQUE` + `NOT NULL` |
| Every copy has a unique barcode | `UNIQUE` + `NOT NULL` |
| Every book belongs to one genre | `NOT NULL` + `FOREIGN KEY` |
| Due date is 14 days after borrow date | `CHECK (due_date = borrow_date + 14)` |
| A copy cannot have two active loans | Partial `UNIQUE` index on `copy_id` where `return_date IS NULL` |
| A member can borrow at most 5 copies | Needs a trigger or application logic; not a simple row-level CHECK constraint |

### 6. CREATE TABLE statements

The full runnable SQL for the library design is included in `week37_trailshop.sql` under **Part 5: LIBRARY SYSTEM DESIGN**.

