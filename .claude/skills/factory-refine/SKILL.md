---
name: factory-refine
description: One pass of the factory's refine half. Picks up the person's answers, evaluates specs waiting from earlier runs, refines the top Backlog issues, and has each evaluated, reworking it in the same pass until it is ready or needs the person. Run on a schedule, or by hand with /factory-refine [issue].
---

# Factory: refine

One bounded pass over the Backlog. You change the tracker only. Read `CLAUDE.md` and
`factory/RULES.md` first.

If an issue ID was given, do steps 3 and 4 for that issue alone.

## 1. The person's answers

List issues labelled `needs-user`. On each, if the latest comment has no role tag and
follows an agent's questions, the person has answered: remove `needs-user`. An issue
in Backlog is then back in the queue. Do not touch one they have not answered.

## 2. Specs waiting from earlier runs

List Backlog issues labelled `refined`. For up to **three**, start the `evaluator`
agent with the issue ID and nothing else. If no agent can be started, evaluate them
yourself: an earlier session wrote these specs, so rule 1 of RULES.md ("Rules") holds.

## 3. Refine

Take up to **two** issues in the order RULES.md ("The queue") gives. Never skip an
issue for one further down. If the queue holds no issue with a goal label, say so in
the report as RULES.md ("The supply") asks, and do not go looking for other work.

For each, you are the refiner: follow `.claude/agents/refiner.md` from its first step
to its hand-off. Take each issue through step 4 before starting the next.

## 4. Evaluate, and rework until it is ready

For each issue you labelled `refined`, and each sub-issue you created:

1. Start a new `evaluator` agent with the issue ID and nothing else. Do not tell it
   what you think of the spec.
2. **Ready** or **Ask:** done.
3. **Revise:** as the refiner, fix every numbered defect and nothing else, comment
   what changed against each number, label it `refined` again, and go back to 1 with
   a **new** evaluator.

Keep going until the spec is Ready or a question goes to the person. The evaluator
ends the loop itself at the fifth failed evaluation. Never evaluate a spec you wrote
or reworked in this run; if no agent can be started, leave it `refined` for the next
run.

## 5. Report

A table: issue, what happened, how many evaluations it took, one line of why. Then
anything about the factory itself that got in the way. If there was nothing to do,
say so and stop.
