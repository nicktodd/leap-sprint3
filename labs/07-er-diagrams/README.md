# Module 07 Lab — ER Diagram and First-Draft DDL for the Mission Model

## Objectives

By the end of this lab you will have:

- Understood ER (Entity-Relationship) diagram notation
- Translated the mission brief into a proper ER diagram
- Translated that ER diagram into working CREATE TABLE statements (DDL)

## Setup

- [`shared/mission-brief.md`](../../shared/mission-brief.md) from the repo root
- Your team's normalized table list from Module 06
- Paper, a whiteboard, or any diagramming tool your team prefers

## Task sheet

### Part A — Draw the ER diagram

1. Using Module 06's table list (`clients`, `model_portfolios`, `instruments`,
   `model_portfolio_holdings`, `client_subscriptions`), draw a proper ER diagram:
   - One box per entity, with its attributes listed and its primary key marked
   - One line per relationship, with cardinality marked at each end (crow's foot or a written
     "1" / "many" label is fine)
2. Double-check every many-to-many relationship in your diagram has a linking table
   representing it, not a direct line between the two "many" sides.

### Part B — Translate the diagram into DDL

3. Write a `CREATE TABLE` statement for every entity in your diagram.
4. Include a primary key on every table (a composite key for the two linking tables).
5. Include a foreign key for every relationship in your diagram.
6. Don't worry about indexes, `CHECK` constraints, or anything beyond `NOT NULL` on obviously
   required columns yet, that's Module 08.

### Part C — Sanity check against the brief

7. Re-read `shared/mission-brief.md`. For each of the four numbered requirements in the brief,
   point to the specific table(s) and column(s) in your DDL that satisfy it. If you can't point
   to anything, that's a gap worth fixing now, before Module 08 builds on top of it.

## Acceptance criteria

- An ER diagram with all five entities, correctly marked primary keys, and cardinality on every
  relationship.
- Working `CREATE TABLE` DDL for all five tables, with primary and foreign keys in place.
- A written mapping from each of the mission brief's four requirements to the part of your
  schema that satisfies it.

If you finish early, sketch what would need to change in your ER diagram if the brief also
asked for each model portfolio to have one designated "lead advisor," is that a new
relationship, or a new attribute on an existing entity?
