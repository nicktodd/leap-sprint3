-- Module 07 Lab — First-Draft DDL for the Mission Model (PaySprint Wealth)
-- This is a clean first draft with PKs and FKs but without hardening (no indexes, no CHECKs).
-- Hardening is done in Module 08.

-- Drop in reverse dependency order if re-running
DROP TABLE IF EXISTS client_holdings;
DROP TABLE IF EXISTS client_subscriptions;
DROP TABLE IF EXISTS model_portfolio_holdings;
DROP TABLE IF EXISTS model_portfolios;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS advisors;

CREATE TABLE advisors (
    advisor_id   SERIAL PRIMARY KEY,
    name         TEXT NOT NULL
);

CREATE TABLE clients (
    client_id    SERIAL PRIMARY KEY,
    name         TEXT NOT NULL,
    advisor_id   INTEGER REFERENCES advisors(advisor_id)
);

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    ticker        TEXT NOT NULL,
    name          TEXT NOT NULL,
    asset_class   TEXT,
    currency      TEXT
);

CREATE TABLE model_portfolios (
    portfolio_id  SERIAL PRIMARY KEY,
    name          TEXT NOT NULL
);

-- model_portfolio_holdings: which instruments and at what weight a portfolio targets.
-- effective_from supports point-in-time history (the composition can change over time).
CREATE TABLE model_portfolio_holdings (
    portfolio_id      INTEGER NOT NULL REFERENCES model_portfolios(portfolio_id),
    instrument_id     INTEGER NOT NULL REFERENCES instruments(instrument_id),
    target_weight_pct NUMERIC(5,2) NOT NULL,
    effective_from    DATE NOT NULL,
    PRIMARY KEY (portfolio_id, instrument_id, effective_from)
);

-- client_subscriptions: which portfolio a client is subscribed to, and since when.
-- subscribed_from supports history (a client can change portfolio over time).
CREATE TABLE client_subscriptions (
    client_id      INTEGER NOT NULL REFERENCES clients(client_id),
    portfolio_id   INTEGER NOT NULL REFERENCES model_portfolios(portfolio_id),
    subscribed_from DATE NOT NULL,
    PRIMARY KEY (client_id, subscribed_from)
);

-- client_holdings: a client's actual current quantity of each instrument.
CREATE TABLE client_holdings (
    client_id     INTEGER NOT NULL REFERENCES clients(client_id),
    instrument_id INTEGER NOT NULL REFERENCES instruments(instrument_id),
    quantity      NUMERIC(18,6) NOT NULL,
    as_of_date    DATE NOT NULL,
    PRIMARY KEY (client_id, instrument_id)
);

-- ER Diagram (text representation):
--
-- advisors ----< clients >---- client_subscriptions >---- model_portfolios
--                                                              |
--                                                    model_portfolio_holdings
--                                                              |
-- client_holdings >---- instruments <--------------------------+
--     |
-- clients (again — client_holdings.client_id -> clients)

-- Sanity check against mission brief requirements:
-- 1. Model portfolio composition with history → model_portfolio_holdings (portfolio_id, instrument_id, target_weight_pct, effective_from)
-- 2. Client subscription history → client_subscriptions (client_id, portfolio_id, subscribed_from)
-- 3. Client actual current holdings → client_holdings (client_id, instrument_id, quantity, as_of_date)
-- 4. Drift report (holdings vs target weights) → JOIN client_holdings to client_subscriptions
--    to get current portfolio, then JOIN model_portfolio_holdings to compare target_weight_pct
--    against actual quantities.
