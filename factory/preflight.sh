#!/usr/bin/env bash
# Preflight: refuse to start a build pass where credentials that reach production
# are present (factory/RULES.md, rule 2). Prints names, never values.
# Exit 0: clear. Exit 1: stop and report what was printed.
#
# A cloud session's platform may set the variables it manages to a placeholder string
# and swap in the real credential outside the machine. That placeholder is not a
# credential, so it is let through.
#
# Add your own production variable names, one a line, to factory/production-env.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLACEHOLDER="proxy-injected"

stop=0
flag() { echo "STOP: $1"; stop=1; }

# A local database is fine; anything else may be production.
if [ -n "${DATABASE_URL:-}" ]; then
  if ! printf '%s' "$DATABASE_URL" | grep -qE '^[a-z]+://(.*@)?(127\.0\.0\.1|localhost)(:[0-9]+)?(/[^@]*)?$'; then
    flag "DATABASE_URL is set and is not a local database"
  fi
fi

names="AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE GOOGLE_APPLICATION_CREDENTIALS CLOUDFLARE_API_TOKEN"
if [ -f "$ROOT/factory/production-env" ]; then
  names="$names $(grep -vE '^[[:space:]]*(#|$)' "$ROOT/factory/production-env" | tr '\n' ' ')"
fi
for name in $names; do
  case "$name" in *[!A-Za-z0-9_]*) flag "factory/production-env holds a line that is not a variable name"; continue ;; esac
  value="${!name:-}"
  [ -z "$value" ] && continue
  [ "$value" = "$PLACEHOLDER" ] && continue
  flag "$name is set"
done

# A .env in the checkout usually holds what the variables above would.
[ -f "$ROOT/.env" ] && flag "a .env file is in the checkout: work in a clone or a worktree without one"

if [ "$stop" -eq 0 ]; then echo "preflight clear"; fi
exit "$stop"
