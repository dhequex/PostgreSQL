
SELECT students.id,students.first_name,checkins.checked_in_at
FROM STUDENTS
INNER JOIN checkins 
ON students.id = checkins.id
WHERE checked_in_at  between '2016-06-01 00:00:00' and '2016-06-30 24:00:00';
