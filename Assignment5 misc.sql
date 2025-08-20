drop table three_cols

CREATE TABLE public.three_cols (
a integer NOT NULL,
b text NOT NULL,
c double precision
);


INSERT INTO three_cols(a,b,c)
SELECT x,
md5(x::text),
log(x)
FROM generate_series(1,1000,1) AS x;


SELECT oid, relname, relkind, relpages, reltuples from pg_class WHERE relname = 'three_cols';

explain select * from three_cols;
explain(verbose, analyze) select * from three_cols;

Update three_cols set b= 'This text replaces the md5 hash for some rows with simple text' 
where a between 100 and 140;
select * from three_cols;

explain (verbose, analyze) select * from three_cols order by a limit 50;

explain (verbose, analyze) select * from three_cols where a = 999;


CREATE TABLE three_cols_pk AS
SELECT * FROM three_cols;

explain (verbose, analyze) select * from three_cols_pk order by a;

explain (verbose, analyze) select * from three_cols_pk where a = 999;

select ctid, * from three_cols_pk;

SELECT ctid FROM three_cols ORDER BY ctid DESC LIMIT 1;
SELECT ctid FROM three_cols_pk ORDER BY ctid DESC LIMIT 1;

select * from three_cols;
INSERT INTO three_cols (a, b, c)
VALUES (9999, 'Keti Shavelashvili', LOG(9999));

INSERT INTO three_cols_pk (a, b, c)
VALUES (10000, 'Keti Shavelashvili', LOG(10000));

show shared_buffers;








