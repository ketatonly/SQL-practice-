create database misc
	with owner = postgres
	template = template0
	encoding = 'UTF8'
	strategy = 'wal_log'
	icu_locale = 'en-US'
	locale_provider = 'icu'
	tablespace = pg_default
	connection limit = -1
	is_template = false;


create table three_cols (
		a integer not null,
		b text not null,
		c float
	)

insert into three_cols(a,b,c)
select *, md5(x::text), log(x) from generate_series(1,1000,1) as x
-- md5 produces a 32-character hash value out of a text value

select oid, datname from pg_database where datname = 'misc'
select oid, datname from pg_database where oid = 33612
-- find a table within a database:
SELECT oid, relname, relkind, relpages, reltuples from pg_class WHERE relname = 'three_cols';
-- file sizes are multiples of 8 because heap files are organized in 8kB pages (blocks)
-- data is stored as a sequence of bytes


select * from three_cols
explain select * from three_cols
-- seq scan reads all the rows one by one
-- explain shows the query execution plan 
explain verbose select * from three_cols
-- verbose outputs the columns and more details
explain (verbose, analyze) select * from three_cols
-- analyze shows the actual execution details with planning time, execution time and loops

-- the output is not ordered
-- we can check by updating the data:
update three_cols set b = 'this text replaces mb5 hash for some rows with simple text' where a between 100 and 140

explain (verbose, analyze) select * from three_cols
explain (verbose, analyze) select * from three_cols order by a
explain (verbose, analyze) select * from three_cols order by a limit 50
explain (verbose, analyze) select * from three_cols where a = 99

-- creating the same table with PK:
Drop table if EXISTS three_cols_pk;
CREATE TABLE three_cols_pk AS
SELECT * FROM three_cols;


alter table three_cols_pk add constraint three_cols_pk_pkey primary key (a)
-- primary key does not help with ordering

select * from three_cols_pk

explain (verbose, analyze) select * from three_cols_pk
explain (verbose, analyze) select * from three_cols_pk order by a
explain (verbose, analyze) select * from three_cols_pk where a = 99
-- index structure is created
-- uses index scan instead of seq scan and then sorting
-- this is a separate table with different structure 

select relname, oid, relkind, relfilenode, relpages, relpages * 8192 as size 
from pg_class where relname = 'three_cols_pk_pkey' or relname = 'three_cols_pk'
-- three_cols_pk is a table whereas three_cols_pk_pkey is an index 
-- table is accessed through heap method
-- index is accessed through btree method


select ctid, * from three_cols
select ctid, * from three_cols_pk
-- row identifier tells the physical location of each row 
-- (pagenumber, offset)

select ctid, * from three_cols where a = 10
update three_cols set b = 'just another text' where a = 10
select ctid, * from three_cols where a = 10

show shared_buffers
-- how much memory is allocated for the database buffer
-- 128MB


-- SQL command triggers a page request
--> Page in the buffer?
	--> Yes? Great. No need for a disk I/O.
	--> No?
		--> Empty Frame?
		--> Yes – load page there
		--> No? 
			--> Choose a page to remove (Replacement Strategy) 

-- The most popular replacement strategy is to remove the page whose data has not been 
	-- requested / referenced for the longest time 

-- for reducing disk I/O we can use indexing, Frequently accessed data can be kept in memory(cache)


-- BTrees are indexes that are optimzed for page access
-- A B-Tree node occupies a page or a set of continous pages


-- heap files:
	-- organized in 8kB pages 
	-- not sorted/ordered
	-- reading is slow

-- index files:
	-- separated data structure from the heap file
	-- is sorted (BTree)
	-- reading is fast 





-----------------------
-- Assignment 6

select ctid, * from three_cols_pk where c between 1 and 2 AND a between 80 and 120; -- 21 outputs

explain (verbose, analyze) select ctid, * from three_cols_pk where c between 1 and 2 AND a between 80 and
120;

"Seq Scan on public.three_cols_pk  (cost=0.00..36.00 rows=4 width=52) (actual time=0.049..0.315 rows=21 loops=1)"
"  Output: ctid, a, b, c"
"  Filter: ((three_cols_pk.c >= '1'::double precision) AND (three_cols_pk.c <= '2'::double precision) AND (three_cols_pk.a >= 80) AND (three_cols_pk.a <= 120))"
"  Rows Removed by Filter: 981"
"Planning Time: 0.105 ms"
"Execution Time: 0.336 ms"

create type gender as enum ('m', 'f')

