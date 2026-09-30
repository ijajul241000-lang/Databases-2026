# Exercise 4 – FitZone ER Diagram Creation

## 1. Entities and attributes

### Member
- `member_id` (PK)
- `first_name`
- `last_name`
- `email`
- `phone`
- `date_of_birth`
- `membership_start_date`
- `plan_id` (FK)

### MembershipPlan
- `plan_id` (PK)
- `name`
- `monthly_price`
- `description`

### Trainer
- `trainer_id` (PK)
- `first_name`
- `last_name`
- `specialization`
- `hire_date`

### Class
- `class_id` (PK)
- `name`
- `day_of_week`
- `start_time`
- `end_time`
- `max_capacity`
- `trainer_id` (FK)

### Registration
- `member_id` (PK, FK)
- `class_id` (PK, FK)
- `registration_date`

### Equipment
- `equipment_id` (PK)
- `name`
- `type`
- `purchase_date`
- `status`

### MaintenanceRequest
- `request_id` (PK)
- `equipment_id` (FK)
- `request_date`
- `problem_description`
- `status`
- `resolution_date`

## 2. Relationships and cardinality

- One `MembershipPlan` can have many `Member` records. Each `Member` has exactly one `MembershipPlan`.
- One `Trainer` can lead many `Class` records. Each `Class` has exactly one `Trainer`.
- `Member` and `Class` have an M:N relationship. `Registration` resolves this relationship.
- One `Equipment` can have many `MaintenanceRequest` records. Each `MaintenanceRequest` belongs to exactly one `Equipment`.
- A member can register for zero or many classes.
- A class can have zero or many members.

## 3. ER Diagram

```mermaid
erDiagram
    MEMBERSHIP_PLAN ||--o{ MEMBER : "has"
    TRAINER ||--o{ CLASS : "leads"
    MEMBER ||--o{ REGISTRATION : "makes"
    CLASS ||--o{ REGISTRATION : "has"
    EQUIPMENT ||--o{ MAINTENANCE_REQUEST : "has"

    MEMBERSHIP_PLAN {
        int plan_id PK
        string name
        decimal monthly_price
        string description
    }

    MEMBER {
        int member_id PK
        string first_name
        string last_name
        string email
        string phone
        date date_of_birth
        date membership_start_date
        int plan_id FK
    }

    TRAINER {
        int trainer_id PK
        string first_name
        string last_name
        string specialization
        date hire_date
    }

    CLASS {
        int class_id PK
        string name
        string day_of_week
        time start_time
        time end_time
        int max_capacity
        int trainer_id FK
    }

    REGISTRATION {
        int member_id PK, FK
        int class_id PK, FK
        date registration_date
    }

    EQUIPMENT {
        int equipment_id PK
        string name
        string type
        date purchase_date
        string status
    }

    MAINTENANCE_REQUEST {
        int request_id PK
        int equipment_id FK
        date request_date
        string problem_description
        string status
        date resolution_date
    }
```

## 4. Weak or junction entities

`Registration` is a junction/associative entity because it resolves the M:N relationship between Member and Class. Its primary key is made from `member_id` and `class_id`.

`MaintenanceRequest` is dependent on Equipment because every maintenance request must be connected to one piece of equipment. It can therefore be considered a dependent entity in this model.

## 5. M:N relationships

Yes. `Member` and `Class` have an M:N relationship because one member can register for many classes and one class can have many members. The `Registration` junction entity resolves this relationship.
