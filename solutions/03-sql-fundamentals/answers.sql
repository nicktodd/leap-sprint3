-- Module 03 Lab — Reference Answers (Instructor Reference)

-- 1. Every client's name and risk profile
SELECT name, risk_profile
FROM clients;

-- 2. Names of all "Cautious" clients
SELECT name
FROM clients
WHERE risk_profile = 'Cautious';

-- 3. Clients who joined before 2018-01-01, oldest first
SELECT name, joined_date
FROM clients
WHERE joined_date < '2018-01-01'
ORDER BY joined_date ASC;

-- 4. Clients with risk profile "Cautious" or "Adventurous"
SELECT name, risk_profile
FROM clients
WHERE risk_profile IN ('Cautious', 'Adventurous');

-- 5. Clients born in the 1980s
SELECT name, date_of_birth
FROM clients
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31';

-- 6. Instruments, alphabetical by name
SELECT ticker, name
FROM instruments
ORDER BY name ASC;

-- 7. DIVIDEND transactions, most recent first
SELECT transaction_id, account_id, txn_date, price
FROM transactions
WHERE txn_type = 'DIVIDEND'
ORDER BY txn_date DESC;

-- 8. Transactions with no associated instrument (deposits/withdrawals)
SELECT transaction_id, account_id, txn_type, txn_date
FROM transactions
WHERE instrument_id IS NULL;

-- 9. Distinct account types
SELECT DISTINCT account_type
FROM accounts;

-- 10. Clients with a non-null date of birth
-- Every client in this schema has a NOT NULL date_of_birth column (see enterprise-schema.sql),
-- so this query is correct but will always return every client, there are no NULLs to exclude
-- in this particular dataset. Worth noting explicitly: a query can be correct even when the
-- condition it checks never actually triggers on the data at hand.
SELECT name, date_of_birth
FROM clients
WHERE date_of_birth IS NOT NULL;
