# Demo: Module 07 — ER Diagrams, Translating Requirements into Schemas

**Duration:** 14 minutes
**Prerequisite:** Module 06's normalized table list for the mission model. Pen/paper or a
shared whiteboard tool.

## Part 1: ER diagram notation (4 min)

Narration: an **ER diagram** (Entity-Relationship diagram) is a standard visual notation for
exactly what Module 06 did in words. Point at the notation legend on the slides:

- A box represents one **entity** (one table)
- Attributes are listed inside the box, with the **primary key** marked (underlined, or listed
  first, convention varies by tool)
- A line between two boxes represents a **relationship**
- Symbols at each end of the line show **cardinality**: exactly one, zero-or-one, one-or-many,
  zero-or-many

This is called **crow's foot notation**, the most common convention, named for what the "many"
symbol looks like.

## Part 2: From table list to ER diagram (4 min)

Take Module 06's final table list and draw it as a proper ER diagram together: `clients`,
`model_portfolios`, `instruments`, `model_portfolio_holdings`, `client_subscriptions`. For each
relationship, state the cardinality out loud before drawing the symbol, "one model portfolio
has many model portfolio holdings, but each holding row belongs to exactly one model
portfolio."

## Part 3: From ER diagram to DDL (5 min)

```sql
CREATE TABLE clients (
    client_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    advisor_id  INTEGER REFERENCES advisors(advisor_id)
);

CREATE TABLE model_portfolios (
    model_portfolio_id  SERIAL PRIMARY KEY,
    name                TEXT NOT NULL
);

CREATE TABLE model_portfolio_holdings (
    model_portfolio_id  INTEGER REFERENCES model_portfolios(model_portfolio_id),
    instrument_id       INTEGER REFERENCES instruments(instrument_id),
    target_weight_pct   NUMERIC(5,2) NOT NULL,
    PRIMARY KEY (model_portfolio_id, instrument_id)
);
```

Narration: **DDL** (Data Definition Language) is the subset of SQL that creates and changes
structure, `CREATE TABLE`, `ALTER TABLE`, and similar, as opposed to querying or modifying data
itself. Point out the direct translation: each entity box becomes a `CREATE TABLE`, each
attribute becomes a column, each relationship becomes a foreign key. A many-to-many
relationship (model portfolios to instruments) becomes a table of its own, with a **composite
primary key** made of both foreign keys together.

## Part 4: What's deliberately missing today (1 min)

Narration: this first-draft DDL has primary keys and foreign keys, the minimum needed to
express the structure, but no `NOT NULL` beyond the obvious, no `CHECK` constraints, no indexes
beyond what the primary keys create automatically. Module 08 adds all of that properly, today
is about getting the shape right first.

## Key message

An ER diagram is a formal, shared language for exactly the thinking Module 06 already did.
Translating it into DDL is close to mechanical once the diagram is right, which is exactly why
getting the diagram right, before writing any SQL, is worth the time it takes.
