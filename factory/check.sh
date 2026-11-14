#!/usr/bin/env bash
# The factory's own tests. CI runs them through factory/gate.sh.
#   1. Size budgets: what every agent reads first stays small.
#   2. One home per rule: every citation of RULES.md names a section that exists,
#      every agent and skill points at RULES.md, and labels are defined in one table.
#   3. One number, two places: the small-path limit in RULES.md and in merge.yml agree.
# Prints every failure, then exits 1 if there was one.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

fail=0
bad() { echo "FAIL: $1"; fail=1; }
size() { wc -c < "$1" | tr -d ' '; }

budget() {
  if [ ! -f "$1" ]; then bad "$1 is missing"; return; fi
  local n; n=$(size "$1")
  [ "$n" -le "$2" ] || bad "$1 is $n bytes; its budget is $2"
}

# 1. Budgets.
budget CLAUDE.md 4000
budget factory/RULES.md 16000
budget factory/STANDARDS.md 5000
for f in .claude/agents/*.md; do budget "$f" 3500; done
for f in .claude/skills/*/SKILL.md; do budget "$f" 5000; done
if [ -f CLAUDE.md ] && [ -f factory/RULES.md ]; then
  first=$(( $(size CLAUDE.md) + $(size factory/RULES.md) ))
  [ "$first" -le 20000 ] || bad "CLAUDE.md and factory/RULES.md are $first bytes together; every agent reads both first, and the budget is 20000"
fi

# 2. One home per rule.
while IFS= read -r name; do
  [ -z "$name" ] && continue
  grep -qxF "## $name" factory/RULES.md || bad "something cites RULES.md (\"$name\"), and RULES.md has no section of that name"
done < <(grep -rhoE --include='*.md' 'RULES\.md \("[^"]+"\)' CLAUDE.md README.md factory .claude 2>/dev/null | sed -E 's/.*\("([^"]+)"\).*/\1/' | sort -u)

for f in .claude/agents/*.md .claude/skills/*/SKILL.md; do
  grep -q 'factory/RULES.md' "$f" || bad "$f never points at factory/RULES.md, so its rules have no home"
done

# A label is defined by a table row that starts with its name in backticks. Only RULES.md may hold one.
labels=$(grep -oE '^\| `[a-z-]+(<[a-z]+>)?` \|' factory/RULES.md | sed -E 's/^\| `([a-z-]+).*/\1/' | sort)
dupes=$(printf '%s\n' "$labels" | uniq -d)
[ -z "$dupes" ] || bad "RULES.md defines a label twice: $(echo $dupes)"
for l in afk hitl refined needs-user changes-requested review-passed small decided; do
  printf '%s\n' "$labels" | grep -qx "$l" || bad "RULES.md has no row for the label $l"
  hits=$(grep -rlE --include='*.md' "^\| \`$l\` \|" CLAUDE.md README.md factory .claude 2>/dev/null | grep -v '^factory/RULES.md$' || true)
  [ -z "$hits" ] || bad "the label $l is defined again outside RULES.md: $(echo $hits)"
done

# 3. The small-path limit.
limit=$(grep -oE 'at most [0-9]+ changed lines' factory/RULES.md | grep -oE '[0-9]+' | head -1)
flow=$(grep -oE 'SMALL_MAX: [0-9]+' .github/workflows/merge.yml 2>/dev/null | grep -oE '[0-9]+' | head -1)
if [ -z "$limit" ] || [ -z "$flow" ]; then
  bad "the small-path limit is missing from RULES.md (\"at most N changed lines\") or from merge.yml (SMALL_MAX)"
elif [ "$limit" != "$flow" ]; then
  bad "RULES.md says small is $limit changed lines and merge.yml says $flow"
fi

# The pieces the rules name.
for f in factory/gate.sh factory/preflight.sh; do
  [ -x "$f" ] || bad "$f is missing or not executable"
done
for f in factory/GOALS.md factory/PRODUCT.md .github/workflows/ci.yml .github/workflows/merge.yml; do
  [ -f "$f" ] || bad "$f is missing"
done

[ "$fail" -eq 0 ] && echo "factory checks passed"
exit "$fail"
