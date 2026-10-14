

CREATE TABLE pet_categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE pet_products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(8,2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    category_id INTEGER NOT NULL REFERENCES pet_categories(category_id)
);

CREATE TABLE pet_customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

CREATE TABLE pet_sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES pet_customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES pet_products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(8,2) NOT NULL CHECK (unit_price > 0),
    sale_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

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

-- Q1: Products with category names, sorted by category and price.
SELECT pc.name AS category, pp.name AS product, pp.price
FROM pet_products pp
INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
ORDER BY pc.name, pp.price;

-- Q2: Total spending by each customer.
SELECT c.first_name || ' ' || c.last_name AS customer,
       SUM(s.quantity * s.unit_price) AS total_spent
FROM pet_customers c
INNER JOIN pet_sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Q3: Categories with products that have never been sold.
SELECT DISTINCT pc.name AS category
FROM pet_products pp
INNER JOIN pet_categories pc ON pp.category_id = pc.category_id
LEFT JOIN pet_sales s ON pp.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY pc.name;

-- Q4: Total revenue by category, including categories with no sales.
SELECT pc.name AS category,
       COALESCE(SUM(s.quantity * s.unit_price), 0) AS revenue
FROM pet_categories pc
LEFT JOIN pet_products pp ON pc.category_id = pp.category_id
LEFT JOIN pet_sales s ON pp.product_id = s.product_id
GROUP BY pc.category_id, pc.name
ORDER BY revenue DESC;

-- Q5: Most purchased product by total quantity.
SELECT pp.name AS product,
       SUM(s.quantity) AS total_sold
FROM pet_products pp
INNER JOIN pet_sales s ON pp.product_id = s.product_id
GROUP BY pp.product_id, pp.name
ORDER BY total_sold DESC
LIMIT 1;
