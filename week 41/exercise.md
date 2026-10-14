# Week 41 — Exercises: Querying Data

> [!IMPORTANT]
> **_How to Complete These Exercises_**
> Write your answers directly in the highlighted **Your Answer** / **Your SQL** fields below each task. Replace the placeholder text with your own work before submitting.

## Exercise 1: TrailShop Project Task — Business Questions

Use the TrailShop database you created in Week 40. Write SQL queries to answer each business question below. Run each query and verify the results make sense.

> [!IMPORTANT]
> **_Tools to use_**
> You can use both the pgAdmin or psql (terminal) to test the queries

### Basic Queries (SELECT + WHERE)

1. List all products in the 'Footwear' category (show name, price, stock).

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT p.name, p.price, p.stock
   > FROM products p
   > JOIN product_categories pc ON pc.product_id = p.product_id
   > JOIN categories c ON c.category_id = pc.category_id
   > WHERE c.name = 'Footwear'
   > ORDER BY p.name;
   > ```

2. Find all products priced between €50 and €150, sorted by price ascending.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT name, price
   > FROM products
   > WHERE price BETWEEN 50 AND 150
   > ORDER BY price ASC;
   > ```

3. Show all customers whose last name starts with the letter 'M' or 'K'.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT first_name, last_name, email
   > FROM customers
   > WHERE last_name LIKE 'M%'
   >    OR last_name LIKE 'K%'
   > ORDER BY last_name, first_name;
   > ```

4. List all orders with status 'pending' or 'shipped', sorted by order date (most recent first).

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT order_id, customer_id, order_date, status
   > FROM orders
   > WHERE status IN ('pending', 'shipped')
   > ORDER BY order_date DESC;
   > ```

5. Find all products that have the word 'Pro' or 'pro' somewhere in their name.
   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT name, price, stock
   > FROM products
   > WHERE name ILIKE '%pro%'
   > ORDER BY name;
   > ```

### Aggregate Queries

6. What is the total number of products in the database?

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT COUNT(*) AS total_products
> FROM products;
> ```

7. What is the average price of all products? Round to 2 decimal places.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT ROUND(AVG(price), 2) AS average_price
   > FROM products;
   > ```

8. Which is the most expensive product and which is the cheapest? Show both in one query.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT 'Most expensive' AS price_type, name, price
   > FROM products
   > WHERE price = (SELECT MAX(price) FROM products)
   > UNION ALL
   > SELECT 'Cheapest' AS price_type, name, price
   > FROM products
   > WHERE price = (SELECT MIN(price) FROM products);
   > ```

9. How many orders does each customer have? Show customer name and order count, sorted by count descending.

   > [!NOTE]
   > **_Your SQL_**
   >
   > ```sql
   > SELECT c.customer_id,
   >        c.first_name,
   >        c.last_name,
   >        COUNT(o.order_id) AS order_count
   > FROM customers c
   > LEFT JOIN orders o ON o.customer_id = c.customer_id
   > GROUP BY c.customer_id, c.first_name, c.last_name
   > ORDER BY order_count DESC, c.last_name, c.first_name;
   > ```

10. What is the total revenue (sum of quantity × unit_price from order_items) for each order status?

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT o.status,
>        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
> FROM orders o
> LEFT JOIN order_items oi ON oi.order_id = o.order_id
> GROUP BY o.status
> ORDER BY o.status;
> ```

### JOIN Queries

11. List all products with their category names (join through `product_categories`). A product in two categories should appear twice. Sort by category name, then product name.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT p.name AS product_name, c.name AS category_name
    > FROM products p
    > JOIN product_categories pc ON pc.product_id = p.product_id
    > JOIN categories c ON c.category_id = pc.category_id
    > ORDER BY c.name, p.name;
    > ```

12. Show each order with the customer's full name, order date, and status.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT o.order_id,
    >        c.first_name || ' ' || c.last_name AS customer_name,
    >        o.order_date,
    >        o.status
    > FROM orders o
    > JOIN customers c ON c.customer_id = o.customer_id
    > ORDER BY o.order_date DESC;
    > ```

13. Show a detailed breakdown of order #1: product name, quantity, unit price, and line total.

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT p.name AS product_name,
    >        oi.quantity,
    >        oi.unit_price,
    >        oi.quantity * oi.unit_price AS line_total
    > FROM order_items oi
    > JOIN products p ON p.product_id = oi.product_id
    > WHERE oi.order_id = 1
    > ORDER BY p.name;
    > ```

