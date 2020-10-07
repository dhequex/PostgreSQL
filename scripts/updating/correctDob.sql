UPDATE students 
SET date_of_birth = date_of_birth - INTERVAL '100 YEARS'
WHERE date_of_birth < NOW() - INTERVAL '100 YEARS';