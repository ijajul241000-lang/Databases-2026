# Week 39 - Exercise 4: PostgreSQL Data Types

| # | Requirement | Data type | Reason |
|---|---|---|---|
| 1 | Product price | `NUMERIC(8,2)` | Exact decimal value for money. |
| 2 | Number of employees | `INTEGER` | Whole-number count. |
| 3 | Is active | `BOOLEAN` | True/false value. |
| 4 | Birth date | `DATE` | Date without a time. |
| 5 | Long description | `TEXT` | Variable-length text. |
| 6 | Country code | `CHAR(2)` | Fixed two-character code. |
| 7 | IP address | `INET` | PostgreSQL network-address type. |
| 8 | Account balance | `NUMERIC(9,2)` | Exact monetary value. |
| 9 | Scientific measurement | `DOUBLE PRECISION` | Suitable for approximate floating-point values. |
| 10 | Globally unique identifier | `UUID` | Designed for unique identifiers. |
| 11 | Age | `INTEGER` | Whole-number value. |
| 12 | Event date and time | `TIMESTAMPTZ` | Stores a time point with time-zone handling. |
| 13 | Phone number | `VARCHAR(20)` | Phone numbers are text, not numbers for calculation. |
| 14 | Percentage | `NUMERIC(5,2)` | Exact decimal percentage. |
| 15 | List of tags | `TEXT[]` | PostgreSQL array of text values. |
