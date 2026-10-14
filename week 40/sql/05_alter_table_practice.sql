-- Week 40, Task 1.6: ALTER TABLE practice
-- Run once after the schema and sample data are in place.

ALTER TABLE customers
ADD COLUMN phone VARCHAR(20);

ALTER TABLE products
ADD COLUMN weight_grams INTEGER;

ALTER TABLE products
ADD CONSTRAINT products_weight_grams_positive
CHECK (weight_grams IS NULL OR weight_grams > 0);

ALTER TABLE products
RENAME COLUMN stock TO quantity_in_stock;

-- Verify the rename in pgAdmin or with \d products in psql.
-- The assignment asks to rename the column back because later exercises use 'stock'.
ALTER TABLE products
RENAME COLUMN quantity_in_stock TO stock;
