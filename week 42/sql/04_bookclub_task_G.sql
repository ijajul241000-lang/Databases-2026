
ALTER TABLE reading_sessions
ADD COLUMN pages_read INTEGER NOT NULL DEFAULT 0
CHECK (pages_read >= 0);

-- A CHECK constraint cannot compare pages_read with books.page_count,
-- because PostgreSQL CHECK constraints cannot query another table.
-- Use a trigger for the cross-table rule instead.
CREATE OR REPLACE FUNCTION validate_pages_read_against_book()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    total_pages INTEGER;
BEGIN
    SELECT page_count
    INTO total_pages
    FROM books
    WHERE book_id = NEW.book_id;

    IF NEW.pages_read > total_pages THEN
        RAISE EXCEPTION 'pages_read (%) cannot exceed page_count (%) for book %',
            NEW.pages_read, total_pages, NEW.book_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_pages_read
BEFORE INSERT OR UPDATE OF pages_read, book_id
ON reading_sessions
FOR EACH ROW
EXECUTE FUNCTION validate_pages_read_against_book();

-- Also prevent lowering a book's page_count below existing reading progress.
CREATE OR REPLACE FUNCTION validate_updated_book_page_count()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM reading_sessions rs
        WHERE rs.book_id = NEW.book_id
          AND rs.pages_read > NEW.page_count
    ) THEN
        RAISE EXCEPTION 'page_count cannot be lower than pages already read for book %',
            NEW.book_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_book_page_count
BEFORE UPDATE OF page_count
ON books
FOR EACH ROW
EXECUTE FUNCTION validate_updated_book_page_count();
