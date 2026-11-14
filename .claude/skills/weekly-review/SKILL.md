---
name: weekly-review
description: The week on one page for the person, written as one tracker issue. Each goal with what could be read of it, what shipped, what waits on them, what was decided for them, how the factory ran. Also owns intake by giving up to five Backlog issues a priority. Run on Mondays, or by hand with /weekly-review.
---

# Weekly review

A factory can merge fifty PRs in a day. The person cannot read fifty PRs and should
not have to. Once a week this pass puts what happened on one page, in the order a
person deciding what matters would want it.

The reader has ten minutes and a phone. Every line tells them something or points at
where to dig. A figure you could not read is written "not read", with who can read
it. A week in which nothing moved is said to be that.

Read `CLAUDE.md`, `factory/RULES.md` and `factory/GOALS.md` first.

## The week

Monday 00:00 UTC to Sunday 24:00 UTC, the last one that has ended. The issue is
titled `Weekly review: week ending <the Sunday's date>`, labelled `weekly-review`,
assigned to the person, with no priority. If one for that week exists, write nothing.

Read last week's review first: its numbers are this week's "last week".

## The page

1. **Written at:** the time `date -u` prints just before you write.
2. **The goals.** Each goal in `factory/GOALS.md`: its reading this week against last
   week, and where the reading came from. No reading: "not read".
3. **What shipped,** grouped by goal label, one line a PR. Self-filed work is its own
   group, with its share of the week's merges.
4. **What waits on you:** the count of each kind `/decisions` lists, and the oldest.
5. **What was decided for you:** the count of `decided` issues not yet reviewed.
6. **How the factory ran:** merged PRs, the median time from final review to merge,
   PRs the reviewer sent back, PRs that took the small path, specs sent back, and
   anything a pass said got in its way.
7. **Look here first:** up to three things, each with a link.

## Intake

This pass owns the supply, as RULES.md ("The supply") says.

- Read the Backlog issues with no priority. Give a priority and a goal label to up to
  **five** that serve a goal, the ones that move a goal's reading soonest first.
  Record each as a `Decided.` with the label `decided`; clearing the priority
  reverses it.
- If the goal queue is empty and nothing in the Backlog serves a goal, say so as the
  first item under "Look here first".
- If self-filed work was more than a third of the week's merges, say so there too.

## What a pass never does

- Touch production, a dashboard or a bill by any route its environment was not given.
- Change code, a branch or a PR, or a priority the person set.
- Guess a figure, or carry last week's forward as this week's.

Every comment this pass writes starts with `**[weekly-review]**`.
