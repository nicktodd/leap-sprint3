# Module 08 Lab — Harden the Mission Model with Keys, Indexes & Constraints

## Objectives

By the end of this lab you will have:

- Reviewed and confirmed primary and foreign keys on every table
- Added indexes where they genuinely help, and explained why elsewhere they wouldn't
- Added NOT NULL, UNIQUE, and CHECK constraints to enforce correctness at the database level
- Closed Module 07's known gap: a table for a client's actual current holdings

## Setup

- Module 07's first-draft DDL for the mission model
- Access to a Postgres instance to actually run and test your DDL

## Task sheet

### Part A — Close the gap

1. Add a `client_holdings` table: `client_id` (FK to `clients`), `instrument_id` (FK to
   `instruments`), `quantity`, and `as_of_date`. Decide what the primary key should be, and
   justify your choice.

### Part B — Constraints

2. Add `NOT NULL` to every column that should always have a value (be specific about which,
   and why, for each table).
3. Add a `UNIQUE` constraint on `instruments.ticker`, even though `instrument_id` is already the
   primary key. Explain in one sentence why both are useful.
4. Add a `CHECK` constraint on `model_portfolio_holdings.target_weight_pct` so it can only be
   between 0 and 100.
5. Add a `CHECK` constraint on `client_holdings.quantity` so it can never be negative.

### Part C — Indexes

6. Add an index on every foreign key column across your schema (Postgres doesn't create these
   automatically, unlike for primary keys).
7. Identify one column, beyond the foreign keys, that you'd index because it's likely to be
   filtered or joined on often (for example, something used in a common report). Justify your
   choice.
8. Identify one column you would **not** index, and explain why, using what you learned about
   when indexes don't help.

### Part D — Prove it works

9. Run your complete, updated DDL against a real Postgres database.
10. Try to insert a row that violates one of your constraints (e.g. a `target_weight_pct` of
    150), confirm Postgres rejects it, and note the actual error message.

## Acceptance criteria

- `client_holdings` exists, with a justified primary key choice.
- Every table has appropriate `NOT NULL`, and the two specified `CHECK` constraints are in
  place and working.
- Every foreign key column has an index.
- You've named one additional column worth indexing and one you'd deliberately leave unindexed,
  both with reasoning.
- You've demonstrated, with a real error message, that at least one constraint actually rejects
  bad data.

If you finish early, add a `CHECK` constraint ensuring `client_holdings.as_of_date` can't be in
the future, what's a scenario where that constraint might turn out to be wrong?
