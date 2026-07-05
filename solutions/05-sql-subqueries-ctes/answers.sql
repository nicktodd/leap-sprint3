-- Module 05 Lab — Reference Answers (Instructor Reference)

-- 1. Scalar subquery
SELECT transaction_id, account_id, price
FROM transactions
WHERE txn_type = 'BUY'
  AND price > (SELECT AVG(price) FROM transactions WHERE txn_type = 'BUY');

-- 2. Correlated subquery
SELECT account_id,
       (SELECT MAX(txn_date) FROM transactions t2
        WHERE t2.account_id = accounts.account_id) AS last_txn_date
FROM accounts;
-- This runs once per row in `accounts`, because the inner query references
-- accounts.account_id, a value that only exists for the "current" outer row.
-- A plain scalar subquery has no such reference, so it can run once, overall.

-- 3. CTE version
WITH client_buy_totals AS (
    SELECT c.client_id, c.name, SUM(t.quantity * t.price) AS total_buy_value
    FROM clients c
    JOIN accounts a ON c.client_id = a.client_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.txn_type = 'BUY'
    GROUP BY c.client_id, c.name
)
SELECT *
FROM client_buy_totals
WHERE total_buy_value > (SELECT AVG(total_buy_value) FROM client_buy_totals);

-- 4. Derived table version (same result, no WITH clause)
SELECT *
FROM (
    SELECT c.client_id, c.name, SUM(t.quantity * t.price) AS total_buy_value
    FROM clients c
    JOIN accounts a ON c.client_id = a.client_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.txn_type = 'BUY'
    GROUP BY c.client_id, c.name
) client_buy_totals
WHERE total_buy_value > (
    SELECT AVG(total_buy_value) FROM (
        SELECT c.client_id, SUM(t.quantity * t.price) AS total_buy_value
        FROM clients c
        JOIN accounts a ON c.client_id = a.client_id
        JOIN transactions t ON a.account_id = t.account_id
        WHERE t.txn_type = 'BUY'
        GROUP BY c.client_id
    ) x
);
-- Same result as task 3, but the join logic is duplicated to compute the
-- average, because a plain derived table (unlike a CTE) has no name that
-- can be reused elsewhere in the same query.

-- Finish-early extension: the same result via window functions
WITH per_txn AS (
    SELECT c.client_id, c.name,
           SUM(t.quantity * t.price) OVER (PARTITION BY c.client_id) AS total_buy_value
    FROM clients c
    JOIN accounts a ON c.client_id = a.client_id
    JOIN transactions t ON a.account_id = t.account_id
    WHERE t.txn_type = 'BUY'
),
with_avg AS (
    SELECT DISTINCT client_id, name, total_buy_value,
           AVG(total_buy_value) OVER () AS avg_total_buy_value
    FROM per_txn
)
SELECT client_id, name, total_buy_value
FROM with_avg
WHERE total_buy_value > avg_total_buy_value;
-- Note this still needed two CTEs (a window function's result can't be
-- filtered on in the same SELECT that computes it), arguably *more*
-- machinery than task 3's single CTE with a subquery average, a good
-- discussion example of "different" not automatically meaning "simpler."
