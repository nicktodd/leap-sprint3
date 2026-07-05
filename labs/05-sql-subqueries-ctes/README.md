# Module 05 Lab — Production-Grade Queries, Pair Exercise

## Objectives

By the end of this lab you will have:

- Written scalar and correlated subqueries
- Written the same result using a CTE and a derived table, and compared readability
- Peer-reviewed a partner's SQL
- Used GenAI to propose an alternative query formulation, then critiqued whether it was
  actually clearer or just different

## Setup

- The enterprise schema, loaded in Module 02
- GitHub Copilot Chat
- A partner

## Task sheet

Work in pairs. One of you writes first, the other reviews, then swap for the next task.

1. **Scalar subquery**: write a query listing every `BUY` transaction with a price above the
   average `BUY` price across the whole table.

2. **Correlated subquery**: write a query listing every account alongside the date of its most
   recent transaction. Explain in one sentence why this subquery has to run once per account,
   rather than once overall.

3. **CTE**: using a `WITH` clause, compute each client's total `BUY` value across all their
   accounts, then select only the clients whose total is above the average total across all
   clients.

4. **The same thing, as a derived table**: rewrite task 3 without a CTE, as a subquery inside
   `FROM`. Compare the two versions with your partner: which is easier to read, and why? Which
   would be easier to modify later if a new condition needed adding?

5. **Peer review**: swap queries with your partner (not just within your pair, if there's time,
   swap with another pair too). Check: is the SQL correct? Is it readable? Would you understand
   it cold, without the person who wrote it explaining it?

6. **GenAI: propose, then critique**: pick your most complex query from tasks 1-4. Ask Copilot
   Chat to propose an alternative formulation. Write down:
   - What did it propose, and how does it differ from yours?
   - Is it actually clearer, or just different? Be specific about why.
   - Would you actually adopt it, or keep your original? Justify your answer.

## Acceptance criteria

- A correct scalar subquery and a correct correlated subquery, each with a one-sentence
  explanation of how they differ in execution.
- A CTE and a derived table producing the same result, with a written comparison of readability.
- Written peer review notes on at least one query from your partner.
- A written critique of GenAI's alternative formulation that goes beyond "yes" or "no", it
  should say specifically what's different and why that does or doesn't make it better.

If you finish early, try writing task 3 a third way, using a window function instead of a
second aggregate pass, does it read more clearly, or less?
