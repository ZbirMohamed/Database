---- Insertion Partie Range ----
INSERT INTO utilisateurs (nom, email, age)
SELECT 
    'Utilisateur_' || gs AS nom,
    'user' || gs || '@example.com' AS email,
    (random() * 60 + 18)::INT AS age  
FROM generate_series(1, 1000000) AS gs;
---- Insertion Partie List ----
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
    END AS pays
FROM generate_series(1,1000000) as gs;
---- Insertion Partie Hash ----