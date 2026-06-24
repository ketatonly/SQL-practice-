-- week 7

select * from course order by prof_i_d

-- How many professors teach only 1 course?
select count(*), prof_i_d from course group by prof_i_d having count(*) = 1

select name, prof_i_d from professor where prof_i_d in 
(select prof_i_d from course group by prof_i_d having count(*) = 1)
-- returns name of those professors

-- How many contact hours does each professor teach?
select sum(contact_hours), prof_i_d from course group by prof_i_d order by sum(contact_hours)

-- It is possible to group by more than one column.
SELECT prof_i_d, contact_hours, count(contact_hours) as "Number"
FROM course
group by prof_i_d, contact_hours
order by prof_i_d;
-- grouping within grouping
-- For each professor return the number of courses that have the same (number of) contact hours:

select * from course order by prof_i_d

select sum(contact_hours) as "teching load", prof_i_d from course group by prof_i_d

select * from course 

select sum(contact_hours), prof_i_d from course group by prof_i_d having sum(contact_hours) > 2 

select * from course order by prof_i_d

select stud_i_d from enrollment group by stud_i_d

select distinct stud_i_d from enrollment 

select count(contact_hours), prof_i_d from course where contact_hours = 4 group by prof_i_d having count(contact_hours) > 1  


select count(contact_hours), prof_i_d, contact_hours from course where contact_hours = 4 group by prof_i_d, contact_hours having count(contact_hours) > 1  


-- assignment 5


SELECT s.stud_i_d, s.name, count(*) as "Number of courses"
FROM enrollment e
INNER JOIN student s ON e.stud_i_d = s.stud_i_d
GROUP BY s.stud_i_d

select p.name from course c inner join professor p on p.prof_i_d = c.prof_i_d where c.title = 'Ethics'

-- Return an enrollment list with stud.ID and student name, courseID and course title. Sort by student name ascending.
select s.stud_i_d, s.name, e.course_i_d, c.title from enrollment e inner join student s
on s.stud_i_d = e.stud_i_d  inner join course c on c.course_i_d = e.course_i_d
order by s.name

-- Return for each student that is enrolled in at least one course the number of contact 
-- hours he takes. Return student id and student name and number of contact hours.
select s.name, sum(c.contact_hours) from enrollment e inner join student s on s.stud_i_d = e.stud_i_d
inner join course c on c.course_i_d = e.course_i_d group by s.name

-- Restrict the output of query (3) to those students that take less than 8 contact hours
select s.name, sum(c.contact_hours) from enrollment e inner join student s on s.stud_i_d = e.stud_i_d
inner join course c on c.course_i_d = e.course_i_d group by s.name having sum(c.contact_hours) < 8

-- Which students are together in the course 5001? Show the student names .
select s.name, e.course_i_d from student s inner join enrollment e on e.stud_i_d = s.stud_i_d where course_i_d = 5001







--Assignment 6


select p.prof_i_d, p.name, count(c.course_i_d) from professor p left join course c on c.prof_i_d = p.prof_i_d
group by p.prof_i_d having count(c.course_i_d) between 0 and 3

select course_i_d, title from course c inner join requirement r on r.predecessor = c.course_i_d where r.successor = 5049

select s.name from student s inner join enrollment e on s.stud_i_d = e.stud_i_d where e.course_i_d = 5001


--TTF
select p.prof_i_d, p.name, count(c.course_i_d) as course_number
from professor p left join course c
on c.prof_i_d = p.prof_i_d
group by p.prof_i_d


select s.name 
from student s inner join enrollment e on s.stud_i_d = e.stud_i_d 
where e.course_i_d = 5001




-- assignment 7

-- Which professors do not teach? 
-- with join:
select p.name from professor p left join course c on p.prof_i_d = c.prof_i_d where course_i_d is null

-- with uncorrelated subquery:
select prof_i_d, name from professor where prof_i_d not in (
select prof_i_d from course 
)

-- with correlated subquery:
select p.prof_i_d, p.name from professor p where not exists (
select 1 from course c where c.prof_i_d = p.prof_i_d
)


-- Display the teaching load (that is the contact hours) that each professor has. 
-- Also display each professor’s percentage of the total teaching load (total contact hours).

select prof_i_d, sum(contact_hours) from course group by prof_i_d

