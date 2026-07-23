-- Module 04 Lab: Joins and Aggregation Against the Enterprise Schema
-- NOTE: Nadia Farouk (client 11) is already in the schema with no accounts.

-- 1. INNER JOIN: list every client's name alongside their advisor's name.
SELECT c.name AS client_name, a.name AS advisor_name
FROM clients c
INNER JOIN advisors a ON c.advisor_id = a.advisor_id;

-- 2a. LEFT JOIN: list every client's name alongside any account they have.
-- Nadia Farouk appears with NULL account columns.
SELECT c.name AS client_name, ac.account_id, ac.account_type
FROM clients c
LEFT JOIN accounts ac ON c.client_id = ac.client_id
ORDER BY c.name;

-- 2b. INNER JOIN version: Nadia Farouk disappears.
-- An INNER JOIN only returns rows where the join condition matches on BOTH sides,
-- so clients with no accounts are excluded entirely.
SELECT c.name AS client_name, ac.account_id, ac.account_type
FROM clients c
INNER JOIN accounts ac ON c.client_id = ac.client_id
ORDER BY c.name;

-- 3. Three-table join: account ID and type, client name, advisor name.
SELECT ac.account_id, ac.account_type, c.name AS client_name, a.name AS advisor_name
FROM accounts ac
INNER JOIN clients c ON ac.client_id = c.client_id
INNER JOIN advisors a ON c.advisor_id = a.advisor_id
ORDER BY ac.account_id;

-- 4. GROUP BY: for each advisor, count how many clients they manage.
SELECT a.name AS advisor_name, COUNT(c.client_id) AS client_count
FROM advisors a
INNER JOIN clients c ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, a.name
ORDER BY client_count DESC;

-- 5. HAVING: advisors managing three or more clients.
SELECT a.name AS advisor_name, COUNT(c.client_id) AS client_count
FROM advisors a
INNER JOIN clients c ON a.advisor_id = c.advisor_id
GROUP BY a.advisor_id, a.name
HAVING COUNT(c.client_id) >= 3
ORDER BY client_count DESC;

-- 6. Total value of all BUY transactions per account, highest first.
SELECT t.account_id, SUM(t.quantity * t.price) AS total_buy_value
FROM transactions t
WHERE t.txn_type = 'BUY'
GROUP BY t.account_id
ORDER BY total_buy_value DESC;

-- 7. Window function: client name and join date, with RANK() by join date.
SELECT name, joined_date,
       RANK() OVER (ORDER BY joined_date ASC) AS join_rank
FROM clients
ORDER BY join_rank;
