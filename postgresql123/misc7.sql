create database misc7
	with owner = postgres
	template = template0
	encoding = 'UTF8'
	strategy = 'wal_log'
	icu_locale = 'en-US'
	locale_provider = 'icu'
	tablespace = pg_default
	connection limit = -1
	is_template = false;


select * from purchase inner join suppliers on purchase.s_suppkey = suppliers.s_suppkey

explain (verbose, analyze) select * from purchase inner join suppliers on purchase.s_suppkey = suppliers.s_suppkey

-- 5. The join is executed with a hash join.
-------- 1. which table is used for the build phase (building the hash table)?
--the suppliers table is used for the build phase. 7-11 is a build phase

-------- 2. Whatoperation is used to load the file / build the hash table?
--sequential scan is used to loas the data from suppliers table to hash table

-------- 3. What data does the hashtable contain?
--hash table contains the output columns of supplier table. s_suppkey used as a PK in hash join 
--and s_name, s_adress, s_nationkey, s_phone, s_acctbal, s_comment.

-------- 4. Which table is probed against the hash table?
--Purchase table is probed against the hash table.

explain (verbose, analyze) select * from purchase inner join suppliers on
purchase.s_suppkey = suppliers.s_suppkey
where suppliers.s_suppkey = 29
--The loops=1 occurs because the WHERE condition (suppliers.s_suppkey = 29) reduces
--the outer table (suppliers) to just one row. Consequently, the nested loop join 
--executes only one iteration for this row while scanning the purchase table.



CREATE INDEX idx_purchase_s_suppkey ON purchase (s_suppkey);


explain (verbose, analyze) select * from purchase inner join suppliers on
purchase.s_suppkey = suppliers.s_suppkey
where purchase.s_suppkey = 29
--Before the index: A sequential scan is used on the purchase table, scanning all rows.
--After the index: An index scan is used on the purchase.s_suppkey column, allowing efficient retrieval of rows matching 
--purchase.s_suppkey = 29.
--This makes the nested loop join faster as it avoids scanning the entire purchase table.


-------------Using Join:
SELECT p.prof_i_d, p.name 
FROM professor p
LEFT JOIN course c ON p.prof_i_d = c.prof_i_d
WHERE c.prof_i_d IS NULL;
------------Using Uncorrelated Subquery:
SELECT p.prof_i_d, p.name 
FROM professor p
WHERE p.prof_i_d NOT IN (
    SELECT c.prof_i_d 
    FROM course c
);
------------Using correlated subquery
SELECT p.prof_i_d, p.name 
FROM professor p
WHERE NOT EXISTS (
    SELECT 1 
    FROM course c 
    WHERE c.prof_i_d = p.prof_i_d
);

----------Using Subquery:
SELECT p.prof_i_d, p.name,
    SUM(c.contact_hours) AS teaching_load,
    ROUND(
        SUM(c.contact_hours) * 100.0 /
        (SELECT SUM(contact_hours) FROM course), 
        2
    ) AS percentage_of_total
FROM professor p
LEFT JOIN course c ON p.prof_i_d = c.prof_i_d
GROUP BY p.prof_i_d, p.name;
--how do we take care of null values? (COELESCE)
----------Using Window Function:
SELECT p.prof_i_d, p.name,
    SUM(c.contact_hours) OVER (PARTITION BY p.prof_i_d) AS teaching_load,
    ROUND(
        SUM(c.contact_hours) OVER (PARTITION BY p.prof_i_d) * 100.0 /
        SUM(c.contact_hours) OVER (), 
        2
    ) AS percentage_of_total
FROM professor p
LEFT JOIN course c ON p.prof_i_d = c.prof_i_d;



----------Using Subquery:
SELECT s.stud_i_d, s.name AS student_name, s.semester, e.grade, 
    (SELECT AVG(points) FROM examination WHERE course_i_d = 5001) AS average_points, 
    e.points AS individual_points
FROM student s
JOIN examination e ON s.stud_i_d = e.stud_i_d
WHERE e.course_i_d = 5001 AND e.points < (SELECT AVG(points) FROM examination WHERE course_i_d = 5001);

--Using CTE:
WITH avg_points AS (
    SELECT AVG(points) AS average_points 
    FROM examination 
    WHERE course_i_d = 5001
)
SELECT s.stud_i_d, s.name AS student_name, s.semester, e.grade, ap.average_points, e.points AS individual_points
FROM student s
JOIN examination e ON s.stud_i_d = e.stud_i_d
JOIN avg_points ap ON e.course_i_d = 5001
WHERE e.points < ap.average_points;







--------Using query
SELECT s.stud_i_d, s.name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM course c
    WHERE c.contact_hours = 4
    AND c.course_i_d NOT IN (
        SELECT e.course_i_d
        FROM enrollment e
        WHERE e.stud_i_d = s.stud_i_d
    )
);


--Using Window Function:
WITH student_scores AS (
    SELECT 
        s.stud_i_d, 
        s.name AS student_name, 
        s.semester, 
        e.grade, 
        AVG(e.points) OVER (PARTITION BY e.course_i_d) AS average_points, 
        e.points AS individual_points
    FROM student s
    JOIN examination e ON s.stud_i_d = e.stud_i_d
    WHERE e.course_i_d = 5001
)
SELECT * 
FROM student_scores
WHERE individual_points < average_points;