-- with subquery:
select p.prof_i_d, name, sum(contact_hours), 
sum(contact_hours) *100 / (select sum(contact_hours) from course)::decimal as percentage 
from professor p left join course c on p.prof_i_d = c.prof_i_d group by p.prof_i_d 

-- with window function:
select p.prof_i_d, name, sum(contact_hours), 
sum(contact_hours) *100 / sum(sum(contact_hours)) over()::decimal as percentage 
from professor p left join course c on p.prof_i_d = c.prof_i_d group by p.prof_i_d 


-- Which students scored less than average points in course 5001 (Foundation)? Display
-- studentID, student name, semester, grade, average points and individual points

-- with subquery:
select s.stud_i_d, name, semester, points, (select avg(points) from examination where course_i_d = 5001) as average
from examination e inner join student s on e.stud_i_d = s.stud_i_d 
where course_i_d = 5001 and points < (select avg(points) from examination where course_i_d = 5001)


--with CTE:
with averagepoints as (
select s.stud_i_d, name, semester, points, course_i_d, (select avg(points) from examination where course_i_d = 5001) 
as average
from examination e inner join student s on e.stud_i_d = s.stud_i_d 
)
select stud_i_d, name, semester, points, average from averagepoints 
where course_i_d = 5001 and points < average 

-- Which students are enrolled in all 4-contact hour courses?
select distinct s.stud_i_d, s.name, c.contact_hours from student s 
inner join enrollment e on s.stud_i_d = e.stud_i_d
inner join course c on c.course_i_d = e.course_i_d
where c.contact_hours = 4


-- with CTE:
with students as (
select distinct s.stud_i_d, s.name, c.contact_hours from student s 
inner join enrollment e on s.stud_i_d = e.stud_i_d
inner join course c on c.course_i_d = e.course_i_d
)
select stud_i_d, name, contact_hours from students where contact_hours = 4




select 





-- week 9

select * from course c inner join examination e on e.prof_i_d = c.prof_i_d;
-- here we join on FK = FK
select * from course c inner join examination using (prof_i_d) 


select * from professor natural join course;
-- excludes duplicate columns


SELECT * FROM examination NATURAL JOIN course
-- in this two tables prof_i_d and course_i_d both match 
select * from examination
select * from course
-- sometimes when new columns are added with the same name but different meaning, natural join might produce
-- unwanted output

-- when it's difficult to read natural join we can write it with using-clause:
SELECT * FROM examination INNER JOIN course USING (course_i_d);
SELECT * FROM examination INNER JOIN course USING (course_i_d,prof_i_d);
-- these queries are easier to read and debug


-- week 11

SELECT * FROM examination NATURAL JOIN course
-- rewrite with inner join
SELECT * FROM examination inner JOIN course 
on course.course_i_d = examination.course_i_d and course.prof_i_d = examination.prof_i_d

-- a list with the names of the professors that teach.
select distinct p.prof_i_d, p.name from course c inner join professor p on c.prof_i_d = p.prof_i_d

-- a list of the names of professors that do not teach at all.
select p.prof_i_d, p.name from course c right join professor p on c.prof_i_d = p.prof_i_d where c.prof_i_d is null


-- union:
select assistant_i_d as "faculty members", name from assistant
union
select prof_i_d, name from professor 


-- week 13 CE


-- Are there students that took an exam but did not take a course at all?
select * from examination ex left join enrollment en on en.stud_i_d = ex.stud_i_d where en.course_i_d is null


"Student Carnap looks for an assistant that supervises his B.A. thesis.
Display all assistants that work for professors that teach at least one course
Carnap is enrolled in. Display assistants with ID and name and professorID and
professor name the assistant works for." :
select distinct a.assistant_i_d, a.name, a.prof_i_d, p.name from enrollment e 
inner join course c on e.course_i_d = c.course_i_d 
inner join professor p on c.prof_i_d = p.prof_i_d 
inner join assistant a on a.prof_i_d = p.prof_i_d
where e.stud_i_d = (select stud_i_d from student where student.name = 'Carnap')

-- eva's version:
select a.assistant_i_d, a.name, a.prof_i_d, p.name from assistant a 
inner join professor p on a.prof_i_d = p.prof_i_d
where a.prof_i_d in
(
select c.prof_i_d from course c inner join enrollment e 
on c.course_i_d = e.course_i_d
where e.stud_i_d = (select stud_i_d from student where student.name = 'Carnap')
)


