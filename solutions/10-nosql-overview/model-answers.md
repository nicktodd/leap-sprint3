# Module 10 Lab — Model Answers (Instructor Reference)

## Scenario 1: Session storage — Key-Value Store

**Justification:** the access pattern is purely "look up by token, get back a small value,
extremely fast, extremely high volume." No relationships, no complex queries, just a key and a
value with an expiry. This is precisely what key-value stores (Redis and similar) are built
for, and precisely why forcing it into a relational table would be unnecessary overhead at
scale, even though a small relational table would technically work fine for a handful of users.

## Scenario 2: Market-data ingestion — Columnar Store

**Justification:** enormous write throughput (millions of ticks per second) and a query pattern
that scans one or two columns (price, over time, for one instrument) across huge volumes of
rows, rather than reading whole "wide" records. This is exactly the shape columnar stores
(Cassandra and similar) are optimised for: fast writes, and fast scans down a column, rather
than fast lookups of a single complete row.

## Scenario 3: Financial goals feature — Document Store

**Justification:** different goal types genuinely have different shapes (a house deposit's
fields don't overlap cleanly with a retirement goal's fields), and new types get added over
time. Modelling this relationally would mean either a table with many nullable columns (most
applying to only some rows), or a complex "one table per goal type" design that gets more
complex with every new goal type added. A document store lets each goal record simply have the
fields relevant to its own type, and new goal types don't require a schema migration.

## What to check as an instructor

- Justifications reference the *specific* access pattern of each scenario (volume, query shape,
  variability), not a generic "NoSQL is more scalable" or "relational is safer" statement.
- Delegates can articulate the downside of choosing wrong, for example, session storage in a
  relational table works at small scale but becomes a bottleneck (and a lot of write traffic on
  a system meant for durable, correctness-critical data) at real production volume.
- For the "finish early" discussion: the answer is yes, a small Postgres table works fine for
  a teaching-scale dataset, but at real scale, the sheer write volume and short-lived nature of
  session data would compete for resources with the mission-critical data in the same database,
  a good example of "technically works" not being the same as "the right choice at scale."
