# Demo: Module 04 — Advanced SQL Part 1, Joins & Aggregation

**Duration:** 14 minutes
**Prerequisite:** Enterprise schema loaded, including Nadia Farouk (client 11, no accounts yet).

## Part 1: INNER JOIN (3 min)

```sql
SELECT c.name AS client_name, a.name AS advisor_name
FROM clients c
INNER JOIN advisors a ON c.advisor_id = a.advisor_id;
```

Narration: `INNER JOIN` returns only rows where the join condition matches on both sides. Every
client here has an advisor, so this returns all 11 clients. Point at the diagram: only the
overlap between the two tables comes back.

## Part 2: LEFT JOIN, and why Nadia matters (4 min)

```sql
SELECT c.name AS client_name, a.account_id, a.account_type
FROM clients c
LEFT JOIN accounts a ON c.client_id = a.client_id
ORDER BY c.name;
```

Narration: run this and scroll to Nadia Farouk. Her `account_id` and `account_type` come back
`NULL`, but she still appears in the results, because `LEFT JOIN` keeps every row from the left
table (`clients`) regardless of whether a match exists on the right. Contrast with what would
happen if this were an `INNER JOIN`, run that version too, and show Nadia disappears entirely.

This is the single most important thing to take from this module: **`LEFT JOIN` is how you find
things that are missing**, a client with no account, an order with no shipment, and so on.

## Part 3: RIGHT JOIN and FULL JOIN, briefly (2 min)

```sql
SELECT c.name, a.account_id
FROM clients c
RIGHT JOIN accounts a ON c.client_id = a.client_id;

SELECT c.name, a.account_id
FROM clients c
FULL JOIN accounts a ON c.client_id = a.client_id;
```

Narration: `RIGHT JOIN` is the mirror image of `LEFT JOIN`, keep everything from the right table.
In practice, most people write every query as a `LEFT JOIN` and just reorder the tables, rather
than reaching for `RIGHT JOIN`, worth mentioning as a stylistic convention, not a hard rule.
`FULL JOIN` keeps everything from both sides, matched or not, less common but useful when you
need to see mismatches on either side at once.

## Part 4: GROUP BY, HAVING, and aggregates (4 min)

```sql
SELECT advisor_id, COUNT(*) AS client_count
FROM clients
GROUP BY advisor_id
ORDER BY client_count DESC;

SELECT advisor_id, COUNT(*) AS client_count
FROM clients
GROUP BY advisor_id
HAVING COUNT(*) >= 3;
```

Narration, pointing at the execution-order diagram: `WHERE` filters individual rows before
grouping happens; `HAVING` filters *groups*, after `GROUP BY` has run, using the aggregate
result itself. You cannot write `WHERE COUNT(*) >= 3`, `COUNT(*)` doesn't exist yet at the point
`WHERE` runs.

## Part 5: A first look at window functions (1 min)

```sql
SELECT name, joined_date,
       RANK() OVER (ORDER BY joined_date) AS join_order
FROM clients;
```

Narration: a window function computes something across a set of rows *without* collapsing them
into one row per group, unlike `GROUP BY`. Just a first taste today, worth recognising the
shape (`OVER (...)`) rather than mastering it, you'll get more practice with these in Module 05
and beyond as queries get more advanced.

## Key message

Joins are how separate tables become one answer. `LEFT JOIN` in particular is how you find gaps,
missing accounts, missing orders, missing anything, and `HAVING` is `WHERE` for the aggregated
result rather than the raw rows.
