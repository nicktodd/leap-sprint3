-- Module 13 Capstone — client_trades Extension (Instructor Reference)

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

-- Sample trade history, consistent with Module 12's client_holdings rows.
-- Alice Johnson (client_id 1) holds 1200 units of GLBEQ1 (instrument_id 7) and
-- 600 of CORPB1 (instrument_id 6) as of 2026-06-30. Her trade history below
-- nets to exactly those quantities.
INSERT INTO client_trades (client_id, instrument_id, trade_type, quantity, price, trade_date) VALUES
    (1, 7, 'BUY', 1000, 3.80, '2023-01-20'),
    (1, 7, 'BUY', 300,  4.05, '2024-03-15'),
    (1, 7, 'SELL', 100, 4.30, '2025-11-01'),   -- net: 1000+300-100 = 1200
    (1, 6, 'BUY', 600,  4.90, '2023-02-01'),   -- net: 600

    (3, 6, 'BUY', 2500, 4.80, '2022-12-01'),
    (3, 6, 'BUY', 500,  5.10, '2024-06-01'),   -- net: 3000
    (3, 5, 'BUY', 1200, 0.97, '2022-12-01'),   -- net: 1200

    (4, 7, 'BUY', 4000, 3.70, '2023-06-15'),
    (4, 7, 'BUY', 1000, 4.20, '2024-09-01'),   -- net: 5000
    (4, 5, 'BUY', 500,  0.98, '2023-06-15'),
    (4, 5, 'SELL', 200, 1.05, '2025-04-01');   -- net: 500-200 = 300
