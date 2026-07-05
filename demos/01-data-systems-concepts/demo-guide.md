# Demo: Module 01 — Data Systems Concepts

**Duration:** 10 minutes
**Prerequisite:** none. Conceptual, no tooling needed.

## Part 1: OLTP vs OLAP (4 min)

Narration: two very different jobs a database can be asked to do.

- **OLTP (Online Transaction Processing)**: many small, fast, concurrent reads and writes, one
  record at a time, e.g. recording a single trade, updating a single client's address. Optimised
  for correctness and speed on individual transactions. Normalized (Modules 06-08 explain why).
- **OLAP (Online Analytical Processing)**: fewer, larger queries scanning huge amounts of
  historical data to answer analytical questions, e.g. "what was total trading volume by asset
  class last quarter." Optimised for scanning and aggregating, often denormalized on purpose.

Point at the diagram: this week's Postgres schema (both the enterprise schema and the mission
model you'll build) is OLTP. Module 11's Snowflake is the OLAP side of the same coin.

## Part 2: Relational vs non-relational (3 min)

Narration: relational (SQL) enforces a fixed, structured schema up front, strong consistency
guarantees, and relationships enforced by the database itself. Non-relational (NoSQL, covered
properly in Module 10) trades some of that structure for flexibility or scale, useful when data
doesn't fit a tidy table shape, or when the volume/velocity outgrows what a single relational
database comfortably handles. Neither is "better," they fit different problems, which Module 10
explores in depth.

## Part 3: Where this week sits in the landscape (3 min)

Point at the "data systems landscape" diagram: operational systems (OLTP, this week's Postgres
work) generate the raw data. That data often gets moved (a pipeline, sometimes literally ETL,
covered properly in Sprint 4) into an analytical system (OLAP, Snowflake) for reporting and
analytics. Sprint 4 picks up exactly there, building Python analytics on top of data that looks
like what an OLAP system would hold.

## Key message

Almost everything else this week only makes sense once you know which job a system is doing.
A design that's excellent for OLTP (normalized, transaction-safe) is often a poor fit for OLAP,
and vice versa, that's not a contradiction, it's two different jobs.
