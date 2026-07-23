-- Module 12 Lab — Implement the Mission Model in the `mission` schema of leapdb
-- Creates the mission schema, all tables (hardened DDL from Module 08), loads sample data.

-- Create schema
DROP SCHEMA IF EXISTS mission CASCADE;
CREATE SCHEMA mission;

-- Tables

CREATE TABLE mission.advisors (
    advisor_id  SERIAL PRIMARY KEY,
    name        TEXT NOT NULL
);

CREATE TABLE mission.clients (
    client_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    advisor_id  INTEGER NOT NULL REFERENCES mission.advisors(advisor_id)
);
CREATE INDEX idx_clients_advisor_id ON mission.clients(advisor_id);

CREATE TABLE mission.instruments (
    instrument_id SERIAL PRIMARY KEY,
    ticker        TEXT NOT NULL UNIQUE,
    name          TEXT NOT NULL,
    asset_class   TEXT NOT NULL,
    currency      TEXT NOT NULL
);

CREATE TABLE mission.model_portfolios (
    portfolio_id SERIAL PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE
);

CREATE TABLE mission.model_portfolio_holdings (
    portfolio_id      INTEGER NOT NULL REFERENCES mission.model_portfolios(portfolio_id),
    instrument_id     INTEGER NOT NULL REFERENCES mission.instruments(instrument_id),
    target_weight_pct NUMERIC(5,2) NOT NULL CHECK (target_weight_pct >= 0 AND target_weight_pct <= 100),
    effective_from    DATE NOT NULL,
    PRIMARY KEY (portfolio_id, instrument_id, effective_from)
);
CREATE INDEX idx_mph_portfolio_id   ON mission.model_portfolio_holdings(portfolio_id);
CREATE INDEX idx_mph_instrument_id  ON mission.model_portfolio_holdings(instrument_id);
CREATE INDEX idx_mph_effective_from ON mission.model_portfolio_holdings(effective_from);

CREATE TABLE mission.client_subscriptions (
    client_id       INTEGER NOT NULL REFERENCES mission.clients(client_id),
    portfolio_id    INTEGER NOT NULL REFERENCES mission.model_portfolios(portfolio_id),
    subscribed_from DATE NOT NULL,
    PRIMARY KEY (client_id, subscribed_from)
);
CREATE INDEX idx_cs_client_id    ON mission.client_subscriptions(client_id);
CREATE INDEX idx_cs_portfolio_id ON mission.client_subscriptions(portfolio_id);

CREATE TABLE mission.client_holdings (
    client_id     INTEGER NOT NULL REFERENCES mission.clients(client_id),
    instrument_id INTEGER NOT NULL REFERENCES mission.instruments(instrument_id),
    quantity      NUMERIC(18,6) NOT NULL CHECK (quantity >= 0),
    as_of_date    DATE NOT NULL,
    PRIMARY KEY (client_id, instrument_id)
);
CREATE INDEX idx_ch_client_id     ON mission.client_holdings(client_id);
CREATE INDEX idx_ch_instrument_id ON mission.client_holdings(instrument_id);

-- ============================================================
-- Sample Data
-- ============================================================

-- Advisors
INSERT INTO mission.advisors (name) VALUES
    ('Priya Shah'),
    ('Daniel Osei'),
    ('Wei Zhang'),
    ('Fatima Al-Rashid');

-- Clients
INSERT INTO mission.clients (name, advisor_id) VALUES
    ('Alice Johnson',  1),  -- Priya Shah
    ('Brian Osei',     2),  -- Daniel Osei
    ('Carla Mendes',   1),  -- Priya Shah
    ('David Kim',      3),  -- Wei Zhang
    ('Elena Petrova',  2),  -- Daniel Osei
    ('Farid Hossain',  4),  -- Fatima Al-Rashid
    ('Nadia Farouk',   3);  -- Wei Zhang

-- Instruments (reusing the enterprise schema instrument universe)
INSERT INTO mission.instruments (ticker, name, asset_class, currency) VALUES
    ('GLBEQ1',  'Global Equity Index Fund',    'Equity',      'GBP'),
    ('CORPB1',  'Sterling Corporate Bond Fund','Bond',        'GBP'),
    ('CASHGBP', 'Cash (GBP)',                  'Cash',        'GBP'),
    ('GILT10',  'UK 10-Year Gilt',             'Government',  'GBP'),
    ('AAPL',    'Apple Inc',                   'Equity',      'USD'),
    ('VOD.L',   'Vodafone Group PLC',          'Equity',      'GBP'),
    ('ULVR.L',  'Unilever PLC',                'Equity',      'GBP'),
    ('BARC.L',  'Barclays PLC',                'Equity',      'GBP');

-- Model Portfolios
INSERT INTO mission.model_portfolios (name) VALUES
    ('Balanced Growth'),
    ('Income Focus'),
    ('Adventurous Growth');

