# Exercise 2 – Theory Review Questions

## 1. Why should you create a conceptual data model before writing SQL?

A conceptual model helps us understand the data and business rules before creating tables. It can also show mistakes in relationships early, so we do not have to change a lot of SQL later.

## 2. What is the difference between the conceptual level and the logical level?

The conceptual level shows the main entities, attributes, and relationships without database implementation details. The logical level changes this into a more detailed database structure with tables, columns, primary keys, and foreign keys.

## 3. Explain logical data independence with an example.

Logical data independence means we can change the logical database design without changing the users' views or application requirements. For example, we could split one table into two related tables while keeping the same user view.

## 4. Explain physical data independence with an example.

Physical data independence means we can change how data is stored without changing the logical database design. For example, we can add an index or change storage methods while the tables and relationships stay the same.

## 5. What is the difference between a strong entity and a weak entity?

A strong entity has its own primary key and can be identified by itself. For example, `Employee` can be a strong entity. A weak entity depends on another entity for its identification; for example, `Dependent` can depend on an `Employee`.

## 6. What is a composite attribute? How does it differ from a multivalued attribute?

A composite attribute can be divided into smaller parts. For example, `Address` can contain street, city, and postal code. A multivalued attribute can have several values, such as a customer having several phone numbers.

## 7. What is a derived attribute? Why is it usually not stored?

A derived attribute is calculated from other stored data. For example, age can be calculated from date of birth. It is usually not stored because the value can become outdated.

## 8. Explain the difference between a binary relationship and a unary relationship.

A binary relationship connects two different entities. For example, `Customer places Order`. A unary or recursive relationship connects an entity to itself, such as an `Employee supervises Employee`.

## 9. What is the difference between an identifying relationship and a non-identifying relationship?

In an identifying relationship, the parent's primary key becomes part of the child's primary key. In a non-identifying relationship, the foreign key is not part of the child's primary key.

## 10. What does a circle followed by a crow's foot mean?

A circle followed by a crow's foot means zero or many. The circle means optional and the crow's foot means many.

## 11. Why can't an M:N relationship be directly implemented in a relational database?

A relational table cannot normally store a direct many-to-many relationship in one foreign key. We solve it by creating a junction/associative table with foreign keys to both entities.

## 11b. Why is `products.category_id` insufficient?

`products.category_id` can store only one category for each product. If a product belongs to several categories, this design cannot represent it correctly. `ProductCategory` replaces it and resolves the M:N relationship.

## 12. Express the employee-department rule using min-max notation.

For Employee, the participation is **(1,1)** because every employee must belong to exactly one department. For Department, it is **(1,N)** because every department must have at least one employee and can have many employees.
