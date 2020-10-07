SELECT min(date_of_birth),town_of_origin
FROM students
group by town_of_origin;