-- Module 12 Lab — Verification Queries (Instructor Reference)

-- 8. Each portfolio's target composition, readable end to end
SELECT mp.name AS portfolio, i.ticker, i.name AS instrument_name, mph.target_weight_pct
FROM model_portfolio_holdings mph
JOIN model_portfolios mp ON mph.model_portfolio_id = mp.model_portfolio_id
JOIN instruments i ON mph.instrument_id = i.instrument_id
ORDER BY mp.name, mph.target_weight_pct DESC;

-- 9. Which client is subscribed to which portfolio
SELECT c.name AS client_name, mp.name AS model_portfolio, cs.subscribed_date
FROM client_subscriptions cs
JOIN clients c ON cs.client_id = c.client_id
JOIN model_portfolios mp ON cs.model_portfolio_id = mp.model_portfolio_id
ORDER BY c.name;

-- 10. Deliberately violate a constraint
INSERT INTO model_portfolio_holdings (model_portfolio_id, instrument_id, target_weight_pct)
VALUES (1, 5, 150);
-- Expected: ERROR: new row for relation "model_portfolio_holdings" violates
-- check constraint "model_portfolio_holdings_target_weight_pct_check"

-- Finish-early extension: one client's actual holdings vs their target weights
SELECT c.name, i.ticker,
       ch.quantity AS actual_quantity,
       mph.target_weight_pct
FROM clients c
JOIN client_subscriptions cs ON c.client_id = cs.client_id
JOIN model_portfolio_holdings mph ON cs.model_portfolio_id = mph.model_portfolio_id
LEFT JOIN client_holdings ch ON ch.client_id = c.client_id AND ch.instrument_id = mph.instrument_id
WHERE c.name = 'David Kim'
ORDER BY i.ticker;
-- Note: this shows quantity next to a target *percentage*, not a directly
-- comparable pair, exactly the gap Module 09 uncovered: without a price per
-- holding, quantity can't be turned into a percentage of portfolio value.
-- A good outcome here is a team noticing that limitation again, in practice.