create table horse (
	horsename varchar(30) primary key,
	birthday date,
	gender gender,
	father varchar(30),
	mother varchar(30),
	foreign key (father) references horse(horsename),
	foreign key (mother) references horse(horsename)
);

INSERT INTO public.horse(
	horsename, birthday, gender, father, mother)
	VALUES
	('Amigo', NULL, 'm', 'Max', 'Bella'),
	('Bella', NULL, 'f', NULL, NULL),
	('Diva', NULL, 'f', 'Moritz', 'Lucky'),
	('Dylan', NULL, 'm', NULL, NULL),
	('Gentle', NULL, 'f', 'Dylan', 'Diva'),
	('Ivy', NULL, 'f', 'Dylan', 'Diva'),
	('Lady', NULL, 'f', 'Dylan', 'Diva'),
	('Lucky', NULL, 'f', 'Max', 'Bella'),
	('Max', NULL, 'm', NULL, NULL),
	('Merlin', NULL, 'm', 'Moritz', 'Lucky'),
	('Moritz', NULL, 'm', NULL, NULL),
	('Ronja', NULL, 'f', NULL, NULL),
	('Susan', NULL, 'f', 'Amigo', 'Ronja');

select * from horse;


SELECT * FROM public.horse WHERE horsename = 'Gentle'
UNION
SELECT * FROM public.horse WHERE horsename = (SELECT father FROM public.horse WHERE horsename = 'Gentle');

select * from horse where horsename = 'Susan'
union
select * from horse where horsename = (select father from horse where horsename = 'Susan')
union
select * from horse where horsename = (select father from horse where horsename = (select father from horse where horsename = 'Susan') )


SELECT * FROM public.horse WHERE horsename = 'Gentle'
UNION
SELECT * FROM public.horse WHERE horsename = (SELECT mother FROM public.horse WHERE horsename = 'Gentle')
UNION
SELECT * FROM public.horse WHERE horsename = (SELECT mother FROM public.horse WHERE horsename = 
(SELECT mother FROM public.horse WHERE horsename = 'Gentle'))
UNION
SELECT * FROM public.horse WHERE horsename = (SELECT mother FROM public.horse WHERE horsename = 
(SELECT mother FROM public.horse WHERE horsename = (SELECT mother FROM public.horse WHERE horsename = 'Gentle')));






WITH RECURSIVE father_tree AS (
    SELECT * FROM public.horse WHERE horsename = 'Gentle'
    UNION
    SELECT h.* FROM public.horse h
    JOIN father_tree ft ON h.horsename = ft.father
),
mother_tree AS (
    SELECT * FROM public.horse WHERE horsename = 'Gentle'
    UNION
    SELECT h.* FROM public.horse h
    JOIN mother_tree mt ON h.horsename = mt.mother
)
-- Combine results from both trees
SELECT * FROM father_tree
UNION
SELECT * FROM mother_tree;


select * from three_cols_pk order by ctid desc





--TTF

with recursive familytree As (
	select horsename, father from horse where horsename = 'Gentle'
union all
select h.horsename, h.father from horse h
inner join familytree ft on ft.father = h.horsename)

select horsename, father from familytree;

with recursive familytree As (
	select horsename, mother from horse where horsename = 'Susan'
union all
select h.horsename, h.mother from horse h
inner join familytree ft on ft.mother = h.horsename)

select horsename, mother from familytree;



with recursive familytree_father As (
	select horsename, father, mother from horse where horsename = 'Gentle'
union all
select h.horsename, h.father, h.mother from horse h
inner join familytree_father ft on ft.father = h.horsename
 ),familytree_mother As (
	select horsename, father, mother from horse where horsename = 'Gentle'
union all
select h.horsename, h.father, h.mother from horse h
inner join familytree_mother ft on ft.mother = h.horsename)

select horsename, mother, father from familytree_father
union 
select horsename, mother, father from familytree_mother
order by horsename




-- week 11
select ctid, * from three_cols

-- how will the index make the execution more efficient?
explain (verbose, analyze)
select * from three_cols_pk where c between 1 and 1.1760912590556813;
-- uses seq scan with filtering 
-- does not make any difference because indexing is on column a not c hence uses seq scan


select indexname, indexdef from pg_indexes where tablename = 'three_cols_pk'
-- BTREE index 

select * from three_cols_pk where c between 1 and 1.1760912590556813;
explain (verbose, analyze)
select ctid, * from three_cols_pk where c between 1 and 1.1760912590556813;
-- here indexing does not help with execution time because the indexing is on column a and not c. seq scan is required
-- and we have seq scan

