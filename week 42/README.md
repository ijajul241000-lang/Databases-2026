# Week 42 — Review and Exam 1 Preparation

This folder contains the completed Week 42 exercise sheet, the provided chapter notes, and PostgreSQL scripts for checking the TrailShop database and practicing the PetStore and BookClub cases.

## Files

- `Week42_Review_Completed.md` — completed answers in the assignment's original order and format.
- `assignment_instructions.md` — original Week 42 exercise sheet.
- `chapter_notes.md` — the chapter notes supplied with the task.
- `sql/01_trailshop_verification.sql` — schema/constraint review, row counts, six-table join, and safe constraint tests.
- `sql/02_petstore_setup_and_queries.sql` — PetStore schema, sample data, and five queries.
- `sql/03_bookclub_tasks_A_to_F.sql` — BookClub tables, sample data, update, and Tasks D–F queries.
- `sql/04_bookclub_task_G.sql` — `pages_read` column and triggers for the cross-table page-count rule.

## Suggested run order

1. Open the folder in VS Code and read the completed Markdown file.
2. In your existing Week 40 PostgreSQL `trailshop` database, run `sql/01_trailshop_verification.sql`.
3. Create a separate, empty database named `petstore` and run `sql/02_petstore_setup_and_queries.sql` once.
4. Create a separate, empty database named `bookclub` and run `sql/03_bookclub_tasks_A_to_F.sql` once.
5. In the same `bookclub` database, run `sql/04_bookclub_task_G.sql` after the first script.

For `psql`, connect using `\c trailshop`, `\c petstore`, or `\c bookclub` after creating each database. The `\d` commands are `psql` meta-commands and should be typed into `psql` rather than submitted as part of a normal SQL statement. In pgAdmin, inspect the tables and run the SQL statements in the Query Tool.

## Important notes

- Run the PetStore and BookClub setup scripts only once in a fresh database; they create tables and insert sample data.
- `01_trailshop_verification.sql` does not rebuild or delete TrailShop data.
- The constraint tests in the TrailShop verification script deliberately test invalid values inside exception-handling blocks. Expected failures are caught and reported as notices.
- A standard PostgreSQL `CHECK` constraint cannot query a separate table. The BookClub Task G script uses triggers to compare `reading_sessions.pages_read` with `books.page_count`.
- The SQL files were prepared from the supplied exercise sheet and chapter notes. Run them in your own PostgreSQL environment and verify the result before submitting to GitHub Classroom.
