# Module 13 Lab — Capstone: Extending the Schema for Historical Trade Data

## Objectives

By the end of this lab your team will have:

- Extended the mission schema to accommodate historical trade data
- Confirmed every team member can explain the data model, not just whoever built it
- Written and explained queries against the extended model

## Setup

- Your team's running, loaded mission database from Module 12

## Task sheet

### Part A — Extend the schema

1. Design and create a `client_trades` table: one row per buy or sell event, with a foreign key
   to `clients`, a foreign key to `instruments`, a trade type, quantity, price, and date.
2. Add appropriate constraints (a trade type restricted to BUY/SELL, quantity and price both
   required and positive) and indexes on both foreign keys.
3. Load sample trade history for at least three clients, consistent with their existing
   `client_holdings` rows from Module 12 (their net trades should roughly explain their current
   holding).

### Part B — Every team member explains the model

4. As a team, take turns: each member explains one table (ideally *not* the one they personally
   built or know best) to the rest of the team, in their own words, no notes.
5. If anyone struggles to explain a table, that's useful information now, not a problem to hide,
   spend a few minutes as a team making sure everyone genuinely understands the whole schema.

### Part C — Queries against the extended model

6. Every team member writes **at least one** query against the extended model (not all the same
   query). Ideas: net position per client from trade history, total value traded per client,
   trades within a date range, clients who've never made a SELL trade.
7. Each person explains their own query to the rest of the team, what it answers and how.

## Acceptance criteria

- `client_trades` exists, with appropriate constraints and indexes, and is loaded with data
  consistent with `client_holdings`.
- Every team member has explained at least one table in the schema to the rest of the team.
- Every team member has written and explained at least one query against the extended model.

This is the last hands-on lab of Sprint 3. Module 14 wraps up and prepares you for Friday's
assessment and presentation.
