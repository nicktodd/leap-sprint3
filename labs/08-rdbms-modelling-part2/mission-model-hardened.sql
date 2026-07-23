-- Module 08 Lab — Hardened DDL for the Mission Model
-- Adds NOT NULL, UNIQUE, CHECK constraints, and indexes on FK columns.
-- This DDL is run in the `mission` schema in Module 12.

-- Drop in reverse dependency order if re-running
DROP TABLE IF EXISTS client_holdings;
DROP TABLE IF EXISTS client_subscriptions;
DROP TABLE IF EXISTS model_portfolio_holdings;
DROP TABLE IF EXISTS model_portfolios;
DROP TABLE IF EXISTS instruments;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS advisors;

CREATE TABLE advisors (
    advisor_id  SERIAL PRIMARY KEY,
    name        TEXT NOT NULL
);

CREATE TABLE clients (
    client_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    advisor_id  INTEGER NOT NULL REFERENCES advisors(advisor_id)
);
CREATE INDEX idx_clients_advisor_id ON clients(advisor_id);

CREATE TABLE instruments (
    instrument_id SERIAL PRIMARY KEY,
    ticker        TEXT NOT NULL UNIQUE,   -- UNIQUE in addition to PK: ticker is the natural key used in queries/reports
    name          TEXT NOT NULL,
    asset_class   TEXT NOT NULL,
    currency      TEXT NOT NULL
);

CREATE TABLE model_portfolios (
    portfolio_id SERIAL PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE
);

-- target_weight_pct must be between 0 and 100 (no negative weights, no weight over 100%)
CREATE TABLE model_portfolio_holdings (
    portfolio_id      INTEGER NOT NULL REFERENCES model_portfolios(portfolio_id),
    instrument_id     INTEGER NOT NULL REFERENCES instruments(instrument_id),
    target_weight_pct NUMERIC(5,2) NOT NULL CHECK (target_weight_pct >= 0 AND target_weight_pct <= 100),
    effective_from    DATE NOT NULL,
    PRIMARY KEY (portfolio_id, instrument_id, effective_from)
);
CREATE INDEX idx_mph_portfolio_id   ON model_portfolio_holdings(portfolio_id);
CREATE INDEX idx_mph_instrument_id  ON model_portfolio_holdings(instrument_id);
-- effective_from indexed because drift reports filter "as of" a given date
CREATE INDEX idx_mph_effective_from ON model_portfolio_holdings(effective_from);

CREATE TABLE client_subscriptions (
    client_id       INTEGER NOT NULL REFERENCES clients(client_id),
    portfolio_id    INTEGER NOT NULL REFERENCES model_portfolios(portfolio_id),
    subscribed_from DATE NOT NULL,
    PRIMARY KEY (client_id, subscribed_from)
);
CREATE INDEX idx_cs_client_id    ON client_subscriptions(client_id);
CREATE INDEX idx_cs_portfolio_id ON client_subscriptions(portfolio_id);

-- Part A: client_holdings table (closes the gap from Module 07)
-- PK is (client_id, instrument_id): a client holds at most one quantity per instrument at any time.
-- quantity must be >= 0 (you cannot hold a negative quantity of an instrument)
CREATE TABLE client_holdings (
    client_id     INTEGER NOT NULL REFERENCES clients(client_id),
    instrument_id INTEGER NOT NULL REFERENCES instruments(instrument_id),
    quantity      NUMERIC(18,6) NOT NULL CHECK (quantity >= 0),
    as_of_date    DATE NOT NULL,
    PRIMARY KEY (client_id, instrument_id)
);
CREATE INDEX idx_ch_client_id     ON client_holdings(client_id);
CREATE INDEX idx_ch_instrument_id ON client_holdings(instrument_id);

-- Index reasoning:
-- Additional index added: model_portfolio_holdings.effective_from — drift reports will
-- commonly filter or sort by this to find the current or point-in-time composition.
--
-- Column deliberately NOT indexed: model_portfolio_holdings.target_weight_pct
-- This column is unlikely to be used as a filter (queries don't typically say
-- "find all instruments with weight between X and Y") and has low cardinality
-- (many portfolios share the same weight values). An index here would rarely be used
-- by the query planner and would add write overhead for no benefit.
