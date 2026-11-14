---
name: quality-pass
description: One quality pass over the code. Reads one area of the repository under one lens and files at most two issues labelled quality, each with the file, the line and what would show it fixed. Run on a schedule, or by hand with /quality-pass.
---

# Quality pass

The reviewer holds each PR to `factory/STANDARDS.md`, but only in the lines the PR
touches. Debt already in the tree has no owner. This pass is the owner: it reads code
no PR is touching, one area and one question at a time.

It is also the pass most able to keep a factory busy on itself, so it is the one the
supply rules bind hardest. Read `CLAUDE.md`, `factory/RULES.md` and
`factory/STANDARDS.md` first.

## Before reading any code

- Read the latest comment on the quality log (the issue `CLAUDE.md` names, or the
  newest issue titled "Quality log"): the lens and the area the last pass took.
- Count the open self-filed issues. At the limit in RULES.md ("The supply"), file
  nothing this pass: still read, and put what you find in the log.
- Take the next lens and the next area. Each moves one step a pass.

## The lenses

1. **A rule with two homes.** The same rule, limit, parser or sentence written twice.
2. **Hard to read.** A function doing more than one thing; a name that makes a reader
   open the body.
3. **A failure that hides.** An error turned into an empty result, a call out with no
   timeout, a loop that stops part-way and reports success.
4. **Untrusted text.** Input that reaches a query, a command, a page or a prompt
   without being checked where it enters.
5. **Secrets and limits.** A value that could be a credential in a log; a paid call
   or a route with no limit; a script that reaches production with no dry run.
6. **A decision that leaves no trace.** A step that drops, holds or falls back and
   records neither that it did nor why.
7. **A test that cannot fail.** One that asserts only that code ran, or a failure
   path with no test.
8. **Dead code.** An export nothing imports, a flag nobody sets.

## The areas

The top-level source directories, in alphabetical order. A project with a better
split lists it in `CLAUDE.md`.

## Filing

At most **two** issues a pass, labelled `quality`, priority Low. Each names the file
and line, quotes the code, says which rule of `factory/STANDARDS.md` it breaks, and
gives the check that would show it fixed. A finding you cannot locate to a line is
not filed. A pass that finds nothing says so.

End with one comment on the quality log, tagged `**[quality]**`: the lens, the area,
what was filed, what was seen and not filed.

## Limits

- You read and file. No code, no branch, nothing but the tracker.
- Never file a finding to fill the pass. Two true findings beat five.
