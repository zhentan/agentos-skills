#!/usr/bin/env bash
# prepare-commit-msg git hook: append agent-provenance trailers to every commit
# made during an agent session. Human commits (no session env) pass through unchanged.
#
# Install into a repo:   ln -sf "$(pwd)/hooks/commit-provenance.sh" <repo>/.git/hooks/prepare-commit-msg
#
# Trailers follow git-interpret-trailers format, so they are machine-queryable:
#   git log --format='%(trailers:key=Agent-Session,valueonly)'
set -euo pipefail

MSG_FILE="$1"

# Only stamp when an agent session is identifiable; never guess.
SESSION="${CLAUDE_SESSION_ID:-${AGENT_SESSION_ID:-}}"
[ -z "$SESSION" ] && exit 0

# Don't double-stamp (amend/rebase paths re-run the hook).
grep -q '^Agent-Session:' "$MSG_FILE" && exit 0

{
  echo ""
  echo "Agent-Session: $SESSION"
  echo "Agent-Runtime: ${AGENT_RUNTIME:-claude-code}"
  echo "Provenance-Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
} >> "$MSG_FILE"
