# Module 06 Lab — Normalize the Messy Flat File

## Objectives

By the end of this lab you will have:

- Identified entities, relationships, and cardinality in the mission domain
- Normalized a denormalized flat-file dataset from 1NF (First Normal Form) through 3NF (Third
  Normal Form)
- Understood the trade-off between normalization and denormalization
- Produced the first draft of the tables your team will formalise in Module 07 and implement
  in Module 12

## Setup

- [`shared/messy-flat-file.csv`](../../shared/messy-flat-file.csv) from the repo root
- [`shared/mission-brief.md`](../../shared/mission-brief.md), for context on the domain

## Task sheet

Work as a team. This is pen-and-paper (or a shared doc/whiteboard) modelling exercise, not SQL,
that comes in Module 08 and Module 12.

1. **Identify the entities and relationships**
   From `messy-flat-file.csv` and the mission brief, list the entities you can see (Client,
   Model Portfolio, Instrument, and anything else you find), and describe the cardinality of
   each relationship between them (one-to-many, many-to-many).

2. **Find the redundancy**
   Pick two specific examples of the same fact repeated across multiple rows in the flat file
   (e.g. an advisor's name, or a model portfolio's target weight for one instrument). For each,
   name what would happen if that fact needed to change, how many rows would need updating, and
   what could go wrong if only some of them were updated correctly.

3. **Normalize to 1NF**
   Confirm (and justify) that the flat file already satisfies 1NF. What would a 1NF violation
   have looked like instead?

4. **Normalize to 2NF**
   Identify any partial dependency (a column that depends on only part of a composite key).
   Split it out into its own table.

5. **Normalize to 3NF**
   Identify any transitive dependency (a column that depends on another non-key column, not on
   the row's key itself). Split those out too.

6. **Write out your final table list**
   For each resulting table, list its columns and, in words, what its primary key would be
   (formal keys and constraints come in Module 08).

## Acceptance criteria

- A list of entities and their relationships, with cardinality stated for each.
- Two specific, concrete examples of redundancy in the flat file, with an explanation of the
  real risk each one creates.
- A final table list (at minimum: clients, model portfolios, instruments, model portfolio
  holdings, client subscriptions) that is genuinely in 3NF, with no remaining partial or
  transitive dependencies.

If you finish early, discuss: is there any part of this schema where you'd deliberately
denormalize, even at this early stage? If so, which, and why?
