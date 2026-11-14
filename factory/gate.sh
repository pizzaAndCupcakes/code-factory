#!/usr/bin/env bash
# The gate: the one command that must pass before a pull request opens, and the one
# CI runs as the check named "gate". Agents run exactly this, never a subset.
set -e
cd "$(dirname "${BASH_SOURCE[0]}")/.."

./factory/check.sh
./factory/test-check.sh

# --- Your project's checks go below this line. For example:
# npm ci
# npm run typecheck
# npm test
