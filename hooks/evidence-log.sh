#!/usr/bin/env bash
# Claude Code PostToolUse hook: append an evidence record for state-changing tool
# calls to .evidence/events.jsonl in the project root. Reads the hook payload from
# stdin (JSON), writes one JSONL line per event. Append-only; never rewrites.
#
# Wire in .claude/settings.json (see hooks/README.md). Requires jq.
set -euo pipefail

PAYLOAD="$(cat)"
# Harness-neutral project-root discovery: explicit env (either harness) first,
# then the enclosing git repo, then cwd.
ROOT="${CLAUDE_PROJECT_DIR:-${CODEX_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}}"
LEDGER_DIR="$ROOT/.evidence"
mkdir -p "$LEDGER_DIR"

jq -c \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{ts: $ts,
    session: (.session_id // "unknown"),
    tool: (.tool_name // "unknown"),
    input_digest: ((.tool_input // {}) | tostring | .[0:400]),
    ok: (if (.tool_response.error? // null) == null then true else false end)
   }' <<<"$PAYLOAD" >> "$LEDGER_DIR/events.jsonl"
