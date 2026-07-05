# Demo: Module 10 — NoSQL Overview

**Duration:** 12 minutes
**Prerequisite:** none. Conceptual, no NoSQL database needed today.

## Part 1: Recap and framing (2 min)

Narration: Module 01 introduced relational vs non-relational at a glance. Everything since has
been relational, on purpose, it's the foundation. **NoSQL** (the name is a historical
shorthand, most practitioners read it as "Not Only SQL" rather than "no SQL at all") covers
several genuinely different data models, each solving a different problem relational databases
handle less well.

## Part 2: Three models, conceptually (6 min)

**Document stores** (e.g. MongoDB): store JSON-like documents, each one potentially having a
different shape. Good fit when different records genuinely have different attributes, a
product catalogue where shoes have `size` and `color` but electronics have `wattage` and
`voltage`. Forcing that into a single rigid relational table means a lot of nullable columns
that only apply to some rows.

**Key-value stores** (e.g. Redis): store a value against a key, nothing more structured than
that. Extremely fast lookups by key. Good fit for session storage, caching, anything where you
always look something up by one known identifier and don't need to query by anything else.

**Columnar stores** (e.g. Cassandra): store data by column rather than by row, optimised for
extremely high write throughput and queries that scan one or two columns across huge numbers of
rows. Good fit for time-series and IoT-style data, millions of sensor readings a second, where
you mostly query "give me this one metric over time" rather than "give me this whole record."

## Part 3: When NoSQL wins, and when it doesn't (2 min)

Narration: none of these give up consistency and relationships for free, that's the trade-off,
not a bonus. Choose NoSQL when the shape of the problem genuinely doesn't fit relational: wildly
varying record shapes (document), pure lookup-by-key at huge scale (key-value), or massive
write throughput on time-series data (columnar). Don't choose it just because it sounds modern,
this week's mission model is a textbook relational problem (structured entities, real
relationships, correctness matters), and relational is still the right tool for it.

## Part 4: Where this shows up at Fidelity (2 min)

Narration: even in an organisation built on relational core systems, NoSQL patterns show up at
the edges: a session cache in front of a web application (key-value), a document store holding
flexible client-preference data that varies by product line, a columnar store behind a
market-data or monitoring pipeline ingesting huge event volumes. Recognising the pattern matters
more than memorising vendor names.

## Key message

NoSQL isn't one thing, it's three (at least) genuinely different models, each earning its place
by fitting a specific shape of problem relational handles awkwardly. The skill is recognising
which shape you're looking at, not picking a trendy database by default.
