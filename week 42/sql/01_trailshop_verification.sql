-- Week 42 Exercise 1: TrailShop schema and data verification
-- Run after your Week 40 setup in the trailshop database.

-- In psql, use these commands to inspect tables/columns:
-- \dt
-- \d categories
-- \d customers
-- \d products
-- \d product_categories
-- \d orders
-- \d order_items

-- Constraint inventory: primary keys, foreign keys, unique/check constraints.
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

-- CHECK constraint definitions.
SELECT conrelid::regclass AS table_name,
       conname AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid IN (
    'categories'::regclass, 'customers'::regclass, 'products'::regclass,
    'product_categories'::regclass, 'orders'::regclass, 'order_items'::regclass
)
ORDER BY table_name, constraint_name;

-- Row counts for the six required tables.
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_categories', COUNT(*) FROM product_categories
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- Relationship check across all six tables.
SELECT c.first_name, cat.name AS category, p.name AS product,
       oi.quantity, o.status
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_categories pc ON pc.product_id = p.product_id
JOIN categories cat ON cat.category_id = pc.category_id
ORDER BY c.first_name, o.order_id;

-- Test that a non-existent category ID is rejected. The expected FK error is caught.
DO $$
DECLARE
    existing_product_id INTEGER;
BEGIN
    SELECT product_id INTO existing_product_id
    FROM products ORDER BY product_id LIMIT 1;
    IF existing_product_id IS NULL THEN
        RAISE NOTICE 'Skipped foreign-key test: products table is empty.';
    ELSE
        BEGIN
            INSERT INTO product_categories (product_id, category_id)
            VALUES (existing_product_id, -2147483000);
            RAISE EXCEPTION 'Test failed: invalid category_id was accepted.';
        EXCEPTION WHEN foreign_key_violation THEN
            RAISE NOTICE 'PASS: invalid category_id rejected by FK.';
        END;
    END IF;
END;
$$;

-- Test that a negative price is rejected. The expected CHECK error is caught.
DO $$
DECLARE
    existing_product_id INTEGER;
BEGIN
    SELECT product_id INTO existing_product_id
    FROM products ORDER BY product_id LIMIT 1;
    IF existing_product_id IS NULL THEN
        RAISE NOTICE 'Skipped CHECK test: products table is empty.';
    ELSE
        BEGIN
            UPDATE products SET price = -5 WHERE product_id = existing_product_id;
            RAISE EXCEPTION 'Test failed: negative price was accepted.';
        EXCEPTION WHEN check_violation THEN
            RAISE NOTICE 'PASS: negative price rejected by CHECK.';
        END;
    END IF;
END;
$$;
