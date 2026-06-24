-- week 7

-- Return the name of the standing waters that have a quality of 5 or better.
select sw_id, sw_name, sw_quality
from s_water
where sw_quality::text::integer >=5;
-- quality is an enum type so we have to cast it





select * from finances

select org_id, amount from finances order by amount desc limit 1
-- this is wrong, there can be more than 1 organization that has maximum amount
-- correct version:
select org_id, amount from finances where amount = (select max(amount) from finances)


-- week 11

-- ‘union’ is the operator used to combine two sets into a new set, dropping duplicate elements
-- union drops the duplicate rows
-- union all includes the duplicate rows
-- the tables should have the same number of columns and the columns should have the same data types

select rw_id, rw_name, rw_quality from r_water
union
select sw_id, sw_name, sw_quality from s_water order by rw_id


select rw_id, rw_name, rw_length from r_water
union
select sw_id, sw_name, surface from s_water order by rw_id
-- even though the columns have different names, this query still works because they have the same data type

-- recursive CTE:
WITH RECURSIVE flow (rw_id, rw_name, rw_flows_into) AS (
 -- Base part
 SELECT rw_id, rw_name, rw_flows_into FROM r_water
WHERE rw_name = 'MtisChala'
 UNION
 -- Recursive part
 SELECT r.rw_id, r.rw_name, r.rw_flows_into
FROM r_water r inner join flow f
ON r.rw_id = f.rw_flows_into
WHERE f.rw_flows_into IS NOT NULL
)
-- The outer SELECT statement using the CTE
SELECT * FROM flow;


-- in order to avoid cycles thanks to errors in the database we use terminationa conditions	:
WITH RECURSIVE flow (rw_id, rw_name, rw_flows_into, path) AS (
 -- Base part
 SELECT rw_id, rw_name, rw_flows_into, array[rw_id] FROM r_water
WHERE rw_name = 'MtisChala'
 UNION
 -- Recursive part
 SELECT r.rw_id, r.rw_name, r.rw_flows_into, path || r.rw_id
FROM r_water r inner join flow f ON f.rw_flows_into = r.rw_id
WHERE f.rw_flows_into IS NOT NULL
OR r.rw_id <> ALL(path))
-- The outer SELECT statement using the CTE
SELECT * FROM flow;


-- week 14

-- creating view for horizontal partitioning:
create or replace view v_water (water_id, water_name, water_quality) as
(
select rw_id, rw_name, rw_quality from r_water
union
select sw_id, sw_name, sw_quality from s_water
);
-- not updatable because there is a union



-- mock exam:


-- task 3:
WITH all_wb AS (
SELECT rw_id as water_id, rw_name as water_name, rw_quality as
water_quality
FROM r_water
UNION
SELECT sw_id, sw_name, sw_quality
FROM s_water
), average_wb as (
SELECT AVG(all_wb.water_quality::text::integer) AS total_avg_quality FROM all_wb
)
SELECT CASE
WHEN (LEFT(all_wb.water_id::text,1)= '1') THEN 'running_water'
WHEN (LEFT(all_wb.water_id:: text,1)='2') THEN 'standing_water'
ELSE 'water_type_unknown'
END AS water_type, COUNT(*) AS number
from all_wb CROSS JOIN average_wb
WHERE all_wb.water_quality::text::integer < average_wb.total_avg_quality
GROUP BY LEFT(all_wb.water_id::text,1) ;


-- task 4:
with max_researcher as (
select org_name, count(r_name) as num, string_agg(r_name, ', ') 
from researcher r inner join organization o on o.org_id = r.org_id
group by org_name
)
select * from max_researcher where num = (select max(num) from max_researcher)




select * from organization

select * from researcher







