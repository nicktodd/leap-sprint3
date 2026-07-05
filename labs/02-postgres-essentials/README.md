# Module 02 Lab — Explore the Enterprise Schema

## Objectives

By the end of this lab you will have:

- Installed and verified Postgres access, and connected via `psql`
- Used core `psql` meta-commands (`\dt`, `\d`, `\c`, and similar) to explore a schema
- Compared exploring a database via `psql` and via pgAdmin
- Documented the tables and relationships in a pre-loaded enterprise schema

## Setup

- PostgreSQL installed, with `psql` on your PATH
- pgAdmin installed
- [`shared/enterprise-schema.sql`](../../shared/enterprise-schema.sql) from the repo root

## Task sheet

### Part A — Connect and load

1. Verify your Postgres install: `psql --version`.
2. Connect to your local server, create a database called `paysprint_wealth`, and load
   `shared/enterprise-schema.sql` into it.

### Part B — Explore with psql

3. Use `\dt` to list every table.
4. Use `\d <table>` on each of the six tables (`advisors`, `clients`, `instruments`, `accounts`,
   `holdings`, `transactions`) to see its columns, types, and keys.
5. Use `\d+ <table>` on one table to see the extra detail it adds over plain `\d`.

### Part C — Explore with pgAdmin

6. Open pgAdmin, connect to the same server, and browse to `paysprint_wealth`.
7. Find the same six tables in pgAdmin's tree view, and open one table's properties panel.
8. Note one thing pgAdmin makes easier than `psql`, and one thing `psql` makes easier or faster
   than pgAdmin.

### Part D — Document what you found

9. Without looking at the raw `.sql` file, write a short document describing:
   - Every table, and what real-world thing each row represents
   - Every foreign key relationship you can find (which table references which, and why)
   - Your best guess at which tables are "the same real-world entity, referenced from
     elsewhere" vs which represent an event or a point-in-time fact

## Acceptance criteria

- All six tables have been inspected with `\d` and their columns/types noted.
- You have a written document describing every table and every foreign key relationship,
  produced by exploration, not by reading the source `.sql` file.
- You've named one concrete advantage of psql and one of pgAdmin, based on using both today.

If you finish early, sketch your own rough diagram of how the six tables relate, on paper or in
a text file, you'll compare this against a proper ER diagram in Module 07.
