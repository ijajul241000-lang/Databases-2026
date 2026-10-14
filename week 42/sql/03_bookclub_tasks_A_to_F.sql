
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    isbn CHAR(13) NOT NULL UNIQUE,
    genre VARCHAR(100) NOT NULL,
    page_count INTEGER NOT NULL CHECK (page_count > 0)
);

CREATE TABLE reading_sessions (
    reading_session_id SERIAL PRIMARY KEY,
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- Task B: Insert 3 members, 4 books, and 5 reading sessions
INSERT INTO members (first_name, last_name, email, join_date) VALUES
    ('Aino', 'Virtanen', 'aino.v@example.com', CURRENT_DATE - 100),
    ('Markus', 'Laine', 'markus.l@example.com', CURRENT_DATE - 80),
    ('Sara', 'Niemi', 'sara.n@example.com', CURRENT_DATE - 60);

INSERT INTO books (title, author, isbn, genre, page_count) VALUES
    ('Database Basics', 'Mika Example', '9780000000001', 'Education', 240),
    ('The Forest Path', 'Laura Example', '9780000000002', 'Fiction', 310),
    ('SQL Made Clear', 'Pekka Example', '9780000000003', 'Education', 180),
    ('Northern Stories', 'Anna Example', '9780000000004', 'Fiction', 220);

INSERT INTO reading_sessions (member_id, book_id, start_date, end_date, rating) VALUES
    (1, 1, CURRENT_DATE - 12, CURRENT_DATE - 5, 5),
    (1, 2, CURRENT_DATE - 4, NULL, NULL),
    (2, 2, CURRENT_DATE - 10, CURRENT_DATE - 3, 3),
    (2, 3, CURRENT_DATE - 2, NULL, NULL),
    (3, 4, CURRENT_DATE - 8, CURRENT_DATE - 1, 2);

-- Task C: Finish member 1's reading of book 2 and give it a rating of 4
UPDATE reading_sessions
SET end_date = CURRENT_DATE,
    rating = 4
WHERE member_id = 1
  AND book_id = 2
  AND end_date IS NULL;

-- Task D1: Books member 1 has completed reading
SELECT b.title, rs.rating
FROM reading_sessions rs
INNER JOIN books b ON b.book_id = rs.book_id
WHERE rs.member_id = 1
  AND rs.end_date IS NOT NULL
ORDER BY b.title;

-- Task D2: Average rating per book, considering completed readings only
SELECT b.title,
       ROUND(AVG(rs.rating)::numeric, 2) AS average_rating
FROM books b
INNER JOIN reading_sessions rs ON rs.book_id = b.book_id
WHERE rs.end_date IS NOT NULL
GROUP BY b.book_id, b.title
ORDER BY b.title;

-- Task D3: Members who have never rated a book below 3
SELECT m.member_id,
       m.first_name,
       m.last_name
FROM members m
WHERE NOT EXISTS (
    SELECT 1
    FROM reading_sessions rs
    WHERE rs.member_id = m.member_id
      AND rs.rating < 3
)
ORDER BY m.member_id;

-- Task E: Reading counts and average rating for every member
SELECT m.member_id,
       m.first_name || ' ' || m.last_name AS member_name,
       COUNT(DISTINCT CASE WHEN rs.end_date IS NOT NULL THEN rs.book_id END) AS books_read,
       COUNT(DISTINCT CASE WHEN rs.end_date IS NULL THEN rs.book_id END) AS books_currently_reading,
       ROUND(AVG(rs.rating)::numeric, 2) AS average_rating
FROM members m
LEFT JOIN reading_sessions rs ON rs.member_id = m.member_id
GROUP BY m.member_id, m.first_name, m.last_name
ORDER BY m.member_id;

-- Task F: Books with no reading session recorded
SELECT b.book_id, b.title
FROM books b
WHERE NOT EXISTS (
    SELECT 1
    FROM reading_sessions rs
    WHERE rs.book_id = b.book_id
)
ORDER BY b.book_id;
