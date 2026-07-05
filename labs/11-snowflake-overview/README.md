# Module 11 Lab — Explore Snowflake's Sample Data

## Objectives

By the end of this lab you will have:

- Understood what a cloud data warehouse is and how it differs from an OLTP database
- Understood Snowflake's separation of storage and compute at a conceptual level
- Run basic queries against a read-only Snowflake sample dataset
- Reflected on the trade-offs of moving data into a warehouse

## Setup

- A Snowflake trial/sandbox account, provisioned by your trainer
- No installation needed, Snowflake runs in the browser (Snowsight)

## Task sheet

1. **Sign in** to your provisioned Snowflake account via Snowsight.

2. **Find the sample data**: switch to the `SNOWFLAKE_SAMPLE_DATA` database and the `TPCH_SF1`
   schema. List its tables.

3. **Run a simple query**: select the first 10 rows from the `CUSTOMER` table.

4. **Run an aggregated query**: count customers by market segment (`c_mktsegment`), ordered
   from most to fewest.

5. **A join**: find the total order value (`SUM(o_totalprice)`) per customer market segment, by
   joining `CUSTOMER` and `ORDERS`. (Hint: this is the same join skills from Sprint 3 Modules
   03-05, applied to an unfamiliar schema.)

6. **Compare the experience**: write a short comparison of using Snowflake's Snowsight interface
   versus `psql`/pgAdmin for the same kind of exploration you did in Module 02. What felt
   similar? What felt different?

7. **Reflect on trade-offs**: in two or three sentences, explain what you'd gain and what you'd
   give up if PaySprint Wealth moved its transaction reporting into a warehouse like this,
   instead of querying the live OLTP database directly.

## Acceptance criteria

- You've listed the tables in `TPCH_SF1` and successfully queried at least three of them.
- Your aggregated query and join both run correctly and return sensible results.
- A written comparison of Snowsight vs psql/pgAdmin, specific to what you actually experienced.
- A written trade-off reflection connecting back to PaySprint Wealth's own systems.

If you finish early, look up (or ask Copilot to explain) what a "virtual warehouse" actually is
in Snowflake's own terminology, and how it relates to the storage/compute separation from
today's demo.
