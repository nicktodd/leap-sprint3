-- Module 05 Lab: Production-Grade Queries, Subqueries and CTEs

-- 1. Scalar subquery: every BUY transaction with a price above the average BUY price.
SELECT *
FROM transactions
WHERE txn_type = 'BUY'
  AND price > (
      SELECT AVG(price)
      FROM transactions
      WHERE txn_type = 'BUY'
  );

-- 2. Correlated subquery: every account alongside the date of its most recent transaction.
-- This subquery must run once per account because it references the outer ac.account_id,
-- so the MAX(txn_date) is computed separately for each account row in the outer query.
SELECT ac.account_id, ac.account_type,
       (SELECT MAX(t.txn_date)
        FROM transactions t
        WHERE t.account_id = ac.account_id) AS most_recent_txn
FROM accounts ac
ORDER BY ac.account_id;

-- 3. CTE: clients whose total BUY value is above the average total BUY value.
WITH client_buy_totals AS (
    SELECT c.client_id, c.name,
           SUM(t.quantity * t.price) AS total_buy_value
    FROM clients c
    INNER JOIN accounts ac ON c.client_id = ac.client_id
    INNER JOIN transactions t ON ac.account_id = t.account_id
    WHERE t.txn_type = 'BUY'
    GROUP BY c.client_id, c.name
)
SELECT name, total_buy_value
FROM client_buy_totals
WHERE total_buy_value > (SELECT AVG(total_buy_value) FROM client_buy_totals)
ORDER BY total_buy_value DESC;

-- 4. Same result as task 3, using a derived table instead of a CTE.
SELECT cbt.name, cbt.total_buy_value
FROM (
    SELECT c.client_id, c.name,
           SUM(t.quantity * t.price) AS total_buy_value
    FROM clients c
    INNER JOIN accounts ac ON c.client_id = ac.client_id
    INNER JOIN transactions t ON ac.account_id = t.account_id
    WHERE t.txn_type = 'BUY'
    GROUP BY c.client_id, c.name
) AS cbt
WHERE cbt.total_buy_value > (
    SELECT AVG(sub.total_buy_value)
    FROM (
        SELECT c2.client_id,
               SUM(t2.quantity * t2.price) AS total_buy_value
        FROM clients c2
        INNER JOIN accounts ac2 ON c2.client_id = ac2.client_id
        INNER JOIN transactions t2 ON ac2.account_id = t2.account_id
        WHERE t2.txn_type = 'BUY'
        GROUP BY c2.client_id
    ) AS sub
)
ORDER BY cbt.total_buy_value DESC;
