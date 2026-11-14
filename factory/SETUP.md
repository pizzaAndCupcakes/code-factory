# Setup

One-time steps, for a person. Nothing here is read by the agents.

## 1. Copy the factory into your project

Copy `CLAUDE.md`, `factory/`, `.claude/` and `.github/workflows/` into your
repository. Then:

- In `CLAUDE.md`, replace the first paragraph and fill in "Project facts".
- In `factory/gate.sh`, add your project's checks under the line that says so.
- Fill in `factory/GOALS.md` and `factory/PRODUCT.md`.
- List any production variable names of your own in `factory/production-env`.

Run `./factory/gate.sh`. It should print `factory checks passed`.

## 2. The tracker

The factory uses Linear. In your team:

- States: Backlog, Todo, In Progress, In Review, Done (Linear's defaults).
- Create the issue labels in the table in `factory/RULES.md` ("Tracker"), plus one
  `goal-` label per goal in `factory/GOALS.md`.
- Connect Linear to the GitHub repository, so a PR whose title starts with the issue
  key links to its issue and closes it on merge.
- Create two log issues, "Quality log" and "Customer log", and name them in
  `CLAUDE.md` and `factory/PRODUCT.md`.

## 3. GitHub

```
gh label create auto-merge --description "Armed: merges when the gate is green"
gh label create small --description "Small path: no reviewer, CI is the gate"
gh label create needs-user --description "Waits on the person; holds a merge"
```

- Protect `main` and require the `gate` check, so nothing reaches it unchecked even
  by hand.
- The merge workflow needs no setting beyond the labels. If a push to `main` must
  start another workflow (a deploy), add a token that can merge as the secret
  `MERGE_TOKEN`: a merge made with the default token starts nothing.
- Whoever can label a pull request can merge it. Keep triage rights to people and
  agents you would let merge.

## 4. The scheduled passes

Each pass is a scheduled cloud session of Claude Code with this repository and the
Linear connector, told only to run its skill. A starting schedule:

| Pass | Prompt | How often |
|---|---|---|
| Refine | `/factory-refine` | Three times a day |
| Work | `/factory-work` | Six times a day |
| Customer | `/customer-pass` | Daily, in an environment that holds its test account |
| Quality | `/quality-pass` | Twice a week |
| Weekly review | `/weekly-review` | Mondays |

Give no pass a production credential. `factory/preflight.sh` stops a build pass that
finds one.

## 5. The first issue

Write one issue in a sentence, give it a priority and a goal label, and run
`/factory-refine` by hand. Read the spec it writes. Then run `/factory-work`, and
`/decisions` to see what waits on you.

## 6. Check the merge workflow

Open a two-line pull request that touches nothing under `.github/`, `.claude/` or
`factory/`, and label it `small` and `auto-merge`. It should merge within a minute
of the `gate` check going green. Label one that touches `factory/` the same way:
the workflow should remove `auto-merge` and say why.
Then push a commit to an armed pull request: the label should come off.
Arm it again, and it merges when the gate is green.

## What you still do

Supply ideas, answer `/decisions`, and run the steps marked `Your step:`. If you find
yourself reading diffs, a check is missing: add it to the gate.
