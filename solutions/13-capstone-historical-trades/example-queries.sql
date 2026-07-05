-- Module 13 Capstone — Example Team Queries (Instructor Reference)

-- Net position per client, from trade history alone
SELECT client_id, instrument_id,
       SUM(CASE WHEN trade_type = 'BUY' THEN quantity ELSE -quantity END) AS net_quantity
FROM client_trades
GROUP BY client_id, instrument_id
ORDER BY client_id, instrument_id;
-- Sanity check: compare this output against client_holdings.quantity for the
-- same client_id/instrument_id, they should match for the clients loaded above.

-- Total value traded per client (BUYs only, i.e. total invested)
SELECT client_id, SUM(quantity * price) AS total_invested
FROM client_trades
WHERE trade_type = 'BUY'
GROUP BY client_id
ORDER BY total_invested DESC;

-- Trades within a date range
SELECT *
FROM client_trades
WHERE trade_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY trade_date;

-- Clients who have never made a SELL trade
SELECT DISTINCT c.client_id, c.name
FROM clients c
WHERE NOT EXISTS (
    SELECT 1 FROM client_trades t
    WHERE t.client_id = c.client_id AND t.trade_type = 'SELL'
);

-- What to check as an instructor:
-- - The net-position query's output actually matches client_holdings for the
--   same client/instrument pairs, if it doesn't, that's a genuine
--   inconsistency worth the team investigating, not dismissing.
-- - Every team member's query is genuinely different, not the same query
--   with cosmetic changes.
-- - Every team member can explain their own query, and at least one
--   teammate's, in plain English.
