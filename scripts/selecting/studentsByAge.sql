SELECT first_name, last_name, date_of_birth from students 
ORDER BY
date_of_birth DESC;


CREATE TABLE students (
    id SERIAL PRIMARY KEY UNIQUE,
    first_name TEXT,
    last_name TEXT,
    date_of_birth date,
    gender TEXT,
    town_of_origin TEXT
);