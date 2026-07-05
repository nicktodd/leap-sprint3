# Module 06 Lab — Normalized Schema (Instructor Reference)

## Entities and relationships

- **Client**: subscribes to one Model Portfolio at a time (one-to-many, from the portfolio's
  side: one portfolio, many clients)
- **Model Portfolio**: contains many Instruments, each Instrument can appear in many Model
  Portfolios (many-to-many, needs a linking table)
- **Instrument**: independent of any one client or portfolio

## Redundancy examples

- `client_advisor` ("Priya Shah") repeats on every row for a client with multiple instrument
  holdings in their portfolio. If Priya changed her name, or a client were reassigned to a
  different advisor, every one of that client's rows would need updating, miss one and the data
  is now inconsistent.
- `target_weight_pct` for a given (model portfolio, instrument) pair repeats once per client
  subscribed to that portfolio. If "Balanced Growth" rebalanced from 40% to 35% global equity,
  every subscribed client's rows would need the same update applied consistently.

## 1NF

The flat file already satisfies 1NF: every column holds a single atomic value (one client name,
one instrument ticker, one weight), no repeating groups or multi-valued fields within a single
row. A 1NF violation would look like a single row listing multiple instruments in one comma-
separated cell, e.g. `instrument_tickers: "GLBEQ1, CORPB1, CASHGBP"`.

## 2NF: removing partial dependencies

Treating (client_name, instrument_ticker) as a rough composite key, `target_weight_pct` and
`model_portfolio_name` both actually depend only on which model portfolio and instrument are
involved, not on the client at all, a **partial dependency** on the key. Split into:

```
model_portfolio_holdings (model_portfolio_id, instrument_id, target_weight_pct)
```

## 3NF: removing transitive dependencies

`client_advisor` depends on `client_name`, not on the row's key. `instrument_name` depends on
`instrument_ticker`, not on the row's key. Both are **transitive dependencies**, split out:

```
clients (client_id, name, advisor_id)
instruments (instrument_id, ticker, name)
```

## Final table list (3NF)

```
clients (client_id, name, advisor_id)
model_portfolios (model_portfolio_id, name)
instruments (instrument_id, ticker, name)
model_portfolio_holdings (model_portfolio_id, instrument_id, target_weight_pct)
client_subscriptions (client_id, model_portfolio_id, subscribed_date)
```

`model_portfolio_holdings` and `client_subscriptions` are both linking tables resolving the
many-to-many relationships identified in step 1. This maps directly onto `shared/mission-
brief.md`'s known entities list, this exercise has effectively derived it from the data rather
than being handed it.

## What to check as an instructor

- Delegates correctly identify that the flat file is *already* 1NF, a common mistake is
  assuming any denormalized-looking table automatically violates 1NF, it doesn't, 1NF is about
  atomicity, not redundancy.
- The 2NF and 3NF splits are justified with the *specific* dependency being removed, not just
  "this feels like it should be its own table."
- `client_subscriptions` includes `subscribed_date`, this is what lets Module 13's capstone
  later track subscription history, worth flagging now even though it's not the focus yet.
