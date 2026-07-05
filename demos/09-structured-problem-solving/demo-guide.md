# Demo: Module 09 — Structured Problem-Solving, Breaking Down a Data Problem

**Duration:** 10 minutes
**Prerequisite:** none. Conceptual, using the mission model as the working example.

## Part 1: The problem with jumping straight to schema (2 min)

Narration: an ambiguous request lands, "Compliance wants to see clients who've drifted from
their model portfolio", and the instinct is to open a diagramming tool and start drawing boxes.
That's usually a mistake. Most of the real work in an ambiguous data problem is figuring out
what's actually being asked, before any table gets touched.

## Part 2: A structured sequence (5 min)

Walk through the five-step process on the slide diagram, using the drift example throughout:

1. **Clarify requirements.** What does "drifted" actually mean? Write down every question you'd
   ask a real stakeholder: Drifted from what, the target weight of one instrument, or the whole
   portfolio's shape? By how much before it counts as "significant"? As of right now, or over
   some period? A one-time report, or something that runs continuously?

2. **Identify entities and data needed.** Once the meaning is clearer (say, "any instrument
   more than 5 percentage points off its target weight, as of today"), work out what data
   already exists to answer it: `client_holdings`, `model_portfolio_holdings`,
   `client_subscriptions`. Is anything missing? (Here: nothing new, this is a query problem, not
   a modelling one.)

3. **Decide modelling changes, if any.** Sometimes the answer requires a schema change; often it
   doesn't. Being disciplined about checking this *before* writing SQL avoids either wasted
   modelling work or, worse, discovering halfway through a query that a needed fact was never
   captured.

4. **Sketch the query/report approach**, in words, before writing SQL: "for each client's
   current subscription, join their holdings to their target weights, calculate the percentage
   point difference, and flag anything over the threshold." This is a plan, not code, checkable
   by someone who isn't going to write the SQL themselves.

5. **Validate in plain English with the stakeholder**, before building. "So, if a client is 8
   percentage points over target in one fund, that would show up on this report, does that match
   what you meant by drift?" Confirms understanding before time is spent, not after.

## Part 3: Communicating the decision (2 min)

Narration: step 5 is worth practising deliberately, explaining a modelling or query decision to
someone who doesn't read SQL. The skill is translating "WHERE ABS(actual_pct - target_pct) > 5"
into "we'll flag anything more than 5 percentage points away from target," without losing
accuracy in the translation.

## Key message

Sequencing matters: clarify before modelling, model only if genuinely needed, sketch the
approach before writing SQL, and validate in plain English before building anything for real.
Skipping straight to schema or SQL on an ambiguous request is the single most common way teams
build the wrong thing quickly.