CREATE INDEX three_cols_i_c ON three_cols_pk (c);
-- we create index on column c
explain (verbose, analyze)
select ctid, * from three_cols_pk where c between 1 and 1.1760912590556813;
-- here we use index scan with index condition

-- an index scan accesses the BTree index and heap file
-- first you enter at the btree root 
-- in our case we had a range so we navigate to the leaf nodes with the LO key 
-- after that we traverse the leaf nodes as long as it is in the range and extract row ids
-- we access heap files for these row ids and return the rows 


-- summary of workflow for B+Trees:
-- Traverse the B+Tree from the root to find the lo key in the leaf node.
-- Sequentially scan the leaf nodes for all keys between lo and hi.
-- For each key in the range, use the RID to fetch the corresponding rows from the heap file.


explain (verbose, analyze) 
select ctid, * from three_cols_pk where c between 1 and 1.462397997898956;
-- we get more outputs here so the optimizer chooses bitman index and heap scans
-- bitmap index scan collects page numbers and after that with heap scan acesses all matching rows
-- "Bitmap Heap Scan on public.three_cols_pk  (cost=4.48..21.63 rows=20 width=46) (actual time=0.013..0.015 rows=20 loops=1)"
"  ->  Bitmap Index Scan on three_cols_i_c  (cost=0.00..4.48 rows=20 width=0) (actual time=0.009..0.009 rows=20 loops=1)"


-- index scan has to access heap file once for each found value
-- bitmap index scan has to access heap file for number of pages marked in the bitmap times 



explain (verbose, analyze)
select ctid, * from three_cols_pk
where a between 100 and 110 OR c between 1 and 1.255272505103306;
-- here the optimizer can use two indexes, the one on a and the other on c
-- both indexes are used in bitmap index scan
-- this query need to access 3 tables (files)
-- bitmap 1: column c;
-- bitmap 2: column a;
-- pages:     0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
-- bitmap1:   1 0 0 0 0 0 0 0 0 0 0   0  0  0  0  0
-- bitmap2:   0 0 0 0 0 0 0 0 1 1 0  0   0  0  0  0
-- result:    1 0 0 0 0 0 0 0 1 1 0   0  0  0  0  0

-- disadvantages of indexes:
-- takes up storage
-- slows down write operations because indexes all have to be maintained, as well
-- add general overhead


-- index on columns:
-- if an attribute is queried often 
-- if an attribute is highly selective.
-- 		An attribute is highly selective if all values are unique (no duplicates in the index) or
-- 		a large number of values are unique (few duplicates in the index).
-- if an attribute is a foreign key

-- do not index if:
-- opposite of the above
-- there are constant writes on an attribute (indexes constantly change and need to be updated)
-- table is small



-- selectivity rate:
-- expected number of returned rows / number of rows in the table



-- covering index example:
-- # CREATE UNIQUE INDEX course_i_covering ON course (course_id) INCLUDE (course_name, trainer);
-- here the index have columns: course_id, course_name and trainer
-- only column course_id is indexed 
-- (other two are "trailing columns", they are stored in the index structure but not indexed)


-- \di   -- list of realtions













CREATE TABLE public.suppliers (
    s_suppkey integer NOT NULL primary key,
    s_name character(25) NOT NULL,
    s_address character varying(40) NOT NULL,
    s_nationkey integer NOT NULL,
    s_phone character(15) NOT NULL,
    s_acctbal numeric(15,2) NOT NULL,
    s_comment character varying(101) NOT NULL
);

select ctid, * from suppliers
-- occupies three pages. (2, 10)

delete from suppliers where s_suppkey % 2 = 1
-- deletes rows with odd PK
select ctid, * from suppliers
-- the number of pages stays the same but we get half the amount of rows returned


INSERT INTO public.suppliers (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment) VALUES 
(1, 'Supplier#000000001       ', ' N kD4on9OM Ipw3,gf0JBoQDd7tgrzrddZ', 17, '27-918-335-1736', 5755.94, 'each slyly above the careful');
INSERT INTO public.suppliers (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment) VALUES 
(101, 'Supplier#000000101       ', ' N kD4on9OM Ipw3,gf0JBoQDd7tgrzrddZ', 17, '27-918-335-1736', 5755.94, 'each slyly above the careful');

select ctid, * from suppliers
-- new tuples are added on the last page, last offset

