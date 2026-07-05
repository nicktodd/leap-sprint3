-- Module 11 Lab — Example Queries (Instructor Reference)

USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

SHOW TABLES;
-- Expect: CUSTOMER, ORDERS, LINEITEM, PART, PARTSUPP, SUPPLIER, NATION, REGION

-- 3. Simple query
SELECT * FROM CUSTOMER LIMIT 10;

-- 4. Aggregated query
SELECT c_mktsegment, COUNT(*) AS customer_count
FROM CUSTOMER
GROUP BY c_mktsegment
ORDER BY customer_count DESC;

-- 5. Join: total order value per market segment
SELECT c.c_mktsegment, SUM(o.o_totalprice) AS total_order_value
FROM CUSTOMER c
JOIN ORDERS o ON c.c_custkey = o.o_custkey
GROUP BY c.c_mktsegment
ORDER BY total_order_value DESC;
