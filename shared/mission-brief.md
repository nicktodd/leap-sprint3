# The Mission: PaySprint Wealth — Model Portfolio Service

This is the business brief your team will design a data model against from Module 06 onward,
implement in Postgres in Module 12, and extend for historical trade data in the Module 13
capstone. It's deliberately separate from the enterprise schema you've been querying in
Modules 02-05, that schema is for practising queries against something already built; this
brief is for practising building something yourself.

## The brief, as given by the (fictional) Product Owner

> PaySprint Wealth is launching a **Model Portfolio service**. A model portfolio is a
> pre-defined mix of instruments at target weights, e.g. "Balanced Growth" might target 40%
> global equity fund, 30% corporate bond fund, 30% cash. Clients subscribe to a model portfolio
> instead of picking individual holdings themselves.
>
> We need a data model that supports:
>
> 1. Recording which model portfolios exist, and what instruments and target weights make each
>    one up. A model portfolio's target composition can change over time (we might rebalance
>    "Balanced Growth" next quarter), and we need to know what it looked like at any point in
>    the past, not just its current composition.
> 2. Recording which client is subscribed to which model portfolio, and since when. A client
>    can change which model portfolio they're subscribed to over time, and we need to keep that
>    history too, not just their current subscription.
> 3. Recording each client's actual current holdings (quantity of each instrument they hold),
>    which may **drift** from their model portfolio's target weights over time as markets move,
>    even without them buying or selling anything.
> 4. Reporting, for any client, their current holdings **against** their model portfolio's
>    target weights, so an advisor can see at a glance how far a client has drifted.
>
> We are **not** asking for a full trade history yet, that's a later piece of work (a working
> capstone team will come back to that). For now we just need current state, done properly.

## Known entities to start from (not necessarily the final list)

- **Client**: an individual with an account at PaySprint Wealth
- **ModelPortfolio**: a named, managed mix of instruments (e.g. "Balanced Growth", "Income
  Focus", "Adventurous Growth")
- **Instrument**: something that can be held (reuse the same concept as the enterprise
  schema's `instruments` table, asset class, ticker, currency)
- Some way of recording a model portfolio's **target composition** (which instruments, what
  weight) that can change over time
- Some way of recording which client is **subscribed** to which model portfolio, that can
  change over time
- Some way of recording a client's **actual current holdings**

You will work through exactly how these relate to each other, and what normal form the result
should be in, across Modules 06-08.

## What happens later (context, not yet part of the task)

Module 13's capstone extends this same schema to add historical trade data, once the current-
state model is built and working. You don't need to design for that yet, but it's worth knowing
it's coming: a data model that's needlessly hard to extend later is itself worth avoiding now.
