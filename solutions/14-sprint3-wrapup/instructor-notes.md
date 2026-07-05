# Module 14 Lab — Instructor Notes

No solution in the usual sense, this is a checklist. Notes on what good looks like and common
gaps.

## What good looks like

- **SQL fundamentals**: the IS NULL vs = NULL question is the fastest tell for whether Module 03
  really landed, delegates who hesitate here usually have a shakier foundation than their later
  module work suggests.
- **Data modelling**: 1NF/2NF/3NF explained with a *concrete example from their own schema*,
  not a recited textbook definition, is the real signal of understanding.
- **Beyond relational**: the NoSQL classification question should reference the *specific
  access pattern* of whatever new scenario is posed, not a generic "NoSQL is more scalable"
  answer.
- **Mission model**: "every team member can explain a table they didn't build" is the single
  most important item on this list, it's what Module 13 was actually testing for.

## Common gaps and quick fixes

| Gap | Likely cause | Quick fix |
|---|---|---|
| Confuses = NULL and IS NULL | Module 03 rushed | Re-run the demo's live example, watch = NULL silently return nothing |
| Can't explain 2NF/3NF with their own example | Memorised definitions without applying them | Walk through their own client_trades or model_portfolio_holdings table live |
| ER diagram doesn't match the running database | Schema evolved (Module 08, 13) without updating the diagram | Have them regenerate or hand-correct the diagram before Friday |
| client_trades and client_holdings don't reconcile | A data entry error in Module 13's sample data | Run the net-position query together and find the discrepancy |
| Only the "builder" can explain a table | Module 13's team-understanding step was rushed or skipped | Spend remaining time doing it properly now, this is the one gap not to let slide |

## Running the session

Fifteen to twenty minutes: five for the checklist walkthrough as a pair, the rest for closing
gaps. Circulate rather than lecture, this module works best as one-on-one triage, same as
Sprints 1 and 2's equivalent modules.
