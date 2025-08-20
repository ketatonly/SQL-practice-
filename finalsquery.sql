create table exam_student (
	stud_id bigint not null,
	s_name character varying(50) collate pg_catalog."default" not null,
	s_semester smallint,
	s_email character varying(60) collate pg_catalog."default",
	gender gender,
	school school,
	constraint exam_student_pkey primary key (stud_id)
)

create type gender as enum ('f', 'm', 'd')
create type school as enum ('CS', 'Math', 'Mgmt')


INSERT INTO public.exam_student (stud_id, s_name, s_semester, s_email, gender, school)
VALUES
    (1, 'Alice', 1, 'alice@example.com', 'f', 'CS'),
    (2, 'Bob', 2, 'bob@example.com', 'm', 'CS'),
    (3, 'Charlie', 1, 'charlie@example.com', 'm', 'Math'),
    (4, 'Diana', 3, 'diana@example.com', 'f', 'Mgmt'),
    (5, 'Eve', 2, 'eve@example.com', 'f', 'CS'),
    (6, 'Frank', 4, 'frank@example.com', 'm', 'Mgmt'),
    (7, 'Grace', 1, 'grace@example.com', 'f', 'Math'),
    (8, 'Hank', 3, 'hank@example.com', 'm', 'Math'),
    (9, 'Ivy', 2, 'ivy@example.com', 'f', 'CS'),
    (10, 'Jack', 1, 'jack@example.com', 'm', 'CS');


select * from exam_student

select school, gender, count(*) from exam_student group by school, gender

select school, count(*) from exam_student where gender = 'f' group by school
union
select school, count(*) from exam_student where gender = 'm' group by school


select school, count(*), count(*) *100 / (select count(*) from exam_student group by school) as percentage
from exam_student where gender = 'f' group by school
union
select school, count(*),  count(*) *100 / (select count(*) from exam_student group by school) as percentage 
from exam_student where gender = 'm' group by school

