SELECT students.first_name, students_last_name, students_to_projects/project_id
FROM students
INNER JOIN students_to_projects
ON students.id = students_to_projects.student_id
WHERE students_to_projects.project_id =5;