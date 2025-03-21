
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


-- Ajoute 100 000 lignes supplémentaires avec un client aléatoire
INSERT INTO orders (customer_id, order_date, status, total_amount)
SELECT (random() * 1000)::int, NOW(), 'pending', random() * 500
FROM generate_series(1, 100000);
