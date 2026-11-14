# The product, as a customer meets it

What the customer pass uses (`.claude/skills/customer-pass/SKILL.md`). Tests prove
the code matches the spec; this page says how to prove the product works for someone
who arrives through their own tool. Replace everything below with your own.

## Clients

The real clients customers use, each with how a customer installs it. The pass takes
them in turn and never substitutes a hand-written request for one.

| Client | How a customer gets it | What the pass needs to run it |
|---|---|---|
| A browser | Opens the site | A headless browser in the pass's environment |
| The command-line tool | `<install command>` | Nothing else |
| An agent's tool connection | Adds the server in their agent's settings | That agent, or its official client library |

## Paths

The things a customer comes to do, most common first. The pass takes one to the end.

1. First run: from the front page or the README to a first result.
2. The main job: the one thing the product is for.
3. Coming back: the second visit, with whatever the first one left behind.

## Contracts

Everything a client reads and depends on: each tool, command, endpoint or schema by
name. The pass checks every one is present and usable in the real client. A change
to any of these needs a check through a real client or validator
(`factory/RULES.md`, "A spec that is ready").

## Limits for the pass

- The test account or key it uses, and where its environment holds it.
- What it may write, if anything. The default is nothing.
- The customer log: the tracker issue where each pass leaves its comment.