"Which course(s) can only be taken in 4th semester - because of 3 required
predecessor courses? :"
with recursive course_chain as (
	select array[predecessor] as chain, successor as course from requirement
	union all
	select c.chain || r.predecessor as chain, r.successor as course from course_chain c inner join requirement r
	on c.course = r.predecessor
)
select course, chain from course_chain where array_length(chain, 1) = 3



-- assignment 8

CREATE TABLE log_exam (
    log_id SERIAL PRIMARY KEY,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_name TEXT DEFAULT CURRENT_USER,
    old_stud_id BIGINT,
    old_course_id BIGINT,
    old_prof_id BIGINT,
    old_grade CHARACTER VARYING,
    old_points SMALLINT,
    new_stud_id BIGINT,
    new_course_id BIGINT,
    new_prof_id BIGINT,
    new_grade CHARACTER VARYING,
    new_points SMALLINT
);

CREATE OR REPLACE FUNCTION log_examination_update() 
RETURNS TRIGGER AS $$
BEGIN
    -- Insert a log entry with old and new values
    INSERT INTO log_exam (
        old_stud_id, old_course_id, old_prof_id, old_grade, old_points,
        new_stud_id, new_course_id, new_prof_id, new_grade, new_points
    ) VALUES (
        OLD.stud_i_d, OLD.course_i_d, OLD.prof_i_d, OLD.grade, OLD.points,
        NEW.stud_i_d, NEW.course_i_d, NEW.prof_i_d, NEW.grade, NEW.points
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER track_examination_update
AFTER UPDATE ON examination
FOR EACH ROW
EXECUTE FUNCTION log_examination_update();

UPDATE examination
SET grade = 'A', points = 90
WHERE stud_i_d = 25403 AND course_i_d = 5001;


SELECT * FROM log_exam;

UPDATE examination
SET grade = 'B', points = 85
WHERE stud_i_d = 27550 AND course_i_d = 5001;

SELECT * FROM log_exam;




-- slides solution:

create table logexam (
	id serial not null primary key,
	timestamp timestamp not null default current_timestamp,
	"current_user" character varying(50) not null default current_user,
	all_old_values character varying(255) not null,
	all_new_values character varying(255) not null
);


create or replace function log_update()
returns trigger
language 'plpgsql'
as $$
begin 
	insert into logexam(all_old_values, all_new_values)
	values (row(old.*), row(new.*));
return new;
end;
$$;

create or replace trigger after_update
after update
on examination
for each row
execute function log_update()

select * from examination where stud_i_d = 25403 and course_i_d = 5001
update examination set points = 86 where stud_i_d = 25403 and course_i_d = 5001


select * from logexam





-- week 14


create or replace view view_enroll AS (
select c.course_i_d, c.title, p.name AS professor,s.name, s.stud_i_d,
s.semester
from course c
inner join enrollment e on c.course_i_d = e.course_i_d
inner join student s on s.stud_i_d=e.stud_i_d
inner join professor p on c.prof_i_d = p.prof_i_d
order by c.course_i_d
)
-- views are just saved queries
-- if a  query is often called we can save it as a view

select * from view_enroll where course_i_d = 5001
-- we can query the views 


-- only the query is saved, not the table itself. we can check this by adding new data:
insert into enrollment values 
	(25403, 5001)
	
select * from view_enroll where course_i_d = 5001



create materialized view mview_enroll AS (
select c.course_i_d, c.title, p.name AS professor,s.name, s.stud_i_d,
s.semester
from course c
inner join enrollment e on c.course_i_d = e.course_i_d
inner join student s on s.stud_i_d=e.stud_i_d
inner join professor p on c.prof_i_d = p.prof_i_d
order by c.course_i_d
)
-- materilized view stores the table itself and not the query
-- you can check it the same way
-- materialized views execute typically faster than normal views 
-- they are stored on disk
-- they are used for long-running, complex queries where you do not need current data
-- queries need to be able to tolerate obsolete data


-- materialized views are not refreshed automatically but you can do it manually:
REFRESH MATERIALIZED VIEW view_enroll;

select * from mview_enroll where course_i_d = 5001


SELECT *
FROM pg_matviews
where schemaname = 'public';


SELECT * FROM pg_matviews where matviewname = 'mview_enroll';

