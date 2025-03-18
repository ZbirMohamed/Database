DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    id SERIAL,
    transaction_date DATE,
    region TEXT,
    amount DECIMAL
) PARTITION BY RANGE (transaction_date);

BEGIN;

DROP INDEX IF EXISTS idx_date;
CREATE INDEX idx_date ON transactions (transaction_date);

CREATE TABLE transactions_2024 PARTITION OF transactions
    FOR VALUES FROM ('2024-01-01') TO ('2025-03-01')
    PARTITION BY LIST (region);

CREATE TABLE transactions_2024_us PARTITION OF transactions_2024
    FOR VALUES IN ('US');

CREATE TABLE transactions_2024_europe PARTITION OF transactions_2024
    FOR VALUES IN ('Europe');

INSERT INTO transactions (transaction_date,region,amount)
SELECT 
    (CURRENT_DATE - MAKE_INTERVAL(days => FLOOR(random() * 100)::int))::date as transaction_date, -- cree un interval de temps random
    CASE 
        WHEN gs % 2 = 0 THEN 'US'
        WHEN gs % 2 != 0 THEN 'Europe'
        ELSE 'Autre'
    END AS region,
    random() * 1000 + 10000 as amount
FROM generate_series(1,1000000) as gs;
COMMIT;


------- ANALYSE --------------

EXPLAIN ANALYSE SELECT * FROM transactions WHERE  region = 'Europe'  AND transaction_date  BETWEEN '2024-01-01' AND '2024-03-01' ;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    Puisque on cherche entre deux date on cherche alors dans les 2 sous partition

 Append  (cost=0.42..16.89 rows=2 width=25) (actual time=0.054..0.055 rows=0 loops=1)
   ->  Index Scan using transactions_2024_europe_transaction_date_idx on transactions_2024_europe transactions_1  (cost=0.42..8.44 rows=1 width=27) (actual time=0.035..0.035 rows=0 loops=1)
         Index Cond: ((transaction_date >= '2024-01-01'::date) AND (transaction_date <= '2024-03-01'::date))
   ->  Index Scan using transactions_2024_us_transaction_date_idx on transactions_2024_us transactions_2  (cost=0.42..8.44 rows=1 width=23) (actual time=0.018..0.018 rows=0 loops=1)
         Index Cond: ((transaction_date >= '2024-01-01'::date) AND (transaction_date <= '2024-03-01'::date))
 Planning Time: 1.590 ms
 Execution Time: 0.118 ms
(7 rows)
 */
EXPLAIN ANALYSE SELECT * FROM transactions WHERE  region = 'Europe'  AND transaction_date  BETWEEN '2024-01-01' AND '2024-03-01' ;

/*
    Par contre ici on cherche dans une seul sous partition celle de l'europe
  Index Scan using transactions_2024_europe_transaction_date_idx on transactions_2024_europe transactions  (cost=0.42..8.44 rows=1 width=27) (actual time=0.036..0.036 rows=0 loops=1)
   Index Cond: ((transaction_date >= '2024-01-01'::date) AND (transaction_date <= '2024-03-01'::date))
   Filter: (region = 'Europe'::text)
 Planning Time: 0.122 ms
 Execution Time: 0.090 ms
(5 rows)
 */