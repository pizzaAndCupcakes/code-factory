---
name: factory-work
description: One pass of the factory's build half. Reviews PRs waiting from earlier runs, then fixes one PR the reviewer sent back or builds the top ready issue into a PR, and has it reviewed unless it took the small path. Run on a schedule, or by hand with /factory-work [issue].
---

# Factory: work

One bounded pass: at most one issue built or fixed. Read `CLAUDE.md` and
`factory/RULES.md` first.

Before step 1, run `factory/preflight.sh`. If it exits non-zero, stop and report
exactly what it printed. Never print a credential's value to look closer.

If an issue ID was given, do steps 2 and 3 for that issue alone.

## 1. PRs waiting from earlier runs

List issues In Review with an open PR and none of `review-passed`,
`changes-requested`, `needs-user`, `small`. Add any with `review-passed` whose PR no
longer carries `auto-merge` and has a newer head than the pass names: remove
`review-passed` from those. For up to **two**, start the `reviewer` agent with the
issue ID and nothing else. If no agent can be started, review them yourself: an
earlier session wrote the code.

## 2. Build or fix one issue

Choose the first that exists:

1. An issue In Review with `changes-requested` and no `needs-user`, oldest first.
2. The top Todo issue with `afk`, in the order RULES.md ("The queue") gives.

Before taking a self-filed issue, count the ones built since Monday 00:00 UTC. At the
ceiling in RULES.md ("The supply"), skip it and take the next issue that is not
self-filed. If nothing with a goal label is ready, say so in the report; do not fill
the pass with other work.

For the issue you chose, you are the implementor: follow
`.claude/agents/implementor.md` from its first step to its hand-off.

## 3. Have it reviewed

If the PR took the small path, there is no review: the merge workflow and CI decide.

Otherwise start the `reviewer` agent with the issue ID and nothing else. Do not tell
it what you think of the code. You never review code you wrote in this run; if no
agent can be started, leave the issue In Review for the next run. If the reviewer
requests changes, the next run fixes them, not this one.

The verdict ends the pass. Do not wait on the PR or subscribe to it. No agent merges:
RULES.md ("Merging") says what does.

## 4. Report

The issue, the PR link, the gate's result, the path taken (reviewed or small), the
verdict if there was one, and what now waits on the person. Then anything about the
factory itself that got in the way. Do not start a second issue.