14. Find all customers who have NOT placed any orders. (Hint: use LEFT JOIN + IS NULL pattern.)

    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT c.customer_id, c.first_name, c.last_name, c.email
    > FROM customers c
    > LEFT JOIN orders o ON o.customer_id = c.customer_id
    > WHERE o.order_id IS NULL
    > ORDER BY c.last_name, c.first_name;
    > ```

15. For each category, show the category name, number of products, average price, and total inventory value (price × stock summed). Only include categories with total inventory value greater than €500.
    > [!NOTE]
    > **_Your SQL_**
    >
    > ```sql
    > SELECT c.name AS category_name,
    >        COUNT(p.product_id) AS number_of_products,
    >        ROUND(AVG(p.price), 2) AS average_price,
    >        SUM(p.price * p.stock) AS total_inventory_value
    > FROM categories c
    > JOIN product_categories pc ON pc.category_id = c.category_id
    > JOIN products p ON p.product_id = pc.product_id
    > GROUP BY c.category_id, c.name
    > HAVING SUM(p.price * p.stock) > 500
    > ORDER BY total_inventory_value DESC;
    > ```

---

## Exercise 2: Theory Review Questions

Answer in your own words:

1. What is the logical execution order of a SQL query? Why does it matter?

> [!NOTE]
> **_Your Answer_**
>
> The logical order is FROM/JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, then LIMIT/OFFSET. It matters because the query is not evaluated in the order it is written. For example, WHERE runs before SELECT, so a SELECT alias is not available in WHERE; aggregate conditions belong in HAVING, not WHERE.

2. What is the difference between WHERE and HAVING? Give an example of when you would use each.

> [!NOTE]
> **_Your Answer_**
>
> WHERE filters individual rows before grouping, while HAVING filters groups after GROUP BY and can use aggregate results. For example, WHERE stock > 0 selects products that are in stock before aggregation. HAVING COUNT(*) > 2 can show only categories that have more than two products.

3. Explain the difference between COUNT(\*), COUNT(column), and COUNT(DISTINCT column).

> [!NOTE]
> **_Your Answer_**
>
> COUNT(*) counts every row. COUNT(column) counts only rows where that column is not NULL. COUNT(DISTINCT column) counts unique non-NULL values in that column.

4. What is the difference between INNER JOIN and LEFT JOIN? When would you choose one over the other?

> [!NOTE]
> **_Your Answer_**
>
> INNER JOIN returns only rows with a matching row in both tables. LEFT JOIN returns every row from the left table and matching rows from the right; if there is no match, right-side columns are NULL. I use INNER JOIN when I only want matched records and LEFT JOIN when I also need records with no related row, such as customers who have never ordered.

5. Why should you avoid SELECT \* in production code?

> [!NOTE]
> **_Your Answer_**
>
> SELECT * returns every column, even if the query only needs a few. It can transfer unnecessary data, makes the query less clear, and may behave differently if the table's columns change. Listing the required columns is clearer and easier to maintain.

6. What does DISTINCT do? On what level does it operate (columns or entire rows)?

> [!NOTE]
> **_Your Answer_**
>
> DISTINCT removes duplicate result rows. It applies to the whole set of selected columns, not each column independently. Two rows are duplicates only when every selected value matches.

7. Can you use a column alias in a WHERE clause? Why or why not?

> [!NOTE]
> **_Your Answer_**
>
> No. WHERE is logically evaluated before SELECT, so the alias has not been created yet. Repeat the expression in WHERE or put the calculation in a subquery or CTE. An alias can be used in ORDER BY because ORDER BY is evaluated after SELECT.
>
> 8. Explain what happens when you GROUP BY a column and there's a column in SELECT that isn't aggregated and isn't in GROUP BY.

> [!NOTE]
> **_Your Answer_**
>
> In standard SQL, a selected column that is not inside an aggregate function must be included in GROUP BY. Otherwise, SQL does not know which value to show for a group that contains several different values, so it reports an error.

---

## Exercise 3: Query Writing Exercises (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

Write the SQL for each task. Use the TrailShop schema (categories, customers, products, product_categories, orders, order_items).

### Simple SELECT + WHERE

**3.1** — Select product names and prices for all products with stock less than 15.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT name, price
> FROM products
> WHERE stock < 15
> ORDER BY name;
> ```

**3.2** — Find all customers who registered (created_at) in 2026. Show first name, last name, and registration date.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT first_name, last_name, created_at::date AS registration_date
> FROM customers
> WHERE created_at >= TIMESTAMPTZ '2026-01-01 00:00:00+00'
>   AND created_at <  TIMESTAMPTZ '2027-01-01 00:00:00+00'
> ORDER BY created_at;
> ```

**3.3** — Show all products that do NOT have a description (description IS NULL).

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT product_id, name
> FROM products
> WHERE description IS NULL;
> ```

### Multi-condition Filtering

**3.4** — Find products in category 1 OR category 2, priced above €100, with stock greater than 0. Sort by price descending.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT p.product_id, p.name, p.price, p.stock
> FROM products p
> WHERE p.price > 100
>   AND p.stock > 0
>   AND EXISTS (
>       SELECT 1
>       FROM product_categories pc
>       WHERE pc.product_id = p.product_id
>         AND pc.category_id IN (1, 2)
>   )
> ORDER BY p.price DESC;
> ```

**3.5** — Find orders that are either 'delivered' or placed by customer_id 1. Show order_id, customer_id, status.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT order_id, customer_id, status
> FROM orders
> WHERE status = 'delivered'
>    OR customer_id = 1
> ORDER BY order_id;
> ```

### Aggregation

**3.6** — For each category, show the category name, minimum, maximum, and average product price. Round averages to 2 decimal places. Join through `product_categories`.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.name AS category_name,
>        MIN(p.price) AS minimum_price,
>        MAX(p.price) AS maximum_price,
>        ROUND(AVG(p.price), 2) AS average_price
> FROM categories c
> LEFT JOIN product_categories pc ON pc.category_id = c.category_id
> LEFT JOIN products p ON p.product_id = pc.product_id
> GROUP BY c.category_id, c.name
> ORDER BY c.name;
> ```

**3.7** — Count how many distinct customers have placed at least one order.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
> FROM orders;
> ```

**3.8** — Find the total quantity of items sold across all orders.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT COALESCE(SUM(quantity), 0) AS total_quantity_sold
> FROM order_items;
> ```

### JOIN Queries

**3.9** — Show each product name alongside its category name. Include all products (even if somehow a category was deleted — use LEFT JOIN).

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT p.name AS product_name, c.name AS category_name
> FROM products p
> LEFT JOIN product_categories pc ON pc.product_id = p.product_id
> LEFT JOIN categories c ON c.category_id = pc.category_id
> ORDER BY p.name, c.name;
> ```

**3.10** — List all orders showing: order_id, customer full name, order date, number of items in the order, and order total cost.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT o.order_id,
>        c.first_name || ' ' || c.last_name AS customer_name,
>        o.order_date,
>        COALESCE(SUM(oi.quantity), 0) AS number_of_items,
>        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
> FROM orders o
> JOIN customers c ON c.customer_id = o.customer_id
> LEFT JOIN order_items oi ON oi.order_id = o.order_id
> GROUP BY o.order_id, c.first_name, c.last_name, o.order_date
> ORDER BY o.order_id;
> ```

**3.11** — Show all products that have NEVER been ordered. (Hint: LEFT JOIN order_items, then IS NULL on order_item_id.)

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT p.product_id, p.name
> FROM products p
> LEFT JOIN order_items oi ON oi.product_id = p.product_id
> WHERE oi.order_item_id IS NULL
> ORDER BY p.name;
> ```

### GROUP BY + HAVING

**3.12** — Show categories where the average product price exceeds €100. Display category name and average price.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.name AS category_name,
>        ROUND(AVG(p.price), 2) AS average_price
> FROM categories c
> JOIN product_categories pc ON pc.category_id = c.category_id
> JOIN products p ON p.product_id = pc.product_id
> GROUP BY c.category_id, c.name
> HAVING AVG(p.price) > 100
> ORDER BY average_price DESC;
> ```

**3.13** — Find customers who have placed more than 1 order. Show their name and order count.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.customer_id,
>        c.first_name,
>        c.last_name,
>        COUNT(o.order_id) AS order_count
> FROM customers c
> JOIN orders o ON o.customer_id = c.customer_id
> GROUP BY c.customer_id, c.first_name, c.last_name
> HAVING COUNT(o.order_id) > 1
> ORDER BY order_count DESC;
> ```

### Pagination

