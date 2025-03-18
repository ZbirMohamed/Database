
--- on suppose que cette table est notre table prod qui est tout le temps en utilisation et qui necessite un partitionement
-- pour ameliorer l'etat
/* CREATE TABLE transactions (
    id SERIAL,
    transaction_date DATE,
    region TEXT,
    amount DECIMAL
) */
BEGIN;

-- 1 - changer le nom de la table
ALTER TABLE transactions RENAME TO transactions_legacy;

-- 2 - changer les nom des index
-- ALTER INDEX idx_x RENAME TO idx_x_legacy;

-- 3 - cree une table identique a celle qu'on veut partitioner

CREATE TABLE transactions (
    id SERIAL,
    transaction_date DATE,
    region TEXT,
    amount DECIMAL
)
PARTITION BY RANGE(transaction_date);

-- 4- cree les index
--CREATE INDEX idx_x ON transactions (x)

-- 5- cree les partitions
CREATE TABLE transactions_2024 PARTITION OF transactions
    FOR VALUES FROM ('2024-01-01') TO ('2025-03-01');

DO $$
DECLARE earliest DATE;
DECLARE latest DATE;
BEGIN

SELECT min(transaction_date) INTO earliest FROM transactions;
latest := '2025-03-01'::DATE;


-- hack => !!!!! SEULEMENT SI NOUS SOMMES SURE DE NOS DONNéES
-- on ajoute une contrainte de check pour dire que nos données sont aligne avec le besoin
ALTER TABLE transactions_legacy
ADD CONSTRAINT daily_transaction
CHECK (transaction_date>= earliest  AND transaction_date < latest )
NOT VALID;

-- on ajoute cette update pour bypasser les checks ligne par ligne
--- (20TB de check c'est catastrophique)
-- !!!!  A NE JAMAIS TOUCHER LA TABLE PG_CONSTRAINT ca peut cree des probs 
UPDATE pg_constraint
SET convalidated = true
WHERE conname = 'daily_transaction';

-- ici on attache nos données et apres on vas les inserets dans notre nouvelle bdd
ALTER TABLE transactions
ATTACH PARTITION transactions_legacy
FOR VALUES FROM (earliest) TO (latest);

END;

$$ LANGUAGE PLPGSQL;
COMMIT;

--- maintenant faut bouger les données mais a notre vitesse --- 
--- ici on supprime et on insert on meme temps
WITH rows AS (
    DELETE FROM transactions_legacy  t
    WHERE (transaction_date >= '2020-01-01' AND transaction_date < '2021-01-01')
    RETURNING t.*)
INSERT INTO transactions SELECT * FROM rows;





