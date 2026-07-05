# Demo: Module 11 — Cloud Data Warehouses & Snowflake Overview

**Duration:** 12 minutes
**Prerequisite:** A Snowflake trial/sandbox account provisioned for the cohort (trainer confirms
sign-in works before the session). No installation needed, Snowflake runs entirely in the
browser (Snowsight) or via a client tool.

## Part 1: What a cloud data warehouse is (2 min)

Narration: everything this week (the enterprise schema, the mission model) has been an OLTP
(Online Transaction Processing) database, optimised for many small, fast, individual
transactions. A **cloud data warehouse** is built for the opposite job: OLAP (Online Analytical
Processing), scanning huge volumes of historical data to answer analytical questions, delivered
as a managed cloud service rather than something you install and operate yourself.

## Part 2: Snowflake's architecture (4 min)

Narration, pointing at the architecture diagram: Snowflake's key idea is separating **storage**
from **compute**. Data sits once, in a single shared storage layer. Multiple independent
compute clusters ("virtual warehouses" in Snowflake's terminology) can all query that same
data at once, each scaled up or down independently, without duplicating the data itself.

Contrast this with a traditional database (including Postgres): storage and compute are tied
together on the same server, scaling one usually means scaling both. Snowflake's separation
means a heavy analytical query from one team doesn't compete for the same compute resources as
a different team's dashboard refresh, even though both are reading the exact same data.

## Part 3: Exploring the sample data (5 min)

```sql
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

SHOW TABLES;

SELECT * FROM CUSTOMER LIMIT 10;

SELECT c_mktsegment, COUNT(*) AS customer_count
FROM CUSTOMER
GROUP BY c_mktsegment
ORDER BY customer_count DESC;
```

Narration: `SNOWFLAKE_SAMPLE_DATA` is a read-only database included with every Snowflake
account, no setup required. `TPCH_SF1` is a standard analytical benchmark dataset, orders,
customers, line items, at a scale designed for exactly this kind of exploration. Point out how
familiar the SQL itself looks, Snowflake speaks SQL, the same fundamentals from Modules 03-05
apply directly; what's different is the underlying architecture and the job it's built for, not
the query language.

## Part 4: Trade-offs of moving data into a warehouse (1 min)

Narration: a warehouse gives you fast analytical queries over huge historical volumes, at the
cost of the data being a copy, not the live source of truth, and usually arriving with some
delay (a pipeline, covered properly in Sprint 4). You gain analytical speed, you give up
real-time freshness and the strict transactional guarantees an OLTP system provides.

## Key message

Snowflake isn't "Postgres but bigger", it's built for a different job entirely: OLAP, not OLTP,
with an architecture (separated storage and compute) specifically designed to make that job
scale independently. The SQL you already know still applies, the platform underneath is what's
different.
