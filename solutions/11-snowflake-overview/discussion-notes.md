# Module 11 Lab — Discussion Notes (Instructor Reference)

## Snowsight vs psql/pgAdmin, example comparison

- **Similar**: the SQL itself, `SELECT`, `JOIN`, `GROUP BY` all work exactly as learned earlier
  this sprint, confirming the platform difference is architectural, not about the query
  language.
- **Different**: Snowsight is entirely browser-based with no local install, query results
  render inline with visualisation options built in, and there's no equivalent of `psql`'s
  meta-commands (`\dt`, `\d`), Snowsight's UI browser panel replaces that role instead.

## Trade-offs of moving reporting into a warehouse (example answer)

"We'd gain fast analytical queries over the full history of transactions, without that load
competing with the live transactional system merchants and clients depend on. We'd give up
real-time freshness, the warehouse copy would lag behind the live database by however long the
pipeline takes to run, and we'd be reporting against a copy, not the system of record, so any
pipeline failure needs to be caught and understood before anyone trusts a number from it."

## What to check as an instructor

- Delegates recognise this is the same SQL they already know, applied to unfamiliar table names,
  the goal is confidence navigating a new schema quickly (Module 02's exploration skill,
  applied again), not learning new syntax.
- The trade-off reflection correctly identifies *both* a gain (query performance, isolation from
  OLTP load) and a cost (data freshness/lag, trusting a copy), not just one side.
- If a delegate attempts the "virtual warehouse" extension, check they connect it back to the
  storage/compute separation: a virtual warehouse is Snowflake's name for an independently
  scalable compute cluster, sized and billed separately from the (single, shared) storage layer.
