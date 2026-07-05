-- Module 08 Lab — Hardened Mission Model DDL (Instructor Reference)
-- Assumes `advisors` already exists (reused from the enterprise schema).

CREATE TABLE clients (
    client_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    advisor_id  INTEGER NOT NULL REFERENCES advisors(advisor_id)
);
CREATE INDEX idx_clients_advisor_id ON clients(advisor_id);

CREATE TABLE model_portfolios (
    model_portfolio_id  SERIAL PRIMARY KEY,
    name                TEXT NOT NULL UNIQUE
);

CREATE TABLE instruments (
    instrument_id  SERIAL PRIMARY KEY,
    ticker         TEXT NOT NULL UNIQUE,
    name           TEXT NOT NULL
);

CREATE TABLE model_portfolio_holdings (
    model_portfolio_id  INTEGER NOT NULL REFERENCES model_portfolios(model_portfolio_id),
    instrument_id       INTEGER NOT NULL REFERENCES instruments(instrument_id),
    target_weight_pct   NUMERIC(5,2) NOT NULL CHECK (target_weight_pct BETWEEN 0 AND 100),
    PRIMARY KEY (model_portfolio_id, instrument_id)
);
CREATE INDEX idx_mph_instrument_id ON model_portfolio_holdings(instrument_id);

CREATE TABLE client_subscriptions (
    client_id           INTEGER NOT NULL REFERENCES clients(client_id),
    model_portfolio_id  INTEGER NOT NULL REFERENCES model_portfolios(model_portfolio_id),
    subscribed_date      DATE NOT NULL,
    PRIMARY KEY (client_id, model_portfolio_id, subscribed_date)
);
CREATE INDEX idx_cs_model_portfolio_id ON client_subscriptions(model_portfolio_id);

-- Part A: closing Module 07's gap
CREATE TABLE client_holdings (
    client_id      INTEGER NOT NULL REFERENCES clients(client_id),
    instrument_id  INTEGER NOT NULL REFERENCES instruments(instrument_id),
    quantity       NUMERIC(14,4) NOT NULL CHECK (quantity >= 0),
    as_of_date     DATE NOT NULL,
    PRIMARY KEY (client_id, instrument_id, as_of_date)
);
-- Primary key rationale: a client can hold the same instrument as of different
-- dates over time (this is a snapshot, not a running total), so client_id +
-- instrument_id alone isn't unique enough, as_of_date must be part of the key.
CREATE INDEX idx_ch_instrument_id ON client_holdings(instrument_id);

-- Part C.7: an additional index worth adding
-- Reporting on a client's current holdings vs their model portfolio's target
-- (the mission brief's core report) will filter client_holdings by client_id
-- and the most recent as_of_date constantly. client_id is already indexed as
-- part of the primary key, but a report frequently querying "most recent
-- as_of_date per client" benefits from:
CREATE INDEX idx_ch_client_asof ON client_holdings(client_id, as_of_date DESC);

-- Part C.8: a column deliberately NOT indexed
-- model_portfolios.name is UNIQUE (so it already has an index from that
-- constraint), but a column like clients.name would NOT be worth a
-- dedicated index here: this schema is small, name is rarely the sole
-- filter in a query (usually joined via client_id instead), and free-text
-- name search would need a different kind of index entirely (e.g. a trigram
-- index), not a plain B-tree.
