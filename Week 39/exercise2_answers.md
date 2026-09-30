
## 1. Database design phases

There are different steps in database design. They are requirements, conceptual design, logical design, physical design, implementation, testing, and maintenance. This week we learn about logical design and how to make tables, keys, and constraints.

## 2. One-to-many relationships

In a one-to-many relationship, we put the foreign key in the many side. For example, one customer can have many orders, so `customer_id` is in the Orders table.

## 3. Many-to-many relationships

For a many-to-many relationship, we use a junction table. For example, students and courses can be connected with a `student_courses` table.

## 4. One-to-one relationships

In a one-to-one relationship, we put the foreign key in the suitable table. We can use UNIQUE so that one record cannot connect to many records.

## 5. Weak entities

A weak entity depends on another table. It uses the owner's primary key as a foreign key. The key can also be part of its primary key.

## 6. Money and floating-point numbers

Floating-point numbers can give small mistakes when we use money. We use `NUMERIC` for money because it gives more accurate values.

## 7. TIMESTAMP and TIMESTAMPTZ

`TIMESTAMP` stores date and time. `TIMESTAMPTZ` also works with time zones. So, `TIMESTAMPTZ` is useful when people use the system in different countries.

## 8. CASCADE and RESTRICT

`CASCADE` deletes the related child rows when the parent row is deleted. `RESTRICT` does not allow us to delete the parent if child rows still exist.

## 9. Insertion anomaly

An insertion anomaly happens when we cannot add new information easily. For example, if products and categories are in one table, we may need to add a product just to add a new category.

## 10. Surrogate and natural keys

A surrogate key is a generated ID, like a number. A natural key is real information, like an email address or passport number.

## 11. Naming conventions

PostgreSQL normally uses lowercase names. We can use `snake_case`, like `customer_id`. This makes the database names simple and easy to read.

## 12. SET NULL

`SET NULL` keeps the child row but removes its connection to the parent row. The foreign-key column must allow NULL values.