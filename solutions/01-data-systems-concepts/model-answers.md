# Module 01 Lab — Model Answers (Instructor Reference)

| # | System | Classification | Reasoning |
|---|---|---|---|
| 1 | Trading ledger | OLTP | Individual order confirmations, fast single-record writes, correctness matters more than scanning history |
| 2 | Executive analytics dashboard | OLAP | Large aggregations across quarters/regions/advisors, refreshed in batch, read-heavy |
| 3 | Product catalogue | OLTP | Individual browse/add-to-basket actions, many small concurrent reads and writes |
| 4 | Client onboarding | OLTP | One client's record created/updated at a time, correctness and immediacy matter |
| 5 | Fraud detection (overnight scan) | Mostly OLAP, sourced from OLTP | The scan itself is a large historical analytical query; but it depends on OLTP systems having recorded the underlying transactions correctly first, a good example of the two working together, not in isolation |
| 6 | ATM core banking | OLTP | The canonical OLTP example, an individual withdrawal must be fast, correct, and immediately consistent |
| 7 | Regulatory reporting | OLAP | Compiling a full quarter's data into one report is exactly the OLAP shape, large scan, infrequent, analytical |
| 8 | Support ticketing | OLTP | One agent, one ticket, one update, at a time |

## Where this week's own work sits

- **Enterprise schema (Modules 02-05)**: OLTP in shape (normalized, one row per real-world
  fact), even though in this course you'll mostly *read* from it rather than write to it. Its
  *design* is OLTP; how you happen to use it in class (read-only exploration) doesn't change
  that.
- **Mission model (Modules 06-13)**: also OLTP, you're modelling current state (subscriptions,
  holdings) that needs to support fast, correct updates as clients change portfolios or trade.

## What to check as an instructor

- System 5 is the one worth spending the most discussion time on, delegates who only say
  "OLAP" without noting the OLTP dependency underneath have missed the more interesting point.
- Delegates correctly identify that "read-only in a training lab" doesn't reclassify a
  fundamentally OLTP-shaped schema as OLAP, the classification is about the schema's design
  intent and real-world usage pattern, not how it happens to be used in a classroom.
