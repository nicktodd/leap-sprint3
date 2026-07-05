# Module 02 Lab — Example Schema Documentation (Instructor Reference)

## Tables and what they represent

| Table | Represents |
|---|---|
| `advisors` | A wealth advisor employed by PaySprint Wealth |
| `clients` | An individual client, linked to the advisor managing their relationship |
| `instruments` | A tradeable thing (equity, bond, fund, or cash), independent of any client |
| `accounts` | A specific account (ISA, GIA, or SIPP) belonging to one client |
| `holdings` | A snapshot of what an account currently holds, as of a given date |
| `transactions` | An individual event: a buy, sell, dividend, deposit, or withdrawal on an account |

## Foreign key relationships

- `clients.advisor_id -> advisors.advisor_id`: each client has one advisor
- `accounts.client_id -> clients.client_id`: each account belongs to one client
- `holdings.account_id -> accounts.account_id`: each holding row belongs to one account
- `holdings.instrument_id -> instruments.instrument_id`: each holding is of one instrument
- `transactions.account_id -> accounts.account_id`: each transaction belongs to one account
- `transactions.instrument_id -> instruments.instrument_id`: each transaction (except pure cash
  deposits/withdrawals) involves one instrument

## Entities vs events

- **Reference/entity tables** (relatively static, referenced from elsewhere): `advisors`,
  `clients`, `instruments`, `accounts`
- **Event/fact tables** (represent something that happened, or a point-in-time snapshot):
  `transactions` (an event, one row per buy/sell/dividend/etc), `holdings` (a snapshot, current
  state as of a date)

## psql vs pgAdmin, example observations

- **psql advantage**: `\d clients` is near-instant and scriptable, useful when checking many
  tables quickly or when working over SSH with no GUI available at all.
- **pgAdmin advantage**: browsing foreign key relationships visually, and building a query with
  autocomplete, is easier than remembering exact column names from memory.

## What to check as an instructor

- Delegates correctly distinguish `holdings` (a snapshot) from `transactions` (an event
  history), this distinction becomes directly relevant again in Module 13's capstone.
- The documentation was genuinely produced by exploration (`\d`, pgAdmin), not by reading
  `enterprise-schema.sql` directly, ask a delegate to explain a relationship without looking at
  either.
