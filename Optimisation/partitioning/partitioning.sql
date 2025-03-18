-- PARTIE PARTITIONING --
DROP TABLE IF EXISTS utilisateurs;
CREATE TABLE utilisateurs (
    id SERIAL ,
    nom VARCHAR(50),
    email VARCHAR(100),
    age INT not null
)PARTITION BY RANGE (age);

------ PAR PLAGE (  RANGE PARTITIONING   ) ----
BEGIN;
DROP INDEX IF EXISTS idx_age;

CREATE INDEX idx_age ON utilisateurs (age);

CREATE TABLE utilisateurs_18_moins PARTITION OF utilisateurs
    FOR VALUES FROM(1) TO (18);

CREATE TABLE utilisateurs_between_19_and_30 PARTITION OF utilisateurs
    FOR VALUES FROM(18) TO (30);

CREATE TABLE utilisateurs_between_31_and_50 PARTITION of utilisateurs
    FOR VALUES FROM(30) TO (50);

CREATE TABLE utilisateurs_between_51_and_70 PARTITION of utilisateurs
    FOR VALUES FROM(50) TO (70);
-- postgres ne cree pas automatiquement une partition qui prend les valeurs par défaut
-- il faut alors la crée nous meme
-- puisqu'on traite les valeur de 18 a 70
-- la table par défaut va prendre soin des ages sup a 70
CREATE TABLE utilisateurs_beyond_70 PARTITION of utilisateurs
    FOR VALUES FROM(70) to (120) ;
COMMIT;
