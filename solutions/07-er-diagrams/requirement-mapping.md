# Module 07 Lab — Requirement Mapping (Instructor Reference)

**Note on `advisors`:** the mission model reuses the same `advisors` concept as the enterprise
schema, rather than reinventing it. If a team's `clients.advisor_id` references an `advisors`
table that doesn't exist in their own script, that's fine, they should point out they're
assuming reuse of the enterprise schema's `advisors` table, that's a reasonable, explicit
assumption, not a gap.

## Mapping the brief's four requirements to the schema

1. **"Record which model portfolios exist, and what instruments and target weights make each
   one up... a model portfolio's composition can change over time."**
   Satisfied by `model_portfolios` and `model_portfolio_holdings`. Note the first-draft schema
   only captures *current* composition, it has no history of past target weights. Worth
   flagging as a known gap, not yet required by the brief's wording, but worth teams noticing.

2. **"Record which client is subscribed to which model portfolio, and since when... keep that
   history too."**
   Satisfied by `client_subscriptions`, with `subscribed_date` as part of the key specifically
   to allow more than one subscription record per client over time.

3. **"Record each client's actual current holdings."**
   **Not yet satisfied** by this draft schema. This is a genuine gap worth teams finding
   themselves, a `client_holdings` table (or similar) is still needed. A good outcome for this
   lab is a team noticing this gap during Part C rather than being told about it.

4. **"Reporting, for any client, current holdings against target weights."**
   Depends on requirement 3 being satisfied first, currently blocked by the same gap.

## What to check as an instructor

- Teams that mapped all four requirements cleanly without finding the gap in requirement 3
  should be prompted directly: "show me the table that stores what a client actually holds
  right now." This is a deliberate omission in the brief's "known entities" list (`shared/
  mission-brief.md` lists it as "some way of recording a client's actual current holdings",
  without naming a table), the exercise is whether teams notice they haven't built it yet.
- A team that adds a `client_holdings` table unprompted should be commended specifically for
  catching this before Module 08, not just for producing correct DDL.
