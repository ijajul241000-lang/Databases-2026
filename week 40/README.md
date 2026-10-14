# Week 40 — SQL Fundamentals (TrailShop)

This folder contains the completed Week 40 SQL Fundamentals assignment and PostgreSQL scripts for the required TrailShop database.

## Folder contents

- `assignment_instructions.md` — the original Week 40 assignment brief for reference.
- `assignment_answers.md` — completed answers for Exercises 1–4, including the theory questions, optional SQL-writing tasks, and error diagnosis.
- `sql/00_create_database.sql` — creates the `trailshop` database. Run this while connected to a different database such as `postgres`.
- `sql/01_create_tables.sql` — creates the six required TrailShop tables.
- `sql/02_insert_sample_data.sql` — inserts sample categories, customers, products, product-category links, orders, and order items.
- `sql/03_update_practice.sql` — the UPDATE practice tasks.
- `sql/04_delete_practice.sql` — safe DELETE practice examples. The transactions are rolled back so the sample data is preserved. The deliberately failing product-delete statement is commented out.
- `sql/05_alter_table_practice.sql` — the ALTER TABLE tasks and the rename back to `stock`.
- `sql/06_optional_exercises.sql` — optional exercise answers kept as examples; read the comments and run only the section you need.
- `sql/07_verify_data.sql` — queries to check the tables and sample rows.

## How to run in PostgreSQL

Use a fresh PostgreSQL database for this assignment. If you already have a `trailshop` database with data, back it up or use another database name before starting.

### Option A: VS Code terminal / psql

From the project folder, run these commands, adjusting the PostgreSQL username if needed:

```bash
psql -U postgres -d postgres -f sql/00_create_database.sql
psql -U postgres -d trailshop -f sql/01_create_tables.sql
psql -U postgres -d trailshop -f sql/02_insert_sample_data.sql
psql -U postgres -d trailshop -f sql/07_verify_data.sql
```

Then connect to the database and check tables:

```bash
psql -U postgres -d trailshop
```

Inside `psql`, run:

```text
\dt
```

Run `sql/03_update_practice.sql` and `sql/05_alter_table_practice.sql` only when you are ready to do the practice tasks. `sql/04_delete_practice.sql` demonstrates deletes and rolls them back.

### Option B: pgAdmin

1. Open pgAdmin and connect to your PostgreSQL server.
2. Select the existing `postgres` database, open Query Tool, and execute `sql/00_create_database.sql`.
3. Refresh the Databases list and connect to `trailshop`.
4. Open Query Tool for `trailshop` and execute `sql/01_create_tables.sql` followed by `sql/02_insert_sample_data.sql`.
5. Execute `sql/07_verify_data.sql` to inspect the results.

## Important notes

- Run the database creation, schema, and seed scripts in the order shown above.
- The schema uses `SERIAL` primary keys because the assignment asks for them.
- The sample seed script is intended for a fresh empty database and should not be run twice.
- Some UPDATE, DELETE, and ALTER TABLE exercises change the database. Read each script's comments before running it.
- `assignment_answers.md` is the completed written submission. Read it through and make sure you understand the SQL and theory answers before submitting.
