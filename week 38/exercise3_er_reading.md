# Exercise 3 – ER Diagram Reading Exercise

## Diagram A – Library System

### a) Can an author exist without having written any books?

No. The `||` on the Author side means the author must have the required relationship. The diagram shows that an author is connected to one or more books.

### b) Can a book exist without being loaned?

Yes. The circle on the Loan side means a book can have zero loans. A book can therefore exist in the library without currently being loaned.

### c) What type of entity is Loan?

`Loan` is an associative entity between `Book` and `Member`. It connects the two entities and can store information about the loan, such as the loan date and due date.

### d) What is the cardinality of Author–Book? Is it realistic?

The diagram shows a **1:N** relationship from Author to Book. This may not always be realistic because a book can have more than one author. A more accurate design could use an M:N relationship with an associative entity such as `BookAuthor`.

### e) What attributes would you add to Loan?

I would add:

- `loan_id` (PK)
- `loan_date`
- `due_date`
- `return_date`
- `book_id` (FK)
- `member_id` (FK)

---

## Diagram B – School System

### a) Can a student exist without being enrolled in any course?

Yes. The circle on the Enrollment side means a student can have zero enrollments. Therefore, a student can exist without currently taking a course.

### b) Can a course exist without having any enrolled students?

Yes. The diagram allows a course to exist even when there are no students enrolled in it.

### c) What is the cardinality between Student and Course?

Student and Course have an **M:N** relationship through the `Enrollment` entity. One student can take many courses, and one course can have many students.

### d) Can a teacher exist without teaching any courses?

Yes. The relationship allows a teacher to have zero courses, so a teacher can exist without currently teaching a course.

### e) Is Teacher–Course 1:1 or 1:N?

It is **1:N**. One teacher can teach many courses/sections, while each course/section has one teacher. This means the diagram does not support team teaching where one course has several teachers.
