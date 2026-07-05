# Module 10 Lab — Choosing the Right Store

## Objectives

By the end of this lab you will have:

- Classified three scenarios by the data store model that best fits each
- Justified each choice with a specific reason tied to the scenario, not a general preference
- Recognised where NoSQL (document, key-value, or columnar) patterns fit alongside relational systems

## Setup

- None, this is a discussion and written-justification exercise

## Task sheet

For each scenario, decide: relational, document store, key-value store, or columnar store?
Justify with a specific reason drawn from the scenario's actual access pattern, not a general
statement about NoSQL being "faster" or relational being "safer."

### Scenario 1: Session storage for PaySprint Mobile's login system

Every time a customer logs in, the app needs to store a session token and check it on every
subsequent request, for as long as tens of thousands of customers are logged in at once, with
lookups needing to complete in a few milliseconds. Sessions expire automatically after a period
of inactivity. Nothing about a session needs to be queried except "does this token exist and
is it still valid."

### Scenario 2: A market-data ingestion pipeline

An external feed pushes millions of individual price ticks per second, across thousands of
instruments, each tick just a timestamp, an instrument ID, and a price. The main access pattern
is "give me instrument X's price history over this time range," almost never "give me
everything about this one tick alongside a dozen other related facts."

### Scenario 3: PaySprint Wealth's client-facing "financial goals" feature

Clients can set up personal financial goals (e.g. "save for a house deposit," "retirement
planning," "children's education"), and each type of goal captures genuinely different details:
a house deposit goal needs a target amount and a target date; a retirement goal needs a target
retirement age and expected monthly income; an education goal needs a number of years and an
estimated annual cost. New goal types get added periodically as the product evolves.

## Acceptance criteria

- All three scenarios have a stated store type (relational, document, key-value, or columnar).
- Each justification is specific to that scenario's actual access pattern, not a generic
  NoSQL-vs-relational statement.
- You can explain, for at least one scenario, what would go wrong (or just become awkward) if
  you'd chosen a different store type instead.

If you finish early, discuss: could scenario 1 (session storage) also work reasonably well as a
simple table in the mission model's own Postgres database? What would make that a bad idea at
scale, even though it would work fine in this week's small teaching dataset?
