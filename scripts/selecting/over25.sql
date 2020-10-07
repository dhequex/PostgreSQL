SELECT * from students WHERE date_of_birth < NOW() - INTERVAL '25 years';

ALTER TABLE students
ADD CONSTRAINT unique_id UNIQUE (id);