# Demo: Module 13 — Capstone, Extending the Schema for Historical Trade Data

**Duration:** 12 minutes
**Prerequisite:** Module 12's running, loaded mission database.

## Part 1: Framing the capstone (2 min)

Narration: `client_holdings` is a **snapshot**, it tells you what a client holds *right now*, as
of one date. It says nothing about *how they got there*. A new request has come in: "we need to
see the trade history behind a client's current position", exactly the kind of extension
`shared/mission-brief.md` flagged as coming later, back in Module 06.

## Part 2: Designing the extension (3 min)

Point at the diagram: one new table, `client_trades`, an **event log**, one row per buy or sell,
in contrast to `client_holdings`'s snapshot. Structurally, it looks a lot like the enterprise
schema's `transactions` table, same idea, scoped to the mission model's own clients.

```sql
CREATE TABLE client_trades (
    trade_id       SERIAL PRIMARY KEY,
    client_id      INTEGER NOT NULL REFERENCES clients(client_id),
    instrument_id  INTEGER NOT NULL REFERENCES instruments(instrument_id),
    trade_type     TEXT NOT NULL CHECK (trade_type IN ('BUY', 'SELL')),
    quantity       NUMERIC(14,4) NOT NULL CHECK (quantity > 0),
    price          NUMERIC(14,4) NOT NULL CHECK (price > 0),
    trade_date     DATE NOT NULL
);
CREATE INDEX idx_client_trades_client_id ON client_trades(client_id);
CREATE INDEX idx_client_trades_instrument_id ON client_trades(instrument_id);
```

Narration: this is entirely Modules 07-08's skills again, an entity, foreign keys, `CHECK`
constraints (a trade quantity or price of zero or negative makes no sense), and indexes on both
foreign keys. Nothing new to learn, everything to apply.

## Part 3: Trades accumulate into holdings (3 min)

Narration, pointing at the second diagram: a sequence of trades (buy 100, buy 50, sell 20)
accumulates into a net position (130). `client_holdings` should, in principle, reflect exactly
what `client_trades`' history adds up to, if it doesn't, that's worth investigating, not
ignoring.

```sql
SELECT instrument_id,
       SUM(CASE WHEN trade_type = 'BUY' THEN quantity ELSE -quantity END) AS net_quantity
FROM client_trades
WHERE client_id = 1
GROUP BY instrument_id;
```

## Part 4: Every team member explains it (2 min)

Narration: this capstone's real point isn't the schema change, it's making sure the whole team
understands the *whole* model, not just whoever originally built it. Have each team member, in
turn, explain one part of the schema (not necessarily the part they personally wrote) to the
rest of the team, in their own words.

## Key message

A capstone isn't about new technical content, it's proving the team can extend their own design
under a new requirement, and that every member, not just the original author, actually
understands what was built and why.
