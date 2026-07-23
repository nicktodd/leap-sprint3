# Module 10 Lab — Choosing the Right Store

## Scenario 1: Session Storage for PaySprint Mobile

**Chosen store type: Key-value store** (e.g. Redis)

**Justification:** The access pattern is exclusively "does this token exist and is it still valid?" — a pure key lookup with no relational joins, no range queries, and no reporting. A key-value store retrieves by key in O(1) time and supports native TTL (time-to-live) for automatic expiry, matching the "expires after inactivity" requirement exactly. A relational store could technically serve this, but would require a polling DELETE job for expiry and would add unnecessary join overhead for a lookup that needs no related data.

**What goes wrong with a different choice?** A document store would work functionally but adds unnecessary overhead: session data has no nested structure, so the schema flexibility of a document store provides no benefit here. A columnar store is optimised for analytical range scans, the opposite of single-key point lookups.

---

## Scenario 2: Market-Data Ingestion Pipeline (Price Ticks)

**Chosen store type: Columnar store** (e.g. InfluxDB, Apache Cassandra, or TimescaleDB)

**Justification:** The access pattern is "give me instrument X's price history over this time range" — a time-series range scan over a single column (price) for a given instrument. Columnar stores compress and scan a single column across millions of rows extremely efficiently, making this query fast even at millions of ticks per second. Row-oriented stores (relational or document) would need to deserialise every full row to extract just the price, which is wasteful at this volume and access pattern.

---

## Scenario 3: Client Financial Goals Feature

**Chosen store type: Document store** (e.g. MongoDB or PostgreSQL JSONB)

**Justification:** Each goal type has genuinely different attributes (a house deposit goal and a retirement goal share almost no columns), and new goal types are added as the product evolves. A document store accommodates per-document schema variation without requiring ALTER TABLE migrations for every new goal type. A relational model would require either a wide sparse table (most columns NULL for most goal types) or a complex EAV (entity-attribute-value) pattern — both of which make queries awkward and hard to maintain. The access pattern (retrieve one client's goals, display on their profile) does not require cross-goal-type analytical queries that would demand relational joins.

---

## Extension: Could scenario 1 work in Postgres?

Yes, a `sessions` table in Postgres with a `token`, `client_id`, `created_at`, and `expires_at` column would work fine for tens or hundreds of users. The problem at scale is:
- Every request (even a static page load) hits the database for a session lookup, turning the relational database into a bottleneck for all traffic
- Expiry requires a periodic DELETE job; without it the table grows unboundedly
- Connection pool exhaustion: at tens of thousands of concurrent users, the session lookup rate could saturate the Postgres connection pool, blocking unrelated application queries
- A Redis key-value store handles millions of lookups per second on a single node and expires keys natively, removing all three problems
