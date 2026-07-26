# LEAP Program — Sprint 3 Lab Exercises

This repository contains the hands-on lab exercises accompanying **Sprint 3: Data Systems and
Data Modelling**, week 3 of the 11-sprint LEAP graduate programme.

## Prerequisites

- PostgreSQL (server) and `psql`
- pgAdmin (a Postgres-native GUI client, used alongside `psql` from Module 02 onward)
- A Snowflake trial/sandbox account, provisioned by your trainer (Module 11 only)
- GitHub Copilot Chat (continuing as a learning aid, and for critiquing alternative query
  formulations in Module 05)

## Two datasets run through this whole week

- **`shared/enterprise-schema.sql`** — a pre-loaded, read-heavy "PaySprint Wealth Platform"
  schema (advisors, clients, accounts, instruments, holdings, transactions). Used for query
  practice in Modules 02-05, and referenced again in Module 09. You explore and query this,
  you don't design it.
- **`shared/mission-brief.md`** — the business brief for the **Model Portfolio service**, a
  separate, narrower system your team designs from scratch starting in Module 06, implements
  in Postgres in Module 12, and extends for historical trade data in the Module 13 capstone.
  `shared/messy-flat-file.csv` is a denormalized starting point used in Module 06's
  normalization exercise.

## Structure

Each module has its own folder under `demos/`, `labs/`, and `solutions/`:

- `demos/<module>/` — instructor-led demo assets and guides
- `labs/<module>/` — your starter files and the task README for that module
- `solutions/<module>/` — reference solutions (try the lab first!)

## Modules

| # | Module | Lab |
|---|---|---|
| 1 | Data Systems Concepts | [labs/01-data-systems-concepts/README.md](labs/01-data-systems-concepts/README.md) |
| 2 | Postgres Essentials & Environment Setup | [labs/02-postgres-essentials/README.md](labs/02-postgres-essentials/README.md) |
| 3 | SQL Fundamentals Refresher | [labs/03-sql-fundamentals/README.md](labs/03-sql-fundamentals/README.md) |
| 4 | Advanced SQL Part 1 — Joins & Aggregation | [labs/04-sql-joins-aggregation/README.md](labs/04-sql-joins-aggregation/README.md) |
| 5 | Advanced SQL Part 2 — Subqueries, CTEs & Derived Tables | [labs/05-sql-subqueries-ctes/README.md](labs/05-sql-subqueries-ctes/README.md) |
| 6 | RDBMS Modelling Part 1 — Entities, Relationships & Normalization | [labs/06-rdbms-modelling-part1/README.md](labs/06-rdbms-modelling-part1/README.md) |
| 7 | ER Diagrams: Translating Requirements into Schemas | [labs/07-er-diagrams/README.md](labs/07-er-diagrams/README.md) |
| 8 | RDBMS Modelling Part 2 — Keys, Indexes & Constraints | [labs/08-rdbms-modelling-part2/README.md](labs/08-rdbms-modelling-part2/README.md) |
| 9 | Structured Problem-Solving | [labs/09-structured-problem-solving/README.md](labs/09-structured-problem-solving/README.md) |
| 10 | NoSQL Overview | [labs/10-nosql-overview/README.md](labs/10-nosql-overview/README.md) |
| 11 | Cloud Data Warehouses & Snowflake Overview | [labs/11-snowflake-overview/README.md](labs/11-snowflake-overview/README.md) |
| 12 | Implementing the Data Model in Postgres | [labs/12-implementing-the-model/README.md](labs/12-implementing-the-model/README.md) |
| 13 | Capstone: Extending the Schema for Historical Trade Data | [labs/13-capstone-historical-trades/README.md](labs/13-capstone-historical-trades/README.md) |
| 14 | Sprint 3 Wrap-up & Assessment Prep | [labs/14-sprint3-wrapup/README.md](labs/14-sprint3-wrapup/README.md) |

## Getting started

1. Clone this repository.
2. Load `shared/enterprise-schema.sql` into a local Postgres database (Module 02 walks through
   this step by step).
3. Work through the modules in order, starting with `labs/01-data-systems-concepts/README.md`.

## Support

Ask your trainer or Scrum team lead during class, or raise a question in the cohort Slack
channel.
