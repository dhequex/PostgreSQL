SELECT first_name, date_of_birth, town_of_origin, gender, GROUPING(first_name,gender), from students 

GROUP BY
gender;