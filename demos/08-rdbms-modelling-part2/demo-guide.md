# Demo: Module 08 — RDBMS Modelling Part 2, Keys, Indexes & Constraints

**Duration:** 14 minutes
**Prerequisite:** Module 07's first-draft DDL for the mission model.

## Part 1: Primary keys and foreign keys, properly (2 min)

Narration: a **primary key** uniquely identifies a row, and Postgres enforces that uniqueness
automatically, no two rows can share one. A **foreign key** references another table's primary
key, and Postgres enforces that the referenced row actually exists, you cannot insert a
`client_subscriptions` row pointing at a `model_portfolio_id` that doesn't exist. Both of these
you've already used since Module 07; today's about the *other* things a schema needs beyond
just structure.

## Part 2: Indexes, when they help (4 min)

```sql
EXPLAIN SELECT * FROM transactions WHERE account_id = 4;
```

Narration: without an index, Postgres has to check every single row (a **sequential scan**) to
find matches. With an index on `account_id`, it can jump almost directly to the matching rows.
Point at the diagram: a sequential scan checks every row in order; an index scan uses a
pre-built structure to go straight to what's needed.

```sql
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
```

Narration: primary keys get an index automatically. Foreign key columns generally **don't**,
Postgres won't create one for you, worth adding explicitly whenever you'll filter or join on
that column often, which for a foreign key is almost always.

## Part 3: Indexes, when they don't help (2 min)

Narration: an index isn't free. Every `INSERT`/`UPDATE`/`DELETE` has to update every index on
that table too, so an index that's rarely used for reads is pure write-cost with no read
benefit. Indexes also help less on tiny tables (a sequential scan of 20 rows is already fast)
and on columns with very few distinct values (an index on a boolean column rarely helps, half
the table matches either value anyway).

## Part 4: Constraints (4 min)

```sql
CREATE TABLE model_portfolio_holdings (
    model_portfolio_id  INTEGER NOT NULL REFERENCES model_portfolios(model_portfolio_id),
    instrument_id       INTEGER NOT NULL REFERENCES instruments(instrument_id),
    target_weight_pct   NUMERIC(5,2) NOT NULL CHECK (target_weight_pct BETWEEN 0 AND 100),
    PRIMARY KEY (model_portfolio_id, instrument_id)
);
```

Narration, naming each: `NOT NULL` rejects a missing value outright. `UNIQUE` rejects a
duplicate value in a column that isn't the primary key (e.g. an instrument's `ticker` should
probably be unique even though `instrument_id` is the primary key). `CHECK` rejects a value
outside a stated rule, here, a weight outside 0-100 doesn't make sense and the database itself
now refuses it, rather than relying on application code to catch it. The foreign key constraint
(the `REFERENCES` clause) is itself a constraint, rejecting a reference to a row that doesn't
exist.

## Part 5: Closing Module 07's gap (2 min)

Narration: Module 07 left a known gap, no table for a client's actual current holdings. Today's
lab has you add `client_holdings`, with the same rigour: a primary key, foreign keys to
`clients` and `instruments`, `NOT NULL` on `quantity`, and a `CHECK` that quantity isn't
negative.

## Key message

A schema with correct structure (Module 07) but no constraints will happily store bad data,
Postgres won't stop a negative holding or an impossible weight unless you tell it to. Indexes
and constraints are how the database itself, not just application code, enforces correctness
and keeps queries fast as data grows.
