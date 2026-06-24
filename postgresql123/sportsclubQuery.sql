
select * from course order by memname

select memname, targetgroup, count(targetgroup) from course group by targetgroup, memname

select * from course



-- week 7


select memname from trainer where license = true

select *
from member
where postalcode between 4000 and 4999;

-- Return the distinct postalcodes of our members. 
select distinct to_char(postalcode, 'FM0000')
from member;


-- Ordering more than one attribute:
select gender, memname from member
order by gender, memname;

select courseid, coursename, targetgroup, area from course where area = 'fitness' and (targetgroup = 'kid' or targetgroup = 'fam'

-- Return number and name of the fitness courses that are available for targetgroups children (kid) or families (fam).
select  count(*), coursename, targetgroup, area from course 
where area = 'fitness' and (targetgroup = 'kid' or targetgroup = 'fam') group by targetgroup, coursename, area

-- Return the members whose birthday is in May.
select * from member where extract(month from birthday) >= 05 and extract(day from birthday) >= 07

-- Return the members that were born before the year 2000?
select * from member where extract(year from birthday) < 2000

select count(distinct(targetgroup)) as "target group" from targetgroup
-- counts distinct targetgroups 
select count(distinct(targetgroup)) as "target group" from course;
-- counts distinct targetgroups that have courses


-- Return name and birthday of the oldest male member.
select memname, birthday from member
where birthday = (select min(birthday) from member where gender = 'm');

-- Return name and birthday of oldest female and male members
select gender, min(birthday) from member group by gender

select memname, birthday from member
where birthday in (select min(birthday) from member group by gender)


-- Return the trainers that teach 3 or more courses
select count(*), memname from course group by memname having count(*) >= 3

select * from course where memname in 
(select memname from course group by memname having count(*) >= 3)
-- returns everything for those trainers


-- How many members are enrolled in more than 4 courses?
select count(*) as coursecount, memname from enrollment group by memname having count(*) > 4
-- returns members and their coursecount
select count(memname) from (
select memname, count(*) as cnt from enrollment group by memname having count(*) > 4
)
-- returns count

-- Return for each trainer the number of courses the trainer teaches for a specific targetgroup. 
select memname, targetgroup, count(*) from course group by memname, targetgroup





select memname, targetgroup, count(coursename) from course group by memname, targetgroup

select area, count(coursename) from course group by area having count(coursename) >= 3

select memname, extract(year from age(now(), birthday)) age, parent from member 
where birthday = (select max(birthday) from member)

select courseid, count(memname) from enrollment group by courseid order by courseid

--Assignment 6

select distinct postalcode from member

select count(*) / count(distinct postalcode)::decimal from member 

with tmp as (
select postalcode, count(*) as num from member group by postalcode
)
select sum(num) from tmp

select count(*)::float / count(distinct postalcode) / count(*) from member
-- the same query:
select 1.0 / count(distinct postalcode) from member




-- Write a query that calculates the general selectivity rate of the column postalCode 
-- in member table for equality queries
SELECT 
    COUNT(DISTINCT postalCode) AS distinct_postal_codes,
    COUNT(*) AS total_rows,
    1.0 / COUNT(DISTINCT postalCode) AS selectivity_rate
FROM member;
--Selectivity Rate = Expected number of return rows / NUmber of rows in the table 
-- 0.16666666666666666667

select * from member

select c.memname, extract(year from age(c.birthday)) as childage, c.gender from member c inner join member f 
on c.parent = f.memname where f.memname = 'figaro'

select e.course_id, c.course_name, m.memname from member m inner join enrollment e on m.memname = e.memname
inner join course c on e.course_id = c.course_id where m.parent = 'figaro'

select * from enrollment


select count(*) / count(distinct postalcode) :: float / count(*) from member

select 1.0 / count(distinct gender) from member


--TTF

select m.memname, extract(year from age(m.birthday)), m.gender, p.memname, p.birthday
from member p inner join member m on m.parent = m.memname
where m.parent = 'Figaro' 
--no output

select m.memname, c.courseid, c.coursename
from enrollment e
inner join course c
on c.courseid = e.courseid
inner join member m on m.memname = c.memname
where m.parent = 'figaro'
--same issue


professor w_course as (select p.proid, count(p.profid) from professor as p 
inner join on c.profid = p.profid)





-- week 9
select memname, gender, max(birthday) from member group by memname
-- every birthday is max for each memname so this is incorrect semantically 
-- correct one:
select memname, gender, birthday from member 

select memname, gender, birthday from member where birthday = (select max(birthday) from member) 

select memname, gender, birthday from member where gender = 'm' order by birthday limit 1
-- here there may be more than one member with min birthday so the correct version is:
select memname, birthday from member where birthday = (select min(birthday) from member where gender = 'm')
-- this is if you want to find the oldest male member, 
--you should not specify gender if you are looking for the oldest member in general


insert into course (course_id, course_name, targetgroup, trainer) values
	(12, 'test', 'all', 'lazy')
-- inserted a course without an area (null value in arena column)


select count(*) from course
select count(*) from course where area = 'fitness'
select count(*) from course where not area = 'fitness' 
-- we have a missing course with null value in area
-- to fix this:
select count(*) from course where not area = 'fitness' or area is null

select * from course

select * from member
select * from member where parent is not null
-- minor members
select * from member where parent is null
-- adult members

select * from course
select count(courseid), area from course group by area

-- joins:
select * from course, trainer
-- the result is the cartesian product of tables course and trainer
select * from course
select * from trainer
-- n x m

select memname, count(coursename) from course group by memname
select count(memname), coursename from course group by coursename

select * from course cross join trainer
-- the same result

select * from course inner join trainer
on course.memname = trainer.memname
-- we only get the outputs where FK equals PK 

-- we can add where conditions to the join:
select * from course inner join trainer
on course.memname = trainer.memname where trainer.license = true and course.targetgroup = 'kid'

-- trainers that manage an area and have license
select t.memname, area, license from area a inner join trainer t on t.memname = a.manager where t.license = true



-- Return the trainer names of those trainers that
-- are enrolled in at least one course themselves and
-- teach at least one course and
-- manage an area:

select course.trainer, enrollment.course_id, course.course_id
from area inner join course 
on area.manager = course.trainer 
inner join enrollment on course.trainer = enrollment.memname
-- or: doesn't matter because the optimizer chooses the best way to do it anyways
SELECT course.trainer, enrollment.course_id, course.course_id
FROM enrollment INNER JOIN course
ON enrollment.memname=course.trainer
INNER JOIN area ON course.trainer=area.manager;


SELECT distinct c.trainer
FROM enrollment e INNER JOIN course c
ON e.memname=c.trainer
INNER JOIN area a ON c.trainer=a.manager;


select * from course inner join targetgroup on course.targetgroup = targetgroup.tcode ;
select * from course natural join targetgroup;
-- natural join is an inner join without specifying joined attributes. 
-- joins two tables simply based on same attribute name and datatype.

select * from enrollment natural join member limit 15;



-- week 11

-- Return a list of all trainers that teach at least one course. List needs to contain only trainer name. No duplicate names.
select distinct trainer from course
-- we may get here null values, because in the club we can have a course without a trainer
-- correct one:
select distinct trainer from course where trainer is not null

-- Which trainers teach more than 2 courses? Show trainer name, license information and number of courses they teach.
select t.tname, t.license, count(c.course_id) as "number of courses" from course c inner join trainer t 
on t.tname = c.trainer group by t.tname having count(c.course_id) > 2


-- Are there club members that are older than 18 but still have a parent in the club?
select *, extract(year from age(birthday)) as age from member where extract(year from age(birthday)) > 18 and parent is not null


select * from course inner join trainer on course.trainer= trainer.tname
-- returns only the matched rows
select * from course left join trainer on course.trainer= trainer.tname
-- returns matched rows plus unmatched rows from table course
select * from course right join trainer on course.trainer= trainer.tname
-- returns matched rows plus unmatched rows from table trainer


-- return a list of all parents with birthday and gender who have at least one child in the club.
select p.memname as parent, c.memname as child, p.birthday, p.gender from member c inner join member p on c.parent = p.memname


select p.memname as parent, count(p.memname) as "number of children"
from member c inner join member p on c.parent = p.memname group by p.memname

-- covering index example:
CREATE UNIQUE INDEX course_i_covering ON course (courseid) INCLUDE (coursename, memname);


select * from course inner join trainer on course.memname = trainer.memname
-- returns the matching rows
select * from course left join trainer on course.memname = trainer.memname
-- returns all the courses and their trainers
select * from course right join trainer on course.memname = trainer.memname
-- returns all the trainers and the courses they teach
-- but a trainer may not have a course so we get some null values for courseid

-- Return a list of all parents (parent members) with birthday and gender who have at least one child in the club. 
select p.memname, p.gender, p.birthday from member p inner join member c on c.parent = p.memname;
-- Return a list of all parents that also displays the number of children:
select p.memname, p.gender, p.birthday, count(*) "number of children" 
from member p inner join member c on c.parent = p.memname group by p.memname;





-- assignment 8

-- Create a view that displays:
-- area,
-- for each area the number of courses that is assigned to the area,
-- the course names of the assigned courses concatenated into one string, nicely delimited,
-- the percentage (of the total number of courses) that each area offers.

create view view_area_course as
select area, count(*), string_agg(coursename, ', '), round(count(*) * 100 / (select count(*) from course), 2)::decimal
as percentage 
from course group by area

-- slide solution:
CREATE VIEW area_course_summary AS
SELECT
    a.area,
    COUNT(c.courseid) AS course_count,
    STRING_AGG(c.coursename, ', ') AS course_names,
    ROUND((COUNT(c.courseid) * 100.0 / (SELECT COUNT(*) FROM course)), 2) AS percentage_of_total
FROM area a
LEFT JOIN course c ON a.area = c.area
GROUP BY a.area;




-- Create a view that displays all trainers and all information about them. 
create view view_trainer_info as
select t.memname, birthday, extract(year from age(birthday)) as age, gender, email, entrydate, license, startdate
from trainer t inner join member m on t.memname = m.memname



-- Display a list with
-- parent names
-- the number of children they have in the club
-- and the children's names. 
create view view_parents as
select p.memname, count(*) as "number of children", string_agg(c.memname, ', ') 
from member p inner join member c on c.parent = p.memname group by p.memname




-- Write a trigger which checks that a child cannot be registered in the club without parent

-- creating table member without constraints:
CREATE TABLE IF NOT EXISTS public.member1
(
    memname character varying(50) COLLATE pg_catalog."default" PRIMARY KEY NOT NULL,
    istrainer boolean,
    email character varying(50) COLLATE pg_catalog."default",
    postalcode integer,
    birthday date,
    gender gendertype,
    entrydate date,
    parent character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT fk_parent FOREIGN KEY (parent) REFERENCES public.member (memname)
);


-- for table member1:
create or replace function check_parent1() 
returns trigger
LANGUAGE 'plpgsql'
as $$
	begin 
		if extract(year from age(new.birthday)) < 18 and new.parent is null then
		raise exception 'child must have a parent';
		end if;
	return new;
end;
$$;


create or replace trigger member_insert1
before insert on member1
for each row
execute function check_parent1()


insert into member1 (memname, birthday) values
	('mari', '2020-01-01')
select *, extract(year from age(birthday)) from member1


-- for table member:
create or replace function check_parent() 
returns trigger
LANGUAGE 'plpgsql'
as $$
	begin 
		if extract(year from age(new.birthday)) < 18 and new.parent is null then
		raise exception 'child must have a parent';
		end if;
	return new;
end;
$$;


create or replace trigger member_insert
before insert on member
for each row
execute function check_parent()








CREATE OR REPLACE FUNCTION public.tr_trainer_insert()
RETURNS trigger
LANGUAGE 'plpgsql'
COST 100
VOLATILE NOT LEAKPROOF
AS $BODY$
	declare tr_trainer_name varchar(20);
	BEGIN
		IF NEW.istrainer = TRUE THEN
		select NEW.memname into tr_trainer_name
		FROM public.member
		WHERE member.memname = NEW.memname;
			IF tr_trainer_name IS NOT NULL THEN
			INSERT INTO public.trainer (memname)
			VALUES (tr_trainer_name);
			END IF;
		END IF;
	RETURN NEW;
END;
$BODY$;

-- we need to create trigger for the function to work
CREATE TRIGGER tr_insert_trainer
AFTER INSERT ON public.member
FOR EACH ROW
EXECUTE FUNCTION public.tr_trainer_insert();




-- week 13

-- Display name, birthday and gender of the youngest club member
select memname, email, birthday from member where birthday = (select max(birthday) from member)

-- using CTE:
with max_birthday as (
select max(birthday) as youngest from member
)
select memname, birthday, gender from member inner join max_birthday on member.birthday = max_birthday.youngest
-- CTE is a temporary table that exists only during the duration of the query


-- Which trainer started teaching courses first? Display trainer name and trainer Email and teaching start date.
select t.memname, email, startdate from trainer t inner join member m on t.memname = m.memname 
where startdate = (select min(startdate) from trainer)

-- with CTE:
with first_trainer as (
select min(startdate) as minimum from trainer
)
select t.memname, email, startdate from trainer t inner join member m on t.memname = m.memname 
inner join first_trainer ft on t.startdate = ft.minimum 
 


-- non correlated subquery in where clause

select c.courseid, c.coursename from course c
where c.courseid NOT in
(
select distinct e.courseid from enrollment e 
)
order by c.coursename;
-- returns courses that are not in enrollment table (that no one chose)
-- non correlated subquery
-- may be executed without accessing the outer query


-- correlated
select c.courseid, c.coursename from course c
where not EXISTS (
select 1 from enrollment e where e.courseid=c.courseid
)
order by c.coursename;
-- returns the same thing
-- correlated subquery
-- cannot be executed without accessing the outer query


-- The correlated subquery is evaluated for each tuple of the outer query.
-- A non-correlated sub-query may be executed only once and the result is then made available to the outer query



SELECT area, count(*)
from course
WHERE area IS NOT NULL
group by area
-- counts the courses per area

-- How many courses are offered on average per area?:
SELECT area, avg(count(*))
from course
WHERE area IS NOT NULL
group by area
-- returns an error because aggregate functions cannot be nested

select round(avg(tmp.number), 2) as "Average courses per area"
from
(
SELECT area, count(*) as number from course
WHERE area is NOT NULL
group by area
)
tmp 
-- sub select in the FROM clause

select round(avg(number), 2) as "Average courses per area"
from
(
SELECT area, count(*) as number from course
WHERE area is NOT NULL
group by area
) 



-- with CTE:
with course_numbers as (
SELECT area, count(*) as number from course
WHERE area is NOT NULL
group by area 
)
select round(avg(number), 2) as "Average courses per area" from course_numbers


-- subquery in the select clause:
-- Calculate and return the age:
select memname, birthday,extract(year from age(birthday)) as age
from member
order by age desc;



-- How many participants (enrollments) does each course have? Display a list that shows course_id, course
-- name and number of participants. Order the list:
select c.courseid, c.coursename, count(*)	from enrollment e inner join course c 
on e.courseid = c.courseid group by c.courseid


-- Now we would like to see the percentage of enrollments for each course as additional column in the result table. 
SELECT c.courseid, c.coursename, count(*) as "Number of Participants",
count(*) *100 / SUM(COUNT(*)) AS percentage
from enrollment e inner join course c
on c.courseid=e.courseid
GROUP by c.courseid
order by count(*) DESC
-- throws the same error because of the nested aggregate function


select count(*) from enrollment group by courseid

SELECT c.courseid, c.coursename, count(*) as "Number of Participants",
round(count(*) *100 / (select COUNT(*)::decimal from enrollment), 2) AS percentage
from enrollment e inner join course c
on c.courseid=e.courseid
GROUP by c.courseid
order by count(*) DESC
-- with :: we are casting it into decimals

-- window function:
SELECT c.courseid, c.coursename, count(*) as "Number of participants",
SUM(COUNT(*)) over() as "Total",
count(*) *100 / SUM(COUNT(*)) over() AS "Percentage"
from enrollment e inner join course c on c.courseid=e.courseid
GROUP by c.courseid
order by c.courseid asc;
-- you can nest aggregate functions in window function
-- window function is like an aggregate function but it returns the data for all the rows instead of a single row


-- How many courses are offered on average per area? with window function:
select area, count(*) as "course number in area", round(avg(count(*)) over(), 2) as "average per course"
from course where area is not null group by area


-- Which member(s) is / are enrolled in the highest number of courses?
select memname, count(*) from enrollment group by memname having count(*) =(
select max(num) from(select count(*) as num from enrollment group by memname)tmp
)


with maxnum as (
select max(num) as maximum from(select count(*) as num from enrollment group by memname)
), enroll as (
select memname, count(*) as ennum from enrollment group by memname
)
select memname, ennum, maximum from maxnum m inner join enroll e on m.maximum = e.ennum



-- with CTE:
with member_enrollments as (
select memname, count(*) as num from enrollment group by memname
), max_enrollment as (
select max(num) as maxnum from member_enrollments
)
select memname, num from member_enrollments inner join max_enrollment 
on member_enrollments.num = max_enrollment.maxnum


-- with window function:
With tmp as (
select m.memname, m.gender, m.birthday, count(*) as num,
max(count(*)) OVER() as maxnum
from enrollment e inner join member m on m.memname=e.memname
group by m.memname
)
select * from tmp where num = maxnum;


With tmp as (
select m.memname, m.gender, m.birthday, count(*) as num,
max(count(*)) OVER(partition by gender) as maxnum
from enrollment e inner join member m on m.memname=e.memname
group by m.memname
)
select * from tmp where num = maxnum;




-- window function with partitioning
with tmp as (
select m.memname, m.gender, count(*),
max(count(*)) OVER (Partition by gender) as maxnum
from enrollment e inner join member m on m.memname=e.memname
group by m.memname
)
select distinct gender, maxnum from tmp;




-- week 14

-- views:
create or replace view v_adults as (
select * ,extract(year from age(birthday))
from member
where extract(year from age(birthday)) >= 18
); 

select * from v_adults
update v_adults set email = 'rfjerfjegk' where memname = 'nelly'

select * from v_adults
-- we updated an email for nelly in the view table and we check if it's updated in the base table as well:

select * from member
-- the data is updated in the base table as well

update v_adults set istrainer = true where memname = 'lion'
-- updates both tables 


-- we create view for enrollments:
CREATE OR REPLACE VIEW v_enrollments AS (
SELECT course.courseid, course.coursename, count(*) AS
enrollment_number
FROM enrollment JOIN course ON enrollment.courseid =
course.courseid
GROUP BY course.courseid
ORDER BY (count(*)) DESC
);


insert into enrollment values
	('val', 9)

select * from v_enrollments

-- we update the name of a course
update v_enrollments
set coursename= 'water and fun' where coursename=
'free style';
-- this view contains group by clause and cannot be updated


-- A view can be updated if there is a 1:1 relationship between the fields of the view and the fields of the base table.
-- that is "plain" views


SELECT *
FROM information_schema.tables
WHERE table_type = 'VIEW'
and table_schema = 'public';
-- there is a column that tells you if the view is insertable

-- info about materialized views:
SELECT *
FROM pg_matviews
where schemaname = '<schema_name>';
-- materialaized views are not updatable at all
-- they can only be refreshed not updated


-- creting view for vertical partitioning:
create or replace view v_trainer as (
select 
member.memname,
member.email,
member.postalcode,
member.gender,
member.entrydate,
member.parent,
member.birthday,
member.istrainer,
trainer.memname as tname,
trainer.license,
trainer.startdate
from member inner join trainer on member.memname = trainer.memname
where member.istrainer = TRUE
);
-- there was an issue because two collumns are called memname in trainer and member tables
-- a view must be containig distinct columns

select * from v_trainer


-- functions:
select upper('coach')
-- returns uppercase

select reverse('coach')
-- reverses the string

select pi()
-- returns the number PI

SELECT REGEXP_REPLACE('coach', '[aeiou]', '_', 'g');
-- REGEXP_REPLACE(string, pattern, replacement [, flags])
-- replaces the pattern in a string
-- g is for global

-- these were single-row functions


-- multi-row functions:
SELECT targetgroup, STRING_AGG(coursename, ', ') as "course list" FROM course
GROUP BY targetgroup;
-- returns the list as a column
-- STRING_AGG(expression, delimiter)

-- Display a list with the parents, the number of children in the club and the children's names. 
select p.memname, count(*) as "number of children", string_agg(c.memname, ', ') as "names of children" 
from member p inner join member c on p.memname = c.parent group by p.memname


-- creating trigger:
CREATE OR REPLACE FUNCTION public.tr_trainer_insert()
RETURNS trigger
LANGUAGE 'plpgsql'
COST 100
VOLATILE NOT LEAKPROOF
AS $BODY$
	declare tr_trainer_name varchar(20);
	BEGIN
		IF NEW.istrainer = TRUE THEN
		select NEW.memname into tr_trainer_name
		FROM public.member
		WHERE member.memname = NEW.memname;
			IF tr_trainer_name IS NOT NULL THEN
			INSERT INTO public.trainer (memname)
			VALUES (tr_trainer_name);
			END IF;
		END IF;
	RETURN NEW;
END;
$BODY$;

-- we need to create trigger for the function to work
CREATE TRIGGER tr_insert_trainer
AFTER INSERT ON public.member
FOR EACH ROW
EXECUTE FUNCTION public.tr_trainer_insert();



insert into member values
	('ana', true, 'dgkjbrjk', 40060, '2000-12-15', 'f')

select * from member
-- we will see ana here because we added it into the member table
select * from trainer
-- thanks to the trigger, because istrainer is true the new data will be added to the trainer table as well




---------------------------
---------------------------

-- Return name and birthday of oldest female and male members
select memname, birthday from member where birthday in (select min(birthday) from member group by gender)
















