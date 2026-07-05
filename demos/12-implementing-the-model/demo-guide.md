# Demo: Module 12 — Implementing the Data Model in Postgres

**Duration:** 10 minutes
**Prerequisite:** Module 08's hardened DDL for the mission model. A Postgres instance to run it
against. No new concepts today, this is execution.

## Part 1: Framing the task (1 min)

Narration: Modules 06-08 designed, diagrammed, and hardened a schema entirely on paper (or in a
`.sql` file that's never actually been run). Today it becomes a real, running database, with
real data in it, verified to actually work the way the design intended.

## Part 2: Create the database and run the DDL (3 min)

```sql
CREATE DATABASE mission_portfolio;
\c mission_portfolio
\i create-tables-final.sql
\dt
```

Narration: nothing new here, this is Module 02's `\c` and `\i` again, and Module 08's DDL,
unchanged. Point out `\dt` confirming every table actually exists now, not just in a file.

## Part 3: Load sample data (3 min)

```sql
INSERT INTO model_portfolios (name) VALUES
    ('Balanced Growth'), ('Income Focus'), ('Adventurous Growth');

INSERT INTO model_portfolio_holdings (model_portfolio_id, instrument_id, target_weight_pct)
VALUES (1, 7, 40), (1, 6, 30), (1, 8, 30);
```

Narration: reference real instrument IDs from the enterprise schema's `instruments` table
(shared across this whole sprint), rather than inventing new ones, this is deliberately the same
instrument universe the enterprise schema already established.

## Part 4: Verify it against the model (3 min)

```sql
SELECT mp.name, i.ticker, mph.target_weight_pct
FROM model_portfolio_holdings mph
JOIN model_portfolios mp ON mph.model_portfolio_id = mp.model_portfolio_id
JOIN instruments i ON mph.instrument_id = i.instrument_id
ORDER BY mp.name;

-- Confirm a constraint actually rejects bad data:
INSERT INTO model_portfolio_holdings (model_portfolio_id, instrument_id, target_weight_pct)
VALUES (1, 5, 150);
-- ERROR: new row for relation "model_portfolio_holdings" violates check constraint
```

Narration: the join confirms the data is structurally correct and readable back out sensibly,
exactly the "does it work the way we designed it" check. The deliberate bad insert confirms the
`CHECK` constraint from Module 08 is actually doing its job, not just sitting unused in the
DDL.

## Key message

A schema isn't real until it's been created, loaded, and proven to reject the bad data it was
designed to reject. This module is the moment three days of design work becomes a database
someone could actually build an application against.
