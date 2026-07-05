-- Module 07 Lab — First-Draft DDL for the Mission Model (Instructor Reference)
-- Deliberately minimal: PKs and FKs only. Module 08 adds indexes, CHECK
-- constraints, and anything beyond the obvious NOT NULLs.

CREATE TABLE clients (
    client_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    advisor_id  INTEGER REFERENCES advisors(advisor_id)
);

CREATE TABLE model_portfolios (
    model_portfolio_id  SERIAL PRIMARY KEY,
    name                TEXT NOT NULL
);

CREATE TABLE instruments (
    instrument_id  SERIAL PRIMARY KEY,
    ticker         TEXT NOT NULL,
    name           TEXT NOT NULL
);

CREATE TABLE model_portfolio_holdings (
    model_portfolio_id  INTEGER REFERENCES model_portfolios(model_portfolio_id),
    instrument_id       INTEGER REFERENCES instruments(instrument_id),
    target_weight_pct   NUMERIC(5,2) NOT NULL,
    PRIMARY KEY (model_portfolio_id, instrument_id)
);

CREATE TABLE client_subscriptions (
    client_id           INTEGER REFERENCES clients(client_id),
    model_portfolio_id  INTEGER REFERENCES model_portfolios(model_portfolio_id),
    subscribed_date      DATE NOT NULL,
    PRIMARY KEY (client_id, model_portfolio_id, subscribed_date)
);
-- Note: subscribed_date is part of the key here because the mission brief
-- asks us to keep subscription HISTORY (a client can change portfolios over
-- time), not just their current one. A simpler (client_id, model_portfolio_id)
-- key would only allow one subscription ever per client/portfolio pair.