-- Model Portfolio Holdings (target weights sum to 100 per portfolio per effective_from date)
-- Balanced Growth: 40% equity, 30% corporate bonds, 30% cash
INSERT INTO mission.model_portfolio_holdings (portfolio_id, instrument_id, target_weight_pct, effective_from) VALUES
    (1, 1, 40.00, '2022-01-01'),  -- GLBEQ1 40%
    (1, 2, 30.00, '2022-01-01'),  -- CORPB1 30%
    (1, 3, 30.00, '2022-01-01'); -- CASHGBP 30%

-- Income Focus: 60% corporate bonds, 30% gilts, 10% cash
INSERT INTO mission.model_portfolio_holdings (portfolio_id, instrument_id, target_weight_pct, effective_from) VALUES
    (2, 2, 60.00, '2022-01-01'),  -- CORPB1 60%
    (2, 4, 30.00, '2022-01-01'),  -- GILT10 30%
    (2, 3, 10.00, '2022-01-01'); -- CASHGBP 10%

-- Adventurous Growth: 70% equity, 20% gilts, 10% cash
INSERT INTO mission.model_portfolio_holdings (portfolio_id, instrument_id, target_weight_pct, effective_from) VALUES
    (3, 1, 70.00, '2022-01-01'),  -- GLBEQ1 70%
    (3, 4, 20.00, '2022-01-01'),  -- GILT10 20%
    (3, 3, 10.00, '2022-01-01'); -- CASHGBP 10%

-- Client Subscriptions
INSERT INTO mission.client_subscriptions (client_id, portfolio_id, subscribed_from) VALUES
    (1, 1, '2023-01-15'),  -- Alice Johnson -> Balanced Growth
    (2, 3, '2023-03-01'),  -- Brian Osei -> Adventurous Growth
    (3, 2, '2022-11-01'),  -- Carla Mendes -> Income Focus
    (4, 3, '2023-06-01'),  -- David Kim -> Adventurous Growth
    (5, 1, '2022-09-01'),  -- Elena Petrova -> Balanced Growth
    (6, 2, '2024-01-20'),  -- Farid Hossain -> Income Focus
    (7, 1, '2026-06-01');  -- Nadia Farouk -> Balanced Growth

-- Client Holdings (actual current holdings — may differ from target weights)
-- Alice (Balanced Growth target: 40/30/30) — actual slightly overweight equity
INSERT INTO mission.client_holdings (client_id, instrument_id, quantity, as_of_date) VALUES
    (1, 1, 4800.000000, '2026-06-01'),  -- GLBEQ1 (48% if total = 10000)
    (1, 2, 2800.000000, '2026-06-01'),  -- CORPB1 (28%)
    (1, 3, 2400.000000, '2026-06-01'); -- CASHGBP (24%)

-- Brian (Adventurous Growth target: 70/20/10) — actual slightly underweight equity
INSERT INTO mission.client_holdings (client_id, instrument_id, quantity, as_of_date) VALUES
    (2, 1, 6200.000000, '2026-06-01'),  -- GLBEQ1 (62%)
    (2, 4, 2500.000000, '2026-06-01'),  -- GILT10 (25%)
    (2, 3, 1300.000000, '2026-06-01'); -- CASHGBP (13%)

-- Carla (Income Focus target: 60/30/10) — approximately on target
INSERT INTO mission.client_holdings (client_id, instrument_id, quantity, as_of_date) VALUES
    (3, 2, 5900.000000, '2026-06-01'),  -- CORPB1 (59%)
    (3, 4, 3100.000000, '2026-06-01'),  -- GILT10 (31%)
    (3, 3,  975.000000, '2026-06-01'); -- CASHGBP (9.75%)

-- ============================================================
-- Verification Queries
-- ============================================================

-- Part C, Query 8: Portfolio target composition
SELECT mp.name AS portfolio, i.ticker, i.name AS instrument, mph.target_weight_pct, mph.effective_from
FROM mission.model_portfolios mp
INNER JOIN mission.model_portfolio_holdings mph ON mp.portfolio_id = mph.portfolio_id
INNER JOIN mission.instruments i ON mph.instrument_id = i.instrument_id
ORDER BY mp.portfolio_id, mph.target_weight_pct DESC;

-- Part C, Query 9: Which client is subscribed to which portfolio
SELECT c.name AS client, mp.name AS portfolio, cs.subscribed_from
FROM mission.clients c
INNER JOIN mission.client_subscriptions cs ON c.client_id = cs.client_id
INNER JOIN mission.model_portfolios mp ON cs.portfolio_id = mp.portfolio_id
ORDER BY c.name;

-- Part C, Query 10: Demonstrate CHECK constraint rejection (target_weight_pct > 100)
-- This should FAIL with a check constraint violation:
INSERT INTO mission.model_portfolio_holdings (portfolio_id, instrument_id, target_weight_pct, effective_from)
VALUES (1, 5, 150.00, '2026-01-01');
