# Module 09 Lab — Structured Problem-Solving: Drift Report

## The requirement
> "Can we get a way to see which of our clients have drifted significantly from their model
> portfolio? We keep finding out about this too late."

---

## 1. Clarifying Questions and Assumptions

| Question | Assumption and Reasoning |
|---|---|
| What counts as "significant" drift? | Assumed: > 5 percentage points above or below target weight for any single instrument. This is a common threshold in the industry and is a concrete, reportable number. |
| Is drift measured per instrument, or per client overall? | Assumed: per instrument within each client's portfolio — a client could be over-weight in equities but under-weight in bonds, and both should show. |
| Should this be a real-time dashboard or a batch report? | Assumed: a batch report (e.g. run nightly), since the concern is "finding out too late", not millisecond alerts. |
| Which date's holdings should we use — today's, or a specific as-of date? | Assumed: the latest `as_of_date` in `client_holdings` for each client. |
| What model portfolio composition should we compare against — current or what the client subscribed to? | Assumed: the composition that was in effect as of the client's most recent subscription date, using `model_portfolio_holdings.effective_from`. |
| Should clients with no holdings be flagged or excluded? | Assumed: excluded — if there are no holdings recorded, there is nothing to compare. |

---

## 2. Entities and Data Needed

All needed data is in the existing schema (no new modelling required):

| Table | Columns Used | Why |
|---|---|---|
| `clients` | `client_id`, `name` | To identify the client in the report |
| `client_subscriptions` | `client_id`, `portfolio_id`, `subscribed_from` | To find which portfolio the client is currently subscribed to (latest row per client) |
| `model_portfolio_holdings` | `portfolio_id`, `instrument_id`, `target_weight_pct`, `effective_from` | To get the target composition as of the subscription date |
| `client_holdings` | `client_id`, `instrument_id`, `quantity`, `as_of_date` | To get the client's actual current holdings |
| `instruments` | `instrument_id`, `ticker`, `name` | For human-readable output in the report |

No new modelling is required. The schema already captures both target weights (with history) and actual holdings. The drift query is expressible as a join + arithmetic calculation.

---

## 3. Modelling Changes

None required. The schema from Module 08 has everything needed:
- `client_subscriptions` gives the current (and historical) portfolio subscription
- `model_portfolio_holdings` gives the target weights (with `effective_from` for point-in-time queries)
- `client_holdings` gives actual current quantities and an `as_of_date`

---

## 4. Approach (Plain English)

For each client:
1. Find their current portfolio subscription (the most recent `subscribed_from` date).
2. Look up that portfolio's target composition as of the subscription date (the most recent `effective_from` on or before the subscription date).
3. Look at the client's actual holdings (the latest `as_of_date`).
4. Calculate each instrument's actual percentage of total portfolio value and compare it to the target weight. The difference is the drift.
5. Flag any client where at least one instrument is more than 5 percentage points above or below its target weight.

---

## 5. Validation Sentence for Compliance

"So, if a client's actual holdings show them 6% above their target weight in the Global Equity fund — for example, 46% actual versus 40% target — that client would appear on this drift report, flagged against that specific instrument. And we'd only flag them if the difference was more than 5 percentage points; smaller deviations would not appear. Is that the right threshold, or did you have a different number in mind?"

---

## Bonus: Draft SQL (Extension Task)

```sql
WITH current_subscriptions AS (
    SELECT DISTINCT ON (client_id)
        client_id, portfolio_id, subscribed_from
    FROM client_subscriptions
    ORDER BY client_id, subscribed_from DESC
),
current_targets AS (
    SELECT DISTINCT ON (cs.client_id, mph.instrument_id)
        cs.client_id,
        mph.portfolio_id,
        mph.instrument_id,
        mph.target_weight_pct
    FROM current_subscriptions cs
    INNER JOIN model_portfolio_holdings mph
        ON mph.portfolio_id = cs.portfolio_id
       AND mph.effective_from <= cs.subscribed_from
    ORDER BY cs.client_id, mph.instrument_id, mph.effective_from DESC
),
holdings_total AS (
    SELECT client_id, SUM(quantity) AS total_quantity
    FROM client_holdings
    GROUP BY client_id
),
holdings_pct AS (
    SELECT ch.client_id, ch.instrument_id,
           ROUND(ch.quantity / ht.total_quantity * 100, 2) AS actual_weight_pct
    FROM client_holdings ch
    INNER JOIN holdings_total ht ON ch.client_id = ht.client_id
)
SELECT c.name AS client_name,
       i.ticker,
       i.name AS instrument_name,
       ct.target_weight_pct,
       hp.actual_weight_pct,
       ROUND(hp.actual_weight_pct - ct.target_weight_pct, 2) AS drift_pct
FROM current_targets ct
INNER JOIN holdings_pct hp
    ON ct.client_id = hp.client_id
   AND ct.instrument_id = hp.instrument_id
INNER JOIN clients c ON ct.client_id = c.client_id
INNER JOIN instruments i ON ct.instrument_id = i.instrument_id
WHERE ABS(hp.actual_weight_pct - ct.target_weight_pct) > 5
ORDER BY ABS(hp.actual_weight_pct - ct.target_weight_pct) DESC;
```