vacuum suppliers
INSERT INTO public.suppliers (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment) VALUES 
(3, 'Supplier#000000003       ', ' N kD4on9OM Ipw3,gf0JBoQDd7tgrzrddZ', 17, '27-918-335-1736', 5755.94, 'each slyly above the careful');
INSERT INTO public.suppliers (s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment) VALUES 
(103, 'Supplier#000000103       ', ' N kD4on9OM Ipw3,gf0JBoQDd7tgrzrddZ', 17, '27-918-335-1736', 5755.94, 'each slyly above the careful');

select ctid, * from suppliers
-- frees up space for reuse. does not re-order the rows 

vacuum full suppliers 
select ctid, * from suppliers
-- compresses the files and now we have 2 pages instead of 3
-- reorganizes the whole file physically, fills all holes. does not re-order
-- all indexes have to be rebuild as well. RUN ONLY IN THE WORST CASE!





-- week 13 CE

create index three_cols_pk_covering on three_cols_pk (a) include (c)
select indexname, indexdef from pg_indexes where tablename = 'three_cols_pk'

explain (verbose, analyze) select c from three_cols_pk where a = 500
explain (verbose, analyze) select a from three_cols_pk where c = 1
select * from three_cols_pk
-- the covering index created with the INCLUDE clause allows the query to retrieve all the required data
-- directly from the index, without needing to access the table itself.
explain (verbose, analyze) select c from three_cols_pk where a > 990
select * from three_cols_pk
explain (verbose, analyze) select c from three_cols_pk where a > 980 or a < 20




-- Assignment 7

CREATE TABLE public.purchase (
    p_timestamp timestamp without time zone NOT NULL,
    product text,
    s_suppkey integer
);

ALTER TABLE ONLY public.purchase ADD CONSTRAINT purchase_pkey PRIMARY KEY (p_timestamp);
ALTER TABLE ONLY public.purchase 
ADD CONSTRAINT purchase_s_suppkey_fkey FOREIGN KEY (s_suppkey) REFERENCES public.suppliers(s_suppkey) NOT VALID;

CREATE INDEX fk_index ON purchase (s_suppkey);
drop index fk_index

-- Join the 2 tables using the following join:
select * from purchase inner join suppliers on
purchase.s_suppkey = suppliers.s_suppkey
-- (1000 row result table)

-- Run an explain statement on the join:
explain (verbose, analyze) select * from purchase inner join suppliers on
purchase.s_suppkey = suppliers.s_suppkey

select * from suppliers
select * from purchase


explain (verbose, analyze) select * from purchase inner join suppliers on
purchase.s_suppkey = suppliers.s_suppkey
where suppliers.s_suppkey = 29 





-- week 13

explain (verbose, analyze) SELECT * FROM suppliers
JOIN purchase ON suppliers.s_suppkey = purchase.s_suppkey
-- suppliers is in the build phase because it is a smaller table with 100 rows
-- purchase table is in the probe phase

explain (verbose, analyze) SELECT * FROM suppliers
JOIN purchase ON suppliers.s_suppkey = purchase.s_suppkey
where purchase.product = 'tent';
-- uses seq scan on product because it is not indexed
-- then filters it
-- and then hash join
-- after build phase the first thing that comes is filter because we are using WHERE condition

ALTER TABLE ONLY public.suppliers ADD CONSTRAINT suppliers_pkey PRIMARY KEY (s_suppkey);

explain (verbose, analyze) SELECT * FROM suppliers
JOIN purchase ON suppliers.s_suppkey = purchase.s_suppkey
where purchase.p_timestamp = '2024-11-26 12:47:17.59907';
-- in this case the table in the build phase is purchase
-- because where clause is one of the first to be executed,
-- postgres checks it first and now it sees that primary key is used in this clause
-- because it is highly selective the purchase table is used in the build phase

explain (verbose, analyze) SELECT * FROM suppliers
JOIN purchase ON suppliers.s_suppkey = purchase.s_suppkey
where purchase.s_suppkey = 29;
-- suppkey is indexed so the build table is purchase table
-- the last method is nested loop

explain (verbose, analyze) SELECT * FROM suppliers
JOIN purchase ON suppliers.s_suppkey = purchase.s_suppkey
WHERE purchase.p_timestamp = '2024-11-26 12:47:17.59907' and purchase.s_suppkey = 29;



-- the more selective the query is the more possibility is there that we use nested loop



explain (verbose, analyze) select * from three_cols_pk where a = 10

explain (verbose, analyze) select * from three_cols_pk where a > 10 and a < 100



