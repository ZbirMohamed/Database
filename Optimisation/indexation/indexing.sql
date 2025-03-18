-- show tables -----
-- \dt || \dt *.* || \d <nom_table> : (  plus de description sur une table  )
select table_name from information_schema.tables
where table_schema = 'public';
--------------------
--use indexing;

-- drop table if exists <nom> ( cascade : drop all depandancies | restrict : up exception au cas ou dependance ) 

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) CHECK (status IN ('pending', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25),
(1, '2024-02-01 10:15:00', 'pending', 150.50),
(2, '2024-02-02 12:30:00', 'shipped', 200.00),
(3, '2024-02-03 09:45:00', 'delivered', 99.99),
(4, '2024-02-04 16:00:00', 'cancelled', 300.75),
(1, '2024-02-05 14:20:00', 'pending', 50.00),
(2, '2024-02-06 08:10:00', 'shipped', 120.75),
(3, '2024-02-07 11:25:00', 'delivered', 500.00),
(4, '2024-02-08 15:55:00', 'pending', 75.25);


-- INDEXATION --

--- I- INDEX HASH ( pour l'exactitude)
-- ce ci n'est utiliser que pour la recherche EXACT avec =
-- les operations comme like n'est pas pris comme exactitude meme si vous essayez  customer_id::varchar like '1' ca va pas marcher
-- PROFILING --
--EXPLAIN ANALYSE SELECT * FROM orders WHERE customer_id = 1; -- champs non indexer

/* premier fois
Seq Scan on orders  (cost=0.00..2271.30 rows=3669 width=30) (actual time=0.062..12.403 rows=3649 loops=1)
Filter: (customer_id = 1)
Rows Removed by Filter: 110535
Planning Time: 1.183 ms
Execution Time: 12.730 ms
(5 rows) */

/* deuxiem fois et plus entre 6.7 ~ 8
Seq Scan on orders  (cost=0.00..2271.30 rows=3669 width=30) (actual time=0.008..6.653 rows=3649 loops=1)
Filter: (customer_id = 1)
Rows Removed by Filter: 110535
Planning Time: 0.047 ms
Execution Time: 6.776 ms 
(5 rows) */

-- 114000 after indexing
CREATE INDEX idx_customer_id  ON public.orders USING HASH(customer_id);
EXPLAIN ANALYSE SELECT * FROM orders WHERE customer_id = 1;
/*  first time
Bitmap Heap Scan on orders  (cost=104.43..994.30 rows=3669 width=30) (actual time=0.236..3.676 rows=3649 loops=1)
Recheck Cond: (customer_id = 1)
Heap Blocks: exact=206
->  Bitmap Index Scan on idx_customer_id  (cost=0.00..103.52 rows=3669 width=0) (actual time=0.193..0.193 rows=3649 loops=1)
    Index Cond: (customer_id = 1)
Planning Time: 1.242 ms
Execution Time: 4.046 ms
(7 rows) */

/* 2nd time and plus
 Bitmap Heap Scan on orders  (cost=104.43..994.30 rows=3669 width=30) (actual time=0.197..0.842 rows=3649 loops=1)
   Recheck Cond: (customer_id = 1)
   Heap Blocks: exact=206
   ->  Bitmap Index Scan on idx_customer_id  (cost=0.00..103.52 rows=3669 width=0) (actual time=0.117..0.117 rows=3649 loops=1)
         Index Cond: (customer_id = 1)
 Planning Time: 0.053 ms
 Execution Time: 1.013 ms ~ 0.900 ms */

-- B-TREE (INDEXATION par defaut pour toutes les SGBD)
-- b-tree pousse un peu les choses et nous donne une recherche polyvalents quelle n'est pas limiter aux recherches exacte il est plus flexible
-- est plus compacte au niveau memoir le probleme est dans l'insertion des nouveaux coulumn
CREATE INDEX idx_customer_id  ON public.orders USING BTREE(customer_id);
EXPLAIN ANALYSE SELECT * FROM orders WHERE customer_id = 1;

-- EXPLAIN ANALYSE SELECT * FROM orders WHERE customer_id between 1 and 5 ;
----------------------------------------------------------------------------------------------------------------------------------
/*  Bitmap Heap Scan on orders  (cost=210.43..1280.00 rows=15038 width=30) (actual time=0.583..2.035 rows=14695 loops=1)
   Recheck Cond: ((customer_id >= 1) AND (customer_id <= 5))
   Heap Blocks: exact=485
   ->  Bitmap Index Scan on idx_customer_id  (cost=0.00..206.67 rows=15038 width=0) (actual time=0.520..0.520 rows=14695 loops=1)
         Index Cond: ((customer_id >= 1) AND (customer_id <= 5))
 Planning Time: 0.288 ms
 Execution Time: 2.634 ms */