**3.14** — Write a paginated query that returns products 4 through 6 (page 2, page size 3), ordered by product_id.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT product_id, name, price, stock
> FROM products
> ORDER BY product_id
> LIMIT 3 OFFSET 3;
> ```

### Complex

**3.15** — Write a "sales report" query that shows: category name, total units sold (from order_items), total revenue, and number of distinct products sold — for each category. Sort by revenue descending.

> [!NOTE]
> **_Your SQL_**
>
> ```sql
> SELECT c.name AS category_name,
>        COALESCE(SUM(oi.quantity), 0) AS total_units_sold,
>        COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue,
>        COUNT(DISTINCT oi.product_id) AS distinct_products_sold
> FROM categories c
> LEFT JOIN product_categories pc ON pc.category_id = c.category_id
> LEFT JOIN order_items oi ON oi.product_id = pc.product_id
> GROUP BY c.category_id, c.name
> ORDER BY total_revenue DESC, c.name;
> ```

---

## Exercise 4: Query Reading Exercise (Optional)

> [!TIP]
> **Recommended practice.** Do this section. It is not required to finish the TrailShop project. It prepares you for the exams.

For each query below, explain in **plain English** what it does and what the result would look like.

### 4.1

```sql
SELECT c.name, COUNT(p.product_id) AS num_products
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN products p ON p.product_id = pc.product_id
GROUP BY c.name
ORDER BY num_products DESC;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> No syntax error is present. The query keeps every category because it uses LEFT JOIN, counts the matched products for each category, and sorts categories from the greatest product count to the smallest. The result has one row per category with the category name and product count; a category with no products gets a count of zero.
>
> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- The original query is valid; reproduced here for reference.
> SELECT c.name, COUNT(p.product_id) AS num_products
> FROM categories c
> LEFT JOIN product_categories pc ON pc.category_id = c.category_id
> LEFT JOIN products p ON p.product_id = pc.product_id
> GROUP BY c.name
> ORDER BY num_products DESC;
> ```

### 4.2

```sql
SELECT first_name, last_name
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
);
```

> [!NOTE]
> **_Error(s) Identified_**
>
> The query returns customers who do not have a matching customer_id in orders. It displays each customer's first and last name. In the supplied Week 40 schema, orders.customer_id is NOT NULL, so this query works. A LEFT JOIN with IS NULL is also a robust alternative if the subquery's column could contain NULL values.
>
> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Equivalent version that avoids NOT IN NULL pitfalls.
> SELECT c.first_name, c.last_name
> FROM customers c
> LEFT JOIN orders o ON o.customer_id = c.customer_id
> WHERE o.order_id IS NULL;
> ```

### 4.3

```sql
SELECT p.name, p.price, p.stock,
       p.price * p.stock AS inventory_value
FROM products p
WHERE p.stock > 0
ORDER BY inventory_value DESC
LIMIT 3;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> No syntax error is present. The query calculates each in-stock product's inventory value as price multiplied by stock, sorts the products from highest inventory value to lowest, and returns only the first three. Each result row shows the product name, price, stock, and calculated inventory value.
>
> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- The original query is valid; reproduced here for reference.
> SELECT p.name, p.price, p.stock,
>        p.price * p.stock AS inventory_value
> FROM products p
> WHERE p.stock > 0
> ORDER BY inventory_value DESC
> LIMIT 3;
> ```

### 4.4

```sql
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 200
ORDER BY order_total DESC;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> No syntax error is present. The query calculates total revenue for each order that has order items, ignores cancelled orders, keeps only orders with a total above 200, and sorts the qualifying orders by total revenue from highest to lowest. The INNER JOIN means orders with no order items do not appear.
>
> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- The original query is valid; reproduced here for reference.
> SELECT o.order_id,
>        SUM(oi.quantity * oi.unit_price) AS order_total
> FROM orders o
> INNER JOIN order_items oi ON o.order_id = oi.order_id
> WHERE o.status <> 'cancelled'
> GROUP BY o.order_id
> HAVING SUM(oi.quantity * oi.unit_price) > 200
> ORDER BY order_total DESC;
> ```

### 4.5

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(DISTINCT o.order_id) AS num_orders,
       SUM(oi.quantity) AS total_items,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC NULLS LAST;
```

> [!NOTE]
> **_Error(s) Identified_**
>
> No syntax error is present. The query returns one row per customer with the customer's full name, number of distinct orders, total quantity of items, and total amount spent. LEFT JOIN keeps customers even if they have never ordered; for such customers, COUNT returns zero while SUM values are NULL. The results are sorted by spending, with NULL totals last.
>
> [!NOTE]
> **_Corrected SQL_**
>
> ```sql
> -- Equivalent version showing zero totals for customers with no orders.
> SELECT c.first_name || ' ' || c.last_name AS customer,
>        COUNT(DISTINCT o.order_id) AS num_orders,
>        COALESCE(SUM(oi.quantity), 0) AS total_items,
>        COALESCE(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_spent
> FROM customers c
> LEFT JOIN orders o ON c.customer_id = o.customer_id
> LEFT JOIN order_items oi ON o.order_id = oi.order_id
> GROUP BY c.customer_id, c.first_name, c.last_name
> ORDER BY total_spent DESC;
> ```

---

## Submission Checklist

**Required**

- [ ] All 15 business questions answered with working SQL
- [ ] Theory review questions answered in your own words
- [ ] Results of the business questions verified by running them against your TrailShop database

**Recommended practice**

- [ ] All 15 query writing exercises completed
- [ ] All 5 query reading explanations written