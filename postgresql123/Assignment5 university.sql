select student.stud_i_d, student.name, count(*) as "Number of courses"
from enrollment e inner join student s on e.stud_i_d = s.stud_i_d
group by s.stud_i_d;

--The query is designed to return each student's ID, name, and the number 
--of courses they are enrolled in by counting the rows in the enrollment 
--table for each student. It joins the enrollment table with the student table 
--using the stud_id field and groups the result by the student's ID.

--The query throws an error because the name field is not included in the GROUP BY clause, 
--which violates SQL rules. To fix this, s.name should be added to the GROUP BY clause, 
--like so: group by s.stud_id, s.name.

select p.name from course c 
	inner join professor p on c.prof_i_d = p.prof_i_d 
	where c.title = 'ethics';

select s.stud_i_d, s.name as student_name, c.course_i_d, c.title as course_title
	from enrollment e
	inner join student s on e.stud_i_d = s.stud_i_d
	inner join course c on e.course_i_d = c.course_i_d
	order by s.name asc

select s.stud_i_d, s.name as student_name, sum(c.contact_hours) as total_contact_hours
	from enrollment e
	inner join student s on e.stud_i_d = s.stud_i_d
	inner join course c on e.course_i_d = c.course_i_d
	group by s.stud_i_d, s.name

select s.stud_i_d, s.name as student_name, sum(c.contact_hours) as total_contact_hours
	from enrollment e
	inner join student s on e.stud_i_d = s.stud_i_d
	inner join course c on e.course_i_d = c.course_i_d
	group by s.stud_i_d, s.name
	having sum(c.contact_hours) < 8

select s.name as student_name
	from enrollment e
	inner join student s on e.stud_i_d = s.stud_i_d
	where e.course_i_d = 5001


	




