# Code factory

Four AI agents that take a tracker issue from a one-line idea to a merged pull
request, and the rules that keep one person in charge of them without reading a
diff.

It runs on Claude Code (scheduled cloud sessions), Linear and GitHub Actions.

## Where it comes from

One person ran an earlier version of this for six weeks on one product. In that time
263 pull requests merged, all written by agents. The agents were never the slow
part: 57% of the time a pull request spent open came after its final review, waiting
for the person. This version is that factory with six changes made in answer.

| What went wrong | What this version does |
|---|---|
| Reviewed pull requests waited a median of 21 hours for a person to merge them | A workflow merges a pull request that is armed and green (`.github/workflows/merge.yml`) |
| Work waited on the person in places their list did not show | `/decisions` gathers every kind of waiting into one list, one item at a time |
| Left alone, the factory built what it had filed for itself | A weekly ceiling on self-filed work, and the weekly review owns intake |
| The reviewer never sent back a change of 60 lines or fewer | Small changes skip the reviewer; CI and the merge workflow are the gate |
| No check met the product the way a customer does | A customer pass that must go through a real client |
| The docs every agent read first reached 83 KB | One home per rule, and a size budget the build enforces |

The six changes are new. They pass this repository's own checks and an end-to-end
test of the merge workflow (this repository's first pull requests), and they have
not yet run for six weeks.

## What is here

| Path | What it is |
|---|---|
| `factory/RULES.md` | Every rule, each in one place |
| `.claude/agents/` | The refiner, the evaluator, the implementor, the reviewer |
| `.claude/skills/` | The scheduled passes, and `/decisions` |
| `.github/workflows/merge.yml` | Merges what is armed and green; disarms on a push |
| `factory/check.sh` | The factory's own tests: size budgets, one home per rule |
| `factory/SETUP.md` | How to put it in your project |

## How a change moves

1. You write an issue in a sentence and give it a priority and a goal.
2. The **refiner** turns it into a spec with acceptance checks that can be run.
3. The **evaluator**, a fresh agent, decides whether the spec is ready, and sends it
   back if not.
4. The **implementor** writes the tests, then the code, and opens a pull request.
5. The **reviewer**, a fresh agent, checks it against the spec, and arms it.
6. CI runs the gate. The merge workflow merges it.

You answer `/decisions` when something is yours: a question, a step only you can
take, or an empty queue.

## Two rules worth stealing

**Decide and tell.** An agent takes any decision that can be undone, and records what
it chose and the one step that reverses it. What cannot be undone, or spends money or
speaks in public, waits for the person.

**One list, one at a time.** Everything that waits on the person is in one place, and
they are shown one item at a time, with the options, the costs and a recommendation.

## Start

You need Claude Code with scheduled cloud sessions, a Linear team and a GitHub
repository with Actions. Then follow `factory/SETUP.md`.

## Licence

MIT. See `LICENSE`.
