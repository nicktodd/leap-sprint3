# Module 14 — Sprint 3 Wrap-up & Assessment Notes

## Assessment Checklist Status

### SQL Fundamentals (Modules 03-05)

- [x] SELECT/WHERE/ORDER BY queries — written and running in `03-sql-fundamentals/queries.sql`
- [x] IS NULL vs = NULL — query 8 in lab 03 uses IS NULL correctly; column is NOT NULL in schema so returns 0 rows, but this is correct behaviour
- [x] LEFT JOIN vs INNER JOIN — lab 04 query 2 demonstrates Nadia Farouk appearing only in LEFT JOIN; one-sentence explanation included in the SQL comment
- [x] CTE vs derived table — both written in lab 05, produce identical output; readability comparison in the SQL comments

### Data Modelling (Modules 06-08)

- [x] 1NF/2NF/3NF with concrete examples — `06-rdbms-modelling-part1/normalisation-analysis.md`
- [x] ER diagram for mission model — text ER in `07-er-diagrams/mission-model-draft.sql`; formal diagram to be drawn on paper or in a tool during the session
- [x] Primary and foreign keys — viewable live with `\d mission.<tablename>` in psql
- [x] CHECK constraint rejecting bad data — demonstrated in labs 12 and 13 with real error messages

**Lab 12 constraint error:**
```
ERROR:  new row for relation "model_portfolio_holdings" violates check constraint
"model_portfolio_holdings_target_weight_pct_check"
DETAIL:  Failing row contains (1, 5, 150.00, 2026-01-01).
```

**Lab 13 constraint error:**
```
ERROR:  new row for relation "client_trades" violates check constraint "client_trades_trade_type_check"
DETAIL:  Failing row contains (15, 1, 1, DIVIDEND, 100.000000, 1.0000, 2026-01-01).
```

### Beyond Relational (Modules 09-11)

- [x] Five-step structured problem-solving — `09-structured-problem-solving/answers.md` (clarify, identify entities, decide modelling changes, sketch approach, validate)
- [x] Classifying new scenarios — `10-nosql-overview/answers.md` (key-value, columnar, document)
- [x] Snowflake storage/compute separation — `11-snowflake-overview/BLOCKED.md` (conceptual answer included; lab blocked without Snowflake account)

### The Mission Model (Modules 12-13)

- [x] Mission database running and queryable in leapdb `mission` schema
- [x] `client_trades` table exists with constraints and sample data consistent with `client_holdings` (net BUY-SELL = holdings quantity, verified by query output)
- [x] Schema explanation — every table has inline SQL comments explaining its purpose and key design decisions

## Known Gaps / Issues Found

1. **Schema mismatch in lab 03 README**: The README uses `joined_on` (the column is actually `joined_date`), `type` on transactions (actually `txn_type`), and `type` on accounts (actually `account_type`). This is a bug in the lab materials.

2. **Lab 03 query 8 returns 0 rows**: The README implies some transactions should have a NULL `instrument_id`, but all transactions in the enterprise schema have an instrument — including DEPOSIT and WITHDRAWAL rows. The query is correct (uses IS NULL); the sample data just doesn't exercise this case.

3. **Lab 11 is blocked**: No Snowflake account available. Conceptual answers written to BLOCKED.md.

4. **Lab 05 is a pair exercise**: Tasks 5 (peer review) and 6 (GenAI critique) require a partner and GitHub Copilot; marked as needing completion during the in-person session.
