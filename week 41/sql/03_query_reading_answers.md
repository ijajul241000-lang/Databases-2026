# Week 41 Exercise 4 — Query Reading Answers

## 4.1
No syntax error is present. The query keeps every category because it uses LEFT JOIN, counts the matched products for each category, and sorts categories from the greatest product count to the smallest. The result has one row per category with the category name and product count; a category with no products gets a count of zero.

```sql
SELECT c.name, COUNT(p.product_id) AS num_products
FROM categories c
LEFT JOIN product_categories pc ON pc.category_id = c.category_id
LEFT JOIN products p ON p.product_id = pc.product_id
GROUP BY c.name
ORDER BY num_products DESC;
```

## 4.2
The query returns customers who do not have a matching customer_id in orders. It displays each customer's first and last name. In the supplied Week 40 schema, orders.customer_id is NOT NULL, so this query works. A LEFT JOIN with IS NULL is also a robust alternative if the subquery's column could contain NULL values.

```sql
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;
```

## 4.3
No syntax error is present. The query calculates each in-stock product's inventory value as price multiplied by stock, sorts the products from highest inventory value to lowest, and returns only the first three. Each result row shows the product name, price, stock, and calculated inventory value.

```sql
SELECT p.name, p.price, p.stock,
       p.price * p.stock AS inventory_value
FROM products p
WHERE p.stock > 0
ORDER BY inventory_value DESC
LIMIT 3;
```

## 4.4
No syntax error is present. The query calculates total revenue for each order that has order items, ignores cancelled orders, keeps only orders with a total above 200, and sorts the qualifying orders by total revenue from highest to lowest. The INNER JOIN means orders with no order items do not appear.

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

## 4.5
No syntax error is present. The query returns one row per customer with the customer's full name, number of distinct orders, total quantity of items, and total amount spent. LEFT JOIN keeps customers even if they have never ordered; for such customers, COUNT returns zero while SUM values are NULL. The results are sorted by spending, with NULL totals last.

```sql
SELECT c.first_name || ' ' || c.last_name AS customer,
       COUNT(DISTINCT o.order_id) AS num_orders,
       COALESCE(SUM(oi.quantity), 0) AS total_items,
       COALESCE(ROUND(SUM(oi.quantity * oi.unit_price), 2), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;
```
