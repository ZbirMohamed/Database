CREATE TABLE payement (
    id SERIAL PRIMARY KEY,
    pay INT,
    user_id INT
) PARTITION BY HASH (id);


BEGIN;

CREATE TABLE payement_part_1 PARTITION OF payement
    FOR VALUES WITH (MODULUS 5, REMAINDER 0);

CREATE TABLE payement_part_2 PARTITION OF payement
    FOR VALUES WITH (MODULUS 5, REMAINDER 1);

CREATE TABLE payement_part_3 PARTITION OF payement
    FOR VALUES WITH (MODULUS 5, REMAINDER 2);

CREATE TABLE payement_part_4 PARTITION OF payement
    FOR VALUES WITH (MODULUS 5, REMAINDER 3);

CREATE TABLE payement_part_5 PARTITION OF payement
    FOR VALUES WITH (MODULUS 5, REMAINDER 4);

INSERT INTO payement (pay,user_id)
SELECT
    (random() * 10000 + 1000 ) as pay,
    (random() * 1000 ) as user_id
FROM generate_series(1,1000000);

COMMIT;


----------------------- PARTIE ANALYSE --------------------------

EXPLAIN ANALYSE SELECT * FROM payement where id= 42;
---------------------------- RESULTAT ---------------------------

/*
    Seul la partition contenant l'id est selectionnez
 Index Scan using payement_part_5_pkey on payement_part_5 payement  (cost=0.42..8.44 rows=1 width=12) (actual time=0.020..0.021 rows=1 loops=1)
   Index Cond: (id = 42)
 Planning Time: 0.169 ms
 Execution Time: 0.041 ms
(4 rows)
 */
-----------------------------------------------------------------