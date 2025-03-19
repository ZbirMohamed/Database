
BEGIN

DROP DATABASE learn IF EXISTS;
CREATE DATABASE learn;

CREATE TABLE EMPLOYEE(
    id SERIAL,
    name VARCHAR NOT NULL,
    age INT NOT NULL
)PARTITION BY RANGE (id);

DROP INDEX IF EXISTS idx_idemp;

CREATE INDEX idx_idemp ON EMPLOYEE (id);


DO $$
DECLARE
  id_from INT;
  id_to INT;
  query TEXT;
BEGIN 
    -- let's say I want to create 20 partitions
    -- each partition will have 1000 employee
    for counter in 0..19 loop
        id_from := counter * 1000;
        id_to := (counter + 1) *1000;

        query:= 'CREATE TABLE emp_' || id_from || '_' || id_to || ' PARTITION OF EMPLOYEE FOR VALUES FROM (' || id_from || ') TO (' || id_to ||')';

		execute query;
		
    end loop;

END;
$$ LANGUAGE PLPGSQL;

INSERT INTO EMPLOYEE (nom, age)
SELECT 
    'emp_' || gs AS nom,
    (random() * 60 + 18)::INT AS age  
FROM generate_series(1, 20000) AS gs;

COMMIT;


-- The following are queries that enables you to see your partitions --
/*
SELECT 
    child.relname AS partition_name,
    parent.relname AS parent_table
FROM pg_inherits
JOIN pg_class AS child ON pg_inherits.inhrelid = child.oid
JOIN pg_class AS parent ON pg_inherits.inhparent = parent.oid;

SELECT 
    child.relname AS partition_name
FROM pg_inherits
JOIN pg_class AS child ON pg_inherits.inhrelid = child.oid
WHERE pg_inherits.inhparent = 'employee'::regclass;

*/