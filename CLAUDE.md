# Code factory

A software factory for one person or a small team: four agents take a tracker issue
from a one-line idea to a merged pull request. This repository is the template. Copy
it into a project, then replace this paragraph with what the project is and who it
is for.

Every agent reads this file first. Keep it to facts that hold for every task;
`factory/check.sh` fails the build when it passes 4,000 bytes.

## Project facts

- **Tracker:** Linear, team `<TEAM>`, issue key `<KEY>` (so issues read `<KEY>-123`).
- **Gate:** `./factory/gate.sh`, the one command that must pass before a PR opens. CI
  runs the same command as the check named `gate`.
- **Production:** agents never touch it. Name here what production is, and which
  commands are the person's to run.
- **The person:** whoever answers `/decisions`.

## Map

| File | What it is |
|---|---|
| `factory/RULES.md` | The factory's rules, each in one place. Read it before any factory work |
| `factory/STANDARDS.md` | The code standard the reviewer blocks on |
| `factory/GOALS.md` | What the work is for, with one label per goal |
| `factory/PRODUCT.md` | How a customer meets the product; what the customer pass uses |
| `factory/SETUP.md` | One-time setup, for a person |
| `factory/check.sh` | The factory's own tests: size budgets and one home per rule |
| `.claude/agents/` | The four agents, one step each |
| `.claude/skills/` | The scheduled passes, and `/decisions` |
| `.github/workflows/merge.yml` | Merges a pull request that is armed and green |
