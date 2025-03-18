DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL,
    nom VARCHAR(50),
    email VARCHAR(100),
    age INT NOT NULL,
    pays VARCHAR(50) NOT NULL
) PARTITION BY LIST (pays);

BEGIN;

DROP INDEX IF EXISTS idx_pays;
CREATE INDEX idx_pays ON users (pays);

CREATE TABLE users_france PARTITION OF users
  FOR VALUES IN ('france');

CREATE TABLE users_maroc PARTITION OF users
  FOR VALUES IN ('maroc');

CREATE TABLE users_usa PARTITION OF users
  FOR VALUES IN ('usa');

CREATE TABLE users_algerie PARTITION OF users
  FOR VALUES IN ('algerie');

CREATE TABLE users_default PARTITION OF users
  FOR VALUES IN ('Autre');

INSERT INTO users (nom,email,age,pays)
SELECT 
    'user_' || gs as nom,
    'user' || gs || '@gmail.com' as email,
    (random() * 60 + 18 )::INT as age,
    CASE 
        WHEN (random() * 100 ) between 0 and 30 THEN 'france'
        WHEN (random() * 100 ) between 31 and 60 THEN 'maroc'
        WHEN (random() * 100 ) between 61 and 80 THEN 'usa'
        WHEN (random() * 100 ) between 81 and 100 THEN 'algerie'
        ELSE 'Autre'
    END AS pays
FROM generate_series(1,1000000) as gs;

COMMIT;

--- PARTIE ANALYSE ----

EXPLAIN ANALYZE SELECT * FROM users WHERE pays = 'france';

-----------------------  RESULTAT --------------------------
/*  

  Comme vous le constater postgres pruning nous permet de retirer les données de la partition adéquate au lieu de scanner toutes une table
  
Seq Scan on users_france users  (cost=0.00..6809.30 rows=299784 width=46) (actual time=0.009..36.461 rows=299784 loops=1)
   Filter: ((pays)::text = 'france'::text)
 Planning Time: 0.579 ms
 Execution Time: 46.469 ms
(4 rows)
------------------------------------------------------------
*/
EXPLAIN ANALYZE select * from users where pays =  'france' or pays = 'maroc'  ;
/*
-----------------------------------------------------------------------------------------------------------------------------------
De meme ici les deux partition sont choisi

 Append  (cost=0.00..17829.02 rows=590101 width=46) (actual time=0.009..108.029 rows=590101 loops=1)
   ->  Seq Scan on users_france users_1  (cost=0.00..7558.76 rows=299784 width=46) (actual time=0.008..36.728 rows=299784 loops=1)
         Filter: (((pays)::text = 'france'::text) OR ((pays)::text = 'maroc'::text))
   ->  Seq Scan on users_maroc users_2  (cost=0.00..7319.76 rows=290317 width=45) (actual time=0.010..37.979 rows=290317 loops=1)
         Filter: (((pays)::text = 'france'::text) OR ((pays)::text = 'maroc'::text))
 Planning Time: 0.571 ms
 Execution Time: 125.052 ms
(7 rows) 
*/



