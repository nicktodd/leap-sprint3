# Module 04 Lab — Joins and Aggregation Against the Enterprise Schema

## Objectives

By the end of this lab you will have:

- Written INNER, LEFT, RIGHT, and FULL joins, and explained when each is appropriate
- Used GROUP BY and HAVING to produce an aggregated report
- Written a first, simple window function

## Setup

- The enterprise schema, loaded in Module 02 (now including Nadia Farouk, client 11, who has
  no accounts yet)

## Task sheet

1. **INNER JOIN**: list every client's name alongside their advisor's name.

2. **LEFT JOIN, finding a gap**: list every client's name alongside any account they have
   (account ID and type). Confirm Nadia Farouk appears in your results with `NULL` account
   columns. Then rewrite the same query as an `INNER JOIN` and confirm she disappears entirely.
   Write one sentence explaining why.

3. **A three-table join**: list every account's ID and type, alongside the client's name who
   owns it and that client's advisor's name. (Hint: this needs two joins.)

4. **GROUP BY**: for each advisor, count how many clients they manage. Order the result from
   most clients to fewest.

5. **HAVING**: from the previous query, keep only advisors managing three or more clients.

6. **A small aggregated report**: for each account, calculate the total value of all `BUY`
   transactions on that account (`quantity * price`, summed). Order by total value, highest
   first. This is your "specific business question" report for this module.

7. **A first window function**: list every client's name and join date, alongside a `RANK()`
   showing the order they joined in (earliest = 1).

## Acceptance criteria

- The LEFT JOIN vs INNER JOIN comparison in task 2 correctly shows Nadia Farouk appearing only
  in the LEFT JOIN version, with a one-sentence explanation of why.
- The three-table join in task 3 runs correctly and returns sensible results.
- Task 6's report correctly aggregates `BUY` transaction value per account.
- The window function in task 7 runs without error and produces a sensible ranking.

If you finish early, adapt task 6 to also show total `SELL` value per account alongside the
`BUY` total, in the same query, what changes about how you'd need to structure it?
