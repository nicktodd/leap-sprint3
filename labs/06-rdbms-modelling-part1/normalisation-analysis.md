# Module 06 Lab — Normalisation Analysis

## 1. Entities and Relationships

From `messy-flat-file.csv` and `mission-brief.md`:

| Entity | Description |
|---|---|
| Client | An individual with an account at PaySprint Wealth |
| Advisor | The advisor who manages a client |
| ModelPortfolio | A named, managed mix of instruments (e.g. "Balanced Growth") |
| Instrument | A tradeable asset (e.g. GLBEQ1, CORPB1) |
| ModelPortfolioHolding | The target weight of an instrument within a model portfolio (the composition, which can change over time) |
| ClientSubscription | Which model portfolio a client is subscribed to, and since when (can change over time) |
| ClientHolding | A client's actual current quantity of each instrument held |

### Cardinality

- Client → Advisor: many-to-one (each client has one advisor; one advisor manages many clients)
- Client → ClientSubscription: one-to-many (a client can have a history of subscriptions)
- ClientSubscription → ModelPortfolio: many-to-one (each subscription row references one model portfolio)
- ModelPortfolio → ModelPortfolioHolding: one-to-many (one portfolio has many instrument weight rows)
- ModelPortfolioHolding → Instrument: many-to-one (many portfolios can include the same instrument)
- Client → ClientHolding: one-to-many (a client holds many instruments)
- ClientHolding → Instrument: many-to-one (many clients can hold the same instrument)

## 2. Examples of Redundancy in the Flat File

**Example 1 — Advisor name stored on every client row**  
`client_advisor` ("Priya Shah") appears on every row belonging to Alice Johnson (3 rows) and Carla Mendes (3 rows). If Priya Shah changed her name, all 6 rows would need updating. If even one row were missed, reports would show two different names for the same person — a classic update anomaly.

**Example 2 — Instrument name stored on every portfolio row**  
`instrument_name` ("Global Equity Index Fund") appears on every row that includes GLBEQ1, regardless of which client or portfolio it belongs to. If the instrument was renamed, every row containing that ticker would need updating. A partial update would leave some rows with the old name and some with the new name, making it impossible to know which is correct.

## 3. First Normal Form (1NF)

The flat file already satisfies 1NF:
- Every column contains a single, atomic value (no comma-separated lists, no repeating groups)
- Each row represents one fact: a single instrument's target weight in a single client's current model portfolio

A 1NF violation would have looked like a column such as `instruments = "GLBEQ1, CORPB1, CASHGBP"` (a list in one cell) or a spreadsheet with columns `instrument_1`, `instrument_2`, `instrument_3` (repeating groups).

## 4. Second Normal Form (2NF) — Removing Partial Dependencies

The flat file's implicit composite key is `(client_name, instrument_ticker)` (each row identifies which client holds which instrument in their current portfolio).

Partial dependencies (columns that depend on only part of the composite key):
- `client_advisor` depends only on `client_name`, not on `instrument_ticker` → move to a `clients` table
- `model_portfolio_name` depends only on `client_name` (via their subscription) → move to a `client_subscriptions` table
- `instrument_name` depends only on `instrument_ticker` → move to an `instruments` table
- `target_weight_pct` depends on `(model_portfolio_name, instrument_ticker)`, not on `client_name` → move to a `model_portfolio_holdings` table

After 2NF, `subscribed_date` is the only remaining non-key column on the subscription row.

## 5. Third Normal Form (3NF) — Removing Transitive Dependencies

After 2NF, check for transitive dependencies (non-key column depending on another non-key column):
- `client_advisor` in the clients table: advisor details would depend on the advisor, not the client. Splitting advisors into their own `advisors` table and storing only `advisor_id` on the client removes the transitive dependency.
- No other transitive dependencies remain after the 2NF splits.

## 6. Final Table List (3NF)

| Table | Columns | Primary Key |
|---|---|---|
| advisors | advisor_id, name | advisor_id |
| clients | client_id, name, advisor_id (FK) | client_id |
| instruments | instrument_id, ticker, name, asset_class, currency | instrument_id |
| model_portfolios | portfolio_id, name | portfolio_id |
| model_portfolio_holdings | portfolio_id (FK), instrument_id (FK), target_weight_pct, effective_from | (portfolio_id, instrument_id, effective_from) |
| client_subscriptions | client_id (FK), portfolio_id (FK), subscribed_from | (client_id, subscribed_from) |
| client_holdings | client_id (FK), instrument_id (FK), quantity, as_of_date | (client_id, instrument_id) |

Each table is in 3NF: every non-key column depends on the whole key and nothing but the key.
