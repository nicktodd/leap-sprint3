# Demo: Module 02 — Postgres Essentials & Environment Setup

**Duration:** 12 minutes
**Prerequisite:** PostgreSQL server installed and running, `psql` on PATH, pgAdmin installed.
`shared/enterprise-schema.sql` from the labs repo.

## Part 1: Verify the install (2 min)

```bash
psql --version
psql -U postgres -h localhost -c "SELECT 1;"
```

Narration: `psql` is Postgres's official command-line client, it ships with the server install
and is always available, even on a machine with no GUI at all. Confirming it works is the first
sanity check before anything else.

## Part 2: Connect and load the enterprise schema (3 min)

```bash
psql -U postgres -h localhost
```

Inside `psql`:

```sql
CREATE DATABASE paysprint_wealth;
\c paysprint_wealth
\i shared/enterprise-schema.sql
```

Narration: `\c` switches which database you're connected to, `\i` runs a `.sql` file as if
you'd typed its contents. This is exactly how you'll load the enterprise schema for the rest of
the week.

## Part 3: Core psql meta-commands (4 min)

```sql
\dt          -- list tables in the current database
\d clients   -- describe one table: columns, types, keys
\d+ clients  -- the same, with extra detail (storage, description)
\l           -- list all databases on this server
\du          -- list roles/users
\x           -- toggle expanded display, useful for wide rows
```

Narration: these backslash commands are `psql`-specific, not SQL, they never go in application
code. `\d <table>` is the one you'll reach for constantly this week, it's the fastest way to
answer "what does this table actually look like" without leaving the terminal.

## Part 4: pgAdmin, alongside psql (3 min)

Open pgAdmin, connect to the same server, and navigate to the same `clients` table. Show the
same information `\d clients` gave you, now in a browsable tree and a properties panel.

Narration: pgAdmin and `psql` aren't rivals, they're the same underlying database, viewed two
different ways. `psql` is fast, scriptable, and always available. pgAdmin is easier to browse
visually and better for building queries interactively before you're fluent enough to write SQL
from memory. Most working engineers use both, switching based on the task.

## Key message

Before writing a single line of SQL this week, you need to be comfortable just *looking* at a
database: what tables exist, what each one contains, and two different tools for finding out.
