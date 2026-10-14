# Week 41 — SQL Querying Assignment

This folder contains the Week 41 assignment, a completed Markdown copy, the chapter notes supplied with the task, and SQL scripts for testing against the Week 40 `trailshop` database.

## Files

- `Week41_SQL_Querying_Completed.md` — assignment prompts with answers inserted in the answer fields.
- `assignment_instructions.md` — original exercise sheet, preserved unchanged.
- `chapter_notes.md` — reference chapter notes provided with the task.
- `sql/01_business_questions.sql` — Exercise 1: 15 TrailShop business queries.
- `sql/02_optional_query_exercises.sql` — Exercise 3: 15 optional practice queries.
- `sql/03_query_reading_answers.md` — plain-English explanations for Exercise 4.
- `setup_if_needed/` — selected Week 40 setup SQL, only needed if you do not already have the `trailshop` database.

## Run in PostgreSQL

The Week 41 queries use the TrailShop tables created in Week 40. If your database already exists and contains the sample data, open `sql/01_business_questions.sql` and `sql/02_optional_query_exercises.sql` in pgAdmin's Query Tool, or run:

```bash
psql -d trailshop -f sql/01_business_questions.sql
psql -d trailshop -f sql/02_optional_query_exercises.sql
```

The Week 41 query scripts are SELECT statements and do not modify your data.

If you need to create the database from scratch, first run `setup_if_needed/00_create_database.sql` while connected to the default `postgres` database, then run `01_create_tables.sql` and `02_insert_sample_data.sql` in the new `trailshop` database, in that order. Do not rerun the setup scripts against a database that already contains the sample data, because duplicate inserts can cause unique-constraint errors.

## Before submission

1. Open the folder in VS Code.
2. Test the required business queries against your local PostgreSQL database.
3. Review the query results and make sure you understand each query.
4. Submit the files required by your course/GitHub Classroom instructions.

The scripts were prepared from the provided assignment and chapter notes, but were not run against your local PostgreSQL server. Please test them before submitting.
