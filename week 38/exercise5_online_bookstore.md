# Exercise 5 – Find and Correct the Errors

The Online Bookstore design has four main problems.

## Error 1 – Multivalued `genres` attribute

### a) Error
The `genres` field stores several genres in one comma-separated string, such as `"Fiction, Mystery, Thriller"`.

### b) Why is it a problem?
A single field should normally contain one value. Storing many values together makes searching, updating, and maintaining the data harder.

### c) Correction
Create a separate `Genre` entity and a junction entity such as `BookGenre`.

Example:

```text
BOOK
- book_id (PK)
- title
- author_name
- price

GENRE
- genre_id (PK)
- genre_name

BOOK_GENRE
- book_id (PK, FK)
- genre_id (PK, FK)
```

## Error 2 – Direct M:N relationship between Books and Customer

### a) Error
Books and Customer have an M:N relationship directly without a junction table.

### b) Why is it a problem?
A relational database needs a junction table to correctly represent an M:N relationship.

### c) Correction
Create a junction entity such as `CustomerBook` or, better, connect both entities through the purchase/order structure.

## Error 3 – No relationship between Books and Purchase

### a) Error
There is no relationship showing which books are included in a purchase.

### b) Why is it a problem?
Without this relationship, the database cannot tell which books a customer bought.

### c) Correction
Create a `PurchaseItem` entity.

```text
PURCHASE_ITEM
- purchase_id (PK, FK)
- book_id (PK, FK)
- quantity
- unit_price
```

This creates the needed relationship between Purchase and Book.

## Error 4 – Entity naming

### a) Error
The entity is named `Books`, while the other entities are singular: `Customer` and `Purchase`.

### b) Why is it a problem?
Using different naming styles can make the database harder to understand and maintain. The theory recommends consistent entity naming.

### c) Correction
Rename `Books` to `Book`.

## Corrected basic structure

```text
Book
    |
    | 1:N
    |
PurchaseItem
    |
    | N:1
    |
Purchase
    |
    | N:1
    |
Customer

Book
    |
    | M:N
    |
BookGenre
    |
    | N:1
    |
Genre
```
