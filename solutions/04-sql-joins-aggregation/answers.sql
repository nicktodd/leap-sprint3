-- Module 04 Lab — Reference Answers (Instructor Reference)

-- 1. INNER JOIN: client and advisor names
SELECT c.name AS client_name, a.name AS advisor_name
FROM clients c
INNER JOIN advisors a ON c.advisor_id = a.advisor_id;

-- 2. LEFT JOIN finding a gap
SELECT c.name AS client_name, acc.account_id, acc.account_type
FROM clients c
LEFT JOIN accounts acc ON c.client_id = acc.client_id
ORDER BY c.name;
-- Nadia Farouk appears with account_id and account_type both NULL.

SELECT c.name AS client_name, acc.account_id, acc.account_type
FROM clients c
INNER JOIN accounts acc ON c.client_id = acc.client_id
ORDER BY c.name;
-- Nadia Farouk does not appear at all: INNER JOIN only returns rows where
-- both sides match, and she has no matching row in accounts.

-- 3. Three-table join
SELECT acc.account_id, acc.account_type, c.name AS client_name, adv.name AS advisor_name
FROM accounts acc
JOIN clients c ON acc.client_id = c.client_id
JOIN advisors adv ON c.advisor_id = adv.advisor_id;

-- 4. GROUP BY: clients per advisor
SELECT advisor_id, COUNT(*) AS client_count
FROM clients
GROUP BY advisor_id
ORDER BY client_count DESC;

-- 5. HAVING: advisors with 3+ clients
SELECT advisor_id, COUNT(*) AS client_count
FROM clients
GROUP BY advisor_id
HAVING COUNT(*) >= 3
ORDER BY client_count DESC;

-- 6. Total BUY value per account
SELECT account_id,
       SUM(quantity * price) AS total_buy_value
FROM transactions
WHERE txn_type = 'BUY'
GROUP BY account_id
ORDER BY total_buy_value DESC;

-- 7. First window function: join order by rank
SELECT name, joined_date,
       RANK() OVER (ORDER BY joined_date) AS join_order
FROM clients
ORDER BY join_order;

-- Finish-early extension: BUY and SELL value side by side, per account
SELECT account_id,
       SUM(CASE WHEN txn_type = 'BUY'  THEN quantity * price ELSE 0 END) AS total_buy_value,
       SUM(CASE WHEN txn_type = 'SELL' THEN quantity * price ELSE 0 END) AS total_sell_value
FROM transactions
WHERE txn_type IN ('BUY', 'SELL')
GROUP BY account_id
ORDER BY account_id;
-- Requires a conditional aggregate (CASE inside SUM) rather than a plain
-- WHERE + SUM, because both totals now need to appear in the same row.
