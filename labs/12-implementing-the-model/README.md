# Module 12 Lab — Implement and Load the Mission Data Model

## Objectives

By the end of this lab you will have:

- Applied Modules 06-08 to implement the mission data model in a real Postgres database
- Created tables, constraints, and indexes exactly as designed
- Loaded sample data and verified it against the model

## Setup

- Your team's hardened DDL from Module 08 (including `client_holdings`)
- Access to a Postgres instance
- The `instruments` table from `shared/enterprise-schema.sql` (reuse the same instrument
  universe rather than inventing new ones)

## Task sheet

### Part A — Create the database

1. Create a new database for the mission model, and run your team's complete Module 08 DDL
   against it.
2. Confirm every table exists with `\dt`, and spot-check at least two tables with `\d`.

### Part B — Load sample data

3. Insert at least three model portfolios (e.g. "Balanced Growth", "Income Focus",
   "Adventurous Growth").
4. For each model portfolio, insert 2-4 `model_portfolio_holdings` rows, referencing real
   instruments from the enterprise schema, with target weights that add up to 100 for each
   portfolio.
5. Insert at least five clients into your mission model's `clients` table (or reuse the
   enterprise schema's clients if your team decided to share that table, reference Module 06's
   design decision).
6. Subscribe each client to a model portfolio via `client_subscriptions`.
7. Insert `client_holdings` rows for at least three clients, showing their actual current
   holdings (which may differ from their subscribed model portfolio's target weights).

### Part C — Verify

8. Write a query joining `model_portfolios`, `model_portfolio_holdings`, and `instruments` that
   shows each portfolio's target composition, readable end to end.
9. Write a query joining `clients`, `client_subscriptions`, and `model_portfolios` showing which
   client is subscribed to which portfolio.
10. Deliberately try to insert a row that violates one of your Module 08 constraints (e.g. a
    `target_weight_pct` over 100). Confirm Postgres rejects it, and note the exact error message.

## Acceptance criteria

- All tables exist in a real Postgres database, matching the Module 08 DDL exactly.
- Sample data is loaded for all five tables, referencing real instruments, and is internally
  consistent (target weights per portfolio sum to something sensible).
- Both verification queries in Part C run correctly and return readable, sensible output.
- You've demonstrated, with a real error message, that at least one constraint rejects bad data.

If you finish early, write a query that shows, for one specific client, their actual holdings
next to their subscribed model portfolio's target weights, side by side, this is a preview of
Module 09's "drift" report, now that real data exists to run it against.
