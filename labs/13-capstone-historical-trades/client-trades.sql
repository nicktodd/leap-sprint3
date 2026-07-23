-- Module 13 Capstone — Extend the Mission Schema with Historical Trade Data

-- Part A: Add the client_trades table to the mission schema

CREATE TABLE mission.client_trades (
    trade_id      SERIAL PRIMARY KEY,
    client_id     INTEGER NOT NULL REFERENCES mission.clients(client_id),
    instrument_id INTEGER NOT NULL REFERENCES mission.instruments(instrument_id),
    trade_type    TEXT NOT NULL CHECK (trade_type IN ('BUY', 'SELL')),
    quantity      NUMERIC(18,6) NOT NULL CHECK (quantity > 0),
    price         NUMERIC(14,4) NOT NULL CHECK (price > 0),
    trade_date    DATE NOT NULL
);

CREATE INDEX idx_ct_client_id     ON mission.client_trades(client_id);
CREATE INDEX idx_ct_instrument_id ON mission.client_trades(instrument_id);
CREATE INDEX idx_ct_trade_date    ON mission.client_trades(trade_date);

-- Part A: Load sample trade history for three clients
-- Consistent with client_holdings: net BUY - SELL = current holding quantity

-- Alice Johnson (client_id=1)
-- Holdings: GLBEQ1=4800, CORPB1=2800, CASHGBP=2400
INSERT INTO mission.client_trades (client_id, instrument_id, trade_type, quantity, price, trade_date) VALUES
    (1, 1, 'BUY',  5000.000000, 1.0000, '2023-01-20'),  -- GLBEQ1
    (1, 1, 'SELL',  200.000000, 1.0500, '2024-06-10'),  -- GLBEQ1 net: 4800
    (1, 2, 'BUY',  3000.000000, 1.0000, '2023-01-20'),  -- CORPB1
    (1, 2, 'SELL',  200.000000, 0.9800, '2025-02-01'),  -- CORPB1 net: 2800
    (1, 3, 'BUY',  2400.000000, 1.0000, '2023-01-20'); -- CASHGBP net: 2400

-- Brian Osei (client_id=2)
-- Holdings: GLBEQ1=6200, GILT10=2500, CASHGBP=1300
INSERT INTO mission.client_trades (client_id, instrument_id, trade_type, quantity, price, trade_date) VALUES
    (2, 1, 'BUY',  7000.000000, 1.0000, '2023-03-05'),  -- GLBEQ1
    (2, 1, 'SELL',  800.000000, 1.1000, '2025-01-15'),  -- GLBEQ1 net: 6200
    (2, 4, 'BUY',  2500.000000, 1.0000, '2023-03-05'),  -- GILT10 net: 2500
    (2, 3, 'BUY',  1300.000000, 1.0000, '2023-03-05'); -- CASHGBP net: 1300

-- Carla Mendes (client_id=3)
-- Holdings: CORPB1=5900, GILT10=3100, CASHGBP=975
INSERT INTO mission.client_trades (client_id, instrument_id, trade_type, quantity, price, trade_date) VALUES
    (3, 2, 'BUY',  6500.000000, 1.0000, '2022-11-05'),  -- CORPB1
    (3, 2, 'SELL',  600.000000, 1.0200, '2024-03-01'),  -- CORPB1 net: 5900
    (3, 4, 'BUY',  3100.000000, 1.0000, '2022-11-05'),  -- GILT10 net: 3100
    (3, 3, 'BUY',  1000.000000, 1.0000, '2022-11-05'),  -- CASHGBP
    (3, 3, 'SELL',   25.000000, 1.0000, '2025-05-01'); -- CASHGBP net: 975

-- Part C: Verification queries

-- 1. Net position per client from trade history (BUY - SELL per instrument)
SELECT c.name AS client,
       i.ticker,
       SUM(CASE WHEN ct.trade_type = 'BUY'  THEN  ct.quantity ELSE 0 END) -
       SUM(CASE WHEN ct.trade_type = 'SELL' THEN  ct.quantity ELSE 0 END) AS net_quantity
FROM mission.client_trades ct
INNER JOIN mission.clients c ON ct.client_id = c.client_id
INNER JOIN mission.instruments i ON ct.instrument_id = i.instrument_id
GROUP BY c.client_id, c.name, i.instrument_id, i.ticker
ORDER BY c.name, i.ticker;

-- 2. Total value traded per client
SELECT c.name AS client,
       SUM(ct.quantity * ct.price) AS total_value_traded
FROM mission.client_trades ct
INNER JOIN mission.clients c ON ct.client_id = c.client_id
GROUP BY c.client_id, c.name
ORDER BY total_value_traded DESC;

-- 3. Trades within a date range (2023)
SELECT c.name, i.ticker, ct.trade_type, ct.quantity, ct.price, ct.trade_date
FROM mission.client_trades ct
INNER JOIN mission.clients c ON ct.client_id = c.client_id
INNER JOIN mission.instruments i ON ct.instrument_id = i.instrument_id
WHERE ct.trade_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY ct.trade_date;

-- 4. Clients who have never made a SELL trade
SELECT c.name
FROM mission.clients c
WHERE c.client_id NOT IN (
    SELECT DISTINCT client_id
    FROM mission.client_trades
    WHERE trade_type = 'SELL'
);

-- 5. Demonstrate constraint: trade_type must be BUY or SELL
-- This should FAIL:
INSERT INTO mission.client_trades (client_id, instrument_id, trade_type, quantity, price, trade_date)
VALUES (1, 1, 'DIVIDEND', 100, 1.00, '2026-01-01');
