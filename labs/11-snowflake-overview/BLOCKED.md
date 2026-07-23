# Module 11 Lab — BLOCKED: No Snowflake Account

This lab requires a provisioned Snowflake trial/sandbox account (Snowsight) provided by the trainer.

**Status: Blocked — cannot complete without a Snowflake account.**

Tasks that would be completed with access:
1. Sign in to Snowsight
2. Browse SNOWFLAKE_SAMPLE_DATA.TPCH_SF1 tables
3. Run SELECT * FROM CUSTOMER LIMIT 10
4. Aggregate customers by c_mktsegment
5. JOIN CUSTOMER and ORDERS for total order value per market segment
6. Write Snowsight vs psql comparison
7. Write trade-off reflection (warehouse vs live OLTP for PaySprint Wealth reporting)

**Conceptual answers (for assessment prep):**

**Snowsight vs psql:** Snowsight provides a browser-based GUI with auto-complete, result formatting, and query history — lower friction for exploration. psql is faster for scripting, automation, and batch operations. Both support standard SQL; the main difference is the interface, not the query language.

**Trade-off — moving PaySprint Wealth reporting to a warehouse:**
- Gain: analytical queries (e.g. multi-year transaction history, cross-client aggregations) run much faster without impacting the live OLTP system, and the warehouse can scale compute independently of storage.
- Give up: near-real-time data (warehouse loads are typically batch/scheduled, so reports may lag by minutes to hours); added complexity of maintaining an ETL/ELT pipeline; additional cost of the separate compute layer.

**Snowflake virtual warehouse:** A virtual warehouse in Snowflake is a cluster of compute nodes (not a database) that executes queries. It is separate from storage (which holds the actual data in cloud object storage). You can spin a warehouse up or down independently of the data — this means you can run large analytical workloads on-demand and pay only for the compute time you use, without affecting other warehouses querying the same data simultaneously.
