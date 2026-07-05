# Module 09 Lab — Model Approach (Instructor Reference)

## 1. Clarifying questions and reasonable assumptions

| Question | Reasonable assumption (no stakeholder available) |
|---|---|
| Drifted from what, one instrument's weight, or the whole portfolio's shape? | One instrument's target weight vs a client's actual weight in that instrument |
| How much before it counts as "significant"? | More than 5 percentage points, a round, defensible starting threshold, easy to change later |
| As of when? | As of the most recent `client_holdings.as_of_date` for that client |
| A one-time report, or ongoing? | A one-time report for this exercise; note that "ongoing" would likely need a scheduled job, out of scope today |

## 2. Entities and data needed

- `client_subscriptions` (to find each client's current model portfolio)
- `model_portfolio_holdings` (target weight per instrument, for that portfolio)
- `client_holdings` (actual quantity per instrument, most recent `as_of_date`)
- `instruments` (for readable names in the output)

Actual percentage weight isn't stored directly, it needs computing: a client's holding value in
one instrument, divided by their total holding value across all instruments, as a percentage.

## 3. Modelling changes needed

**None.** Every piece of data already exists across the four tables above. This is a query
problem, not a modelling problem, a good outcome for a team to reach explicitly, rather than
assuming new tables must be needed just because the request sounds complex.

## 4. Sketch of the approach

"For each client's current subscription, calculate their actual percentage weight in each
instrument they hold (their quantity's value divided by their total portfolio value), compare
it to that instrument's target weight in their subscribed model portfolio, and flag any
instrument where the difference is more than 5 percentage points."

## 5. Validation sentence

"So if a client's actual holding in an instrument is more than 5 percentage points away from
that instrument's target weight in their model portfolio, as of their most recent holdings
snapshot, that would show up on this report, is that what you meant by drift?"

## What to check as an instructor

- Teams correctly conclude no new modelling is needed, and can explain why, rather than
  reflexively adding a new table.
- The clarifying questions are genuinely open (not leading), and the assumptions chosen are
  reasonable and explicitly justified, not just invented arbitrarily.
- The validation sentence would actually make sense read aloud to someone with no SQL
  background, if it contains a column name or SQL keyword, it hasn't been translated properly.
- Teams that attempt the finish-early SQL extension often discover computing "value" requires a
  price, which none of these four tables actually store per holding, a good real example of a
  plan surviving contact with implementation revealing a gap the sketch missed.
