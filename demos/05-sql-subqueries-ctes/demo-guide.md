# Demo: Module 05 — Advanced SQL Part 2, Subqueries, CTEs & Derived Tables

**Duration:** 14 minutes
**Prerequisite:** Enterprise schema loaded. GitHub Copilot Chat available.

## Part 1: A scalar subquery (3 min)

```sql
SELECT transaction_id, account_id, price
FROM transactions
WHERE txn_type = 'BUY'
  AND price > (SELECT AVG(price) FROM transactions WHERE txn_type = 'BUY');
```

Narration: the subquery in parentheses runs once, produces a single value (a scalar), and the
outer query compares every row against that one value. This is a **scalar subquery**.

## Part 2: A correlated subquery (3 min)

```sql
SELECT account_id,
       (SELECT MAX(txn_date) FROM transactions t2
        WHERE t2.account_id = accounts.account_id) AS last_txn_date
FROM accounts;
```

Narration: the inner query references `accounts.account_id`, a column from the *outer* query.
That means this subquery can't run once and be reused, it has to run **once per outer row**,
each time using that row's `account_id`. This is a **correlated subquery**. Point out the
performance implication: for a large table, that's a lot of repeated work, worth knowing before
reaching for one on a big dataset.

## Part 3: The same question, as a CTE (4 min)

```sql
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
```

Narration: a **CTE** (Common Table Expression, the `WITH ... AS (...)` block) names an
intermediate result so the rest of the query can refer to it like a table. Point out this CTE
is referenced *twice*, once in the main `FROM`, once inside the subquery computing the average,
Postgres can reuse the same named result rather than you having to repeat the whole join logic
twice.

## Part 4: The same thing again, as a derived table (2 min)

```sql
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
```

Narration: a **derived table** is the same idea, a subquery used in place of a table, but written
inline in `FROM` rather than named up front with `WITH`. Ask the room: which version was easier
to read? The CTE version names the intermediate result once and reuses it; the derived table
version has to repeat the whole join logic a second time to compute the average. This is the
practical trade-off: CTEs usually win on readability the moment you need the same intermediate
result more than once.

## Part 5: GenAI, propose then critique (2 min)

Ask Copilot Chat to propose an alternative formulation of the CTE query from Part 3. Read
whatever it comes back with, then ask as a group: is this actually clearer, or just different?
A common outcome: Copilot proposes a version using a window function instead of a second
aggregate pass, which can be genuinely more efficient, but isn't automatically more *readable*
to someone less familiar with window functions. Clearer and different aren't the same thing,
that's the judgement call this module is really practising.

## Key message

Subqueries, CTEs, and derived tables can all produce the same result. The choice between them is
almost always about **readability and reuse**, not correctness, and that's a genuine engineering
judgement call, not a fact to memorise.
