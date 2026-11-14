#!/usr/bin/env bash
# Tests for factory/check.sh: a check that cannot fail proves nothing. Each case
# copies the repository, breaks one thing, and expects check.sh to exit 1 and name it.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
n=0

fresh() { # a clean copy to break
  rm -rf "$TMP/repo"
  mkdir -p "$TMP/repo"
  (cd "$ROOT" && tar --exclude=.git -cf - .) | (cd "$TMP/repo" && tar -xf -)
}

expect_fail() { # name, text the output must hold
  n=$((n + 1))
  out="$("$TMP/repo/factory/check.sh" 2>&1)"; code=$?
  if [ "$code" -eq 0 ]; then
    echo "FAIL: case \"$1\": check.sh passed and should not have"; fail=1
  elif ! printf '%s' "$out" | grep -qF "$2"; then
    echo "FAIL: case \"$1\": check.sh failed without saying \"$2\". It said:"; printf '%s\n' "$out" | sed 's/^/    /'; fail=1
  fi
}

# The untouched copy passes.
fresh
n=$((n + 1))
"$TMP/repo/factory/check.sh" > /dev/null 2>&1 || { echo "FAIL: case \"clean copy\": check.sh fails on the repository as it is"; fail=1; }

fresh
head -c 4100 /dev/zero | tr '\0' 'x' >> "$TMP/repo/CLAUDE.md"
expect_fail "CLAUDE.md over its budget" "CLAUDE.md is"

fresh
echo 'See RULES.md ("A section nobody wrote").' >> "$TMP/repo/.claude/agents/refiner.md"
expect_fail "a citation of a missing section" 'has no section of that name'

fresh
grep -v 'factory/RULES.md' "$TMP/repo/.claude/agents/evaluator.md" | sed 's/RULES\.md/the rules/g' > "$TMP/evaluator.md"
cp "$TMP/evaluator.md" "$TMP/repo/.claude/agents/evaluator.md"
expect_fail "an agent that never points at the rules" "never points at factory/RULES.md"

fresh
printf '\n| `afk` | a second definition | someone |\n' >> "$TMP/repo/factory/STANDARDS.md"
expect_fail "a label defined outside RULES.md" "defined again outside RULES.md"

fresh
sed -i.bak -E 's/SMALL_MAX: [0-9]+/SMALL_MAX: 9999/' "$TMP/repo/.github/workflows/merge.yml"
expect_fail "the small-path limit disagreeing" "merge.yml says 9999"

fresh
rm "$TMP/repo/factory/GOALS.md"
expect_fail "a missing piece" "factory/GOALS.md is missing"

[ "$fail" -eq 0 ] && echo "check.sh: $n cases passed"
exit "$fail"
