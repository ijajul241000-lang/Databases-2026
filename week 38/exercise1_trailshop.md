# Exercise 1 – TrailShop ER Diagram

## ER Diagram

```mermaid
erDiagram
    CATEGORY ||--o{ PRODUCT_CATEGORY : "has"
    PRODUCT ||--o{ PRODUCT_CATEGORY : "belongs to"
    CUSTOMER ||--o{ ORDER : "places"
    ORDER ||--|{ ORDER_ITEM : "contains"
    PRODUCT ||--o{ ORDER_ITEM : "appears in"

    CATEGORY {
        int category_id PK
        string category_name
        string description
    }

    PRODUCT {
        int product_id PK
        string product_name
        string description
        decimal price
        int stock_quantity
    }

    PRODUCT_CATEGORY {
        int product_id PK, FK
        int category_id PK, FK
    }

    CUSTOMER {
        int customer_id PK
        string first_name
        string last_name
        string email
        string phone
    }

    ORDER {
        int order_id PK
        int customer_id FK
        date order_date
        string status
    }

    ORDER_ITEM {
        int order_id PK, FK
        int product_id PK, FK
        int quantity
        decimal unit_price
    }
```

### Design decision

In Week 37, `products.category_id` allowed one product to belong to only one category. This is not enough because one product can belong to more than one category. `ProductCategory` is used as a junction entity to resolve the Category–Product M:N relationship. `OrderItem` is also important because it stores the quantity and the price of a product in a specific order.

**Note:** `ProductCategory` is the junction entity. `OrderItem` is treated as a weak/dependent entity in this assignment.
