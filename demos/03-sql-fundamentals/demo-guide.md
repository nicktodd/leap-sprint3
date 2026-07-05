# Demo: Module 03 — SQL Fundamentals Refresher

**Duration:** 10 minutes
**Prerequisite:** Enterprise schema loaded from Module 02.

## Part 1: SELECT, WHERE, ORDER BY (4 min)

```sql
SELECT name, risk_profile FROM clients;

SELECT name, risk_profile
FROM clients
WHERE risk_profile = 'Cautious';

SELECT name, joined_date
FROM clients
WHERE joined_date >= '2020-01-01'
ORDER BY joined_date DESC;
```

Narration, pointing at the query-anatomy diagram: you *write* a query in the order SELECT, FROM,
WHERE, ORDER BY, but Postgres *executes* it in a different order: FROM first (find the rows),
then WHERE (filter them), then SELECT (pick the columns), then ORDER BY (sort what's left).
This is why you can't reference a column alias from SELECT inside the same query's WHERE
clause, at the point WHERE runs, SELECT hasn't happened yet.

## Part 2: Combining conditions (2 min)

```sql
SELECT name FROM clients
WHERE risk_profile = 'Balanced' AND joined_date < '2020-01-01';

SELECT name FROM clients
WHERE risk_profile IN ('Cautious', 'Balanced');

SELECT name, date_of_birth FROM clients
WHERE date_of_birth BETWEEN '1960-01-01' AND '1980-12-31';
```

## Part 3: NULL, the beginner trap (4 min)

```sql
SELECT * FROM transactions WHERE price = NULL;   -- returns NOTHING, always
SELECT * FROM transactions WHERE price IS NULL;  -- the correct way
```

Narration: `NULL` means "unknown," not "empty" or "zero." Comparing anything to `NULL` with `=`
doesn't return true or false, it returns *unknown*, which is treated as not-matching in a
`WHERE` clause. This is such a common beginner mistake it's worth demonstrating live: run the
`= NULL` version first, watch it silently return zero rows (no error, which is the dangerous
part), then show `IS NULL` returning the deposit/withdrawal rows correctly.

## Key message

Clear, simple queries are the baseline everything else this week builds on. `SELECT`/`WHERE`/
`ORDER BY` and correct `NULL` handling aren't "basic" in the sense of unimportant, getting them
wrong silently (no error, just a wrong or empty result) is one of the most common sources of bad
data downstream.
