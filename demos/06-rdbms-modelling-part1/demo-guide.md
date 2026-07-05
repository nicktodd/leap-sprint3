# Demo: Module 06 — RDBMS Modelling Part 1, Entities, Relationships & Normalization

**Duration:** 14 minutes
**Prerequisite:** `shared/messy-flat-file.csv` and `shared/mission-brief.md` from the repo root.
No SQL needed today, this is pen-and-paper (or whiteboard) modelling.

## Part 1: Entities, relationships, cardinality (4 min)

Narration: an **entity** is a real-world thing worth its own table, a Client, a Model Portfolio,
an Instrument. A **relationship** connects two entities; **cardinality** describes how many of
one relate to how many of the other.

Point at the diagram. Using the mission brief's domain:

- A Client subscribes to **one** Model Portfolio at a time, but a Model Portfolio can have
  **many** Clients subscribed, a one-to-many relationship, from the portfolio's perspective.
- A Model Portfolio contains **many** Instruments, and an Instrument can appear in **many**
  different Model Portfolios, a many-to-many relationship.

Narration: many-to-many relationships can't be represented directly in a relational database,
they always need a linking table in between, exactly what you'll build today.

## Part 2: Reading the messy flat file (2 min)

Open `shared/messy-flat-file.csv`. Point out the repetition: "Balanced Growth" and its
instruments appear on multiple rows, once per client subscribed to it. "Alice Johnson" and her
advisor's name repeat once per instrument in her portfolio. This redundancy is the symptom;
normalization is the cure.

## Part 3: Normalizing, step by step (6 min)

**1NF (First Normal Form)**: every column holds a single, atomic value, no repeating groups
within one row. The flat file already satisfies this, each row has one client, one instrument,
one weight. The problem isn't 1NF, it's what comes next.

**2NF (Second Normal Form)**: every non-key column must depend on the *whole* key, not part of
it. If we treated (client_name, instrument_ticker) as a composite key, `target_weight_pct`
actually depends only on (model_portfolio_name, instrument_ticker), not on the client at all,
a **partial dependency**. That's a 2NF violation, worth splitting `model_portfolio_holdings`
out on its own.

**3NF (Third Normal Form)**: no non-key column may depend on another non-key column
(a **transitive dependency**). `client_advisor` depends on `client_name`, not directly on
whatever we chose as the row's key, and `instrument_name` depends on `instrument_ticker`, not
on the row itself. Both need their own tables.

Narration: walk through the diagram showing the four resulting tables: `clients`,
`model_portfolios`, `instruments`, `model_portfolio_holdings` (linking model portfolios to
instruments with a weight), and `client_subscriptions` (linking clients to model portfolios with
a date). This maps directly onto the mission brief's entities.

## Part 4: Normalization vs denormalization (2 min)

Narration: normalized tables minimise redundancy and the risk of inconsistent data (change an
advisor's name once, not in fifty repeated rows). The cost is more joins to answer a question.
**Denormalization** (deliberately duplicating data) trades that consistency risk for query
speed, common in OLAP/reporting systems (Module 01), rare in OLTP systems like this one, where
correctness usually matters more than raw read speed.

## Key message

Normalization isn't a checklist to complete for its own sake, it's a direct response to a
specific problem: redundant data that can go inconsistent. Every step (1NF, 2NF, 3NF) removes
one specific kind of redundancy. Today's normalized table list becomes Module 07's ER diagram,
Module 08's keys and constraints, and Module 12's actual Postgres implementation.
