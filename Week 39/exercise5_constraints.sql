-- Week 39 - Exercise 5: Constraints

-- Part A: Basic constraints

-- 1. Weight must be positive
weight_kg NUMERIC(6,2) CHECK (weight_kg > 0);

-- 2. Email is required
email VARCHAR(254) NOT NULL;

-- 3. Name is required and unique
name VARCHAR(100) NOT NULL UNIQUE;

-- 4. Hire date defaults to today's date
hire_date DATE DEFAULT CURRENT_DATE;

-- 5. Status has a fixed set of allowed values
status VARCHAR(20) NOT NULL
    CHECK (
        status IN (
            'new',
            'confirmed',
            'shipped',
            'delivered',
            'returned'
        )
    );

-- Part B: Multi-column and range constraints

-- 6. Arrival must be after departure
CHECK (arrival_time > departure_time);

-- 7. A student cannot be enrolled in the same course twice
UNIQUE (student_id, course_id);

-- 8. Discount must be between 0 and 100 percent
CHECK (discount_percentage BETWEEN 0 AND 100);

-- Part C: Foreign-key constraints

-- 9. Department can be deleted; employee remains with NULL department
department_id INTEGER
    REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- 10. Customer must remain if orders reference the customer
customer_id INTEGER NOT NULL
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- 11. Child rows are deleted with the author
author_id INTEGER NOT NULL
    REFERENCES authors(author_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- 12. Child rows are deleted with the course
course_id INTEGER NOT NULL
    REFERENCES courses(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
