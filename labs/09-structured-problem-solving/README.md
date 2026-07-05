# Module 09 Lab — Structured Problem-Solving Session

## Objectives

By the end of this lab you will have:

- Broken an ambiguous data requirement into modelling and query sub-tasks
- Sequenced your decisions before writing any schema or SQL
- Practised communicating a modelling decision to a non-technical stakeholder

## The ambiguous requirement

*(As it actually arrived, in a message from the Compliance team.)*

> "Can we get a way to see which of our clients have drifted significantly from their model
> portfolio? We keep finding out about this too late."

That's the whole brief. No stakeholder is available today to answer follow-up questions
directly, your team has to make and document reasonable assumptions, the way you would if a
real stakeholder were slow to respond and you needed to keep moving.

## Setup

- `shared/mission-brief.md` and your team's schema from Modules 06-08

## Task sheet

Work through this as a team, in order, don't skip ahead to schema or SQL.

1. **Clarify requirements**: write down every question you would ask Compliance if they were in
   the room. Then, since they're not, write down the assumption your team is making for each
   question, and why it's reasonable.

2. **Identify entities and data needed**: using your assumptions, list exactly which existing
   tables and columns would answer this. Be specific.

3. **Decide modelling changes, if any**: does anything need to be added to the schema, or is
   this answerable with the tables you already have? Justify your answer.

4. **Sketch the approach, in words**: write a plain description of how you'd compute "drift" and
   flag clients, in a sentence or two, not SQL yet.

5. **Validate in plain English**: write the exact sentence you'd say to a Compliance
   stakeholder to confirm your understanding before building anything, e.g. "So, if a client is
   more than X percentage points over target in a single fund, that would show up on this
   report, is that what you meant?"

6. **Present**: one person from your team presents steps 1-5 to another team (playing the role
   of Compliance), and takes their questions.

## Acceptance criteria

- A written list of clarifying questions and the assumption made for each one.
- A specific list of tables/columns needed, with a clear yes/no on whether new modelling is
  required, and why.
- A plain-English sketch of the approach, not SQL.
- A validation sentence that would make sense to someone who has never seen the schema.
- You've presented to, and taken questions from, another team.

If you finish early, actually write the SQL for your approach and check it runs against your
Module 08 schema, did your plain-English sketch translate cleanly, or did something turn out
trickier than expected once you tried to write it?
