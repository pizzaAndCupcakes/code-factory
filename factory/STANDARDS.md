# Code standard

What the reviewer blocks on, and what the implementor aims at. Add examples from your
own code under each rule as they turn up: a passing one and a failing one teach more
than the sentence does.

## Blocks and notes

**Blocks.** The reviewer sends the PR back, citing the rule and quoting the line, for:
a rule below broken in lines the PR adds; a failing gate; a second copy of something
that has a named home; an error turned into an empty result; added dead code; a
secret; an existing test edited to pass.

**Notes.** Reported, never blocking: a judgement about naming or size, and anything
in lines the PR did not touch.

**Existing debt is not a reason to block.** The quality pass owns debt already in the
tree. A PR is held to what it adds.

**Gates over judgement.** Where a rule can be a test or a lint, make it one and delete
the sentence.

## The rules

1. **One thing, at one level.** A function does one thing, and its body reads at one
   level of detail.
2. **Names that say what they mean.** A reader should not have to open the body to
   learn what a name holds.
3. **No duplication.** A rule, a limit, a parser or a sentence has one home. A second
   copy blocks.
4. **No dead or commented-out code.** An export nothing imports, a flag nobody sets, a
   block left "for later". Blocks when the PR adds it.
5. **Dependencies point inward.** The core does not import the edge: the code that
   decides knows nothing of the framework, the database driver or the vendor.
6. **Errors are handled where something can be done.** Never turned into an empty
   result or a default. A call out has a timeout. A fallback tells someone.
7. **Tests read as the specification.** Each is named for a behaviour a reader can
   check, and can fail.
8. **Comments say why.** What the code does is the code's job.
9. **Untrusted text is validated at the edge.** Checked where it enters, escaped
   where it is shown, never built into a query or a command.
10. **The cleanup stays inside the issue.** A tidy-up the issue did not ask for is a
    new issue, not a bigger diff.
