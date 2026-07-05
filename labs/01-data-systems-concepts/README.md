# Module 01 Lab — OLTP or OLAP?

## Objectives

By the end of this lab you will have:

- Classified eight real-world systems as OLTP, OLAP, or a genuine mix of both
- Justified each classification with a specific, concrete reason
- Understood where this week's own schema work sits in the broader landscape

## Setup

- [`systems-to-classify.md`](systems-to-classify.md) from this lab

## Task sheet

1. Work through all eight systems in `systems-to-classify.md`.
2. For each, write:
   - Your classification (OLTP, OLAP, or both)
   - One specific reason, referencing how the system is actually *used* (who queries it, how
     often, how much data at once), not just a guess
3. For any system you classify as "both," explain which parts are OLTP and which are OLAP,
   systems rarely split cleanly, and noticing that is part of the skill.
4. Place this week's own work on the same map: is the enterprise schema you'll query in Modules
   02-05 OLTP or OLAP? Is the mission data model you'll build from Module 06 onward the same or
   different?

## Acceptance criteria

- All eight systems have a stated classification and a specific justification.
- At least one system is correctly identified as having genuine elements of both, with an
  explanation of which parts are which.
- You've placed this week's own schemas on the OLTP/OLAP map, with reasoning.

If you finish early, discuss with a partner: for system 5 (fraud detection), the *data* comes
from an OLTP system (the transactions themselves) but the *processing* looks like OLAP. Is that
a contradiction, or is that actually normal?
