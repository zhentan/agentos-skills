#!/usr/bin/env bash
# Codex-adapter fixture: feed one Codex-shaped PostToolUse payload through the
# shared evidence hook and verify a valid ledger line lands.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

printf '{"session_id":"codex-conf","tool_name":"apply_patch","tool_input":{"changes":"x"},"tool_response":{}}' \
  | CODEX_PROJECT_DIR="$TMP" bash "$ROOT/hooks/evidence-log.sh"

[ -f "$TMP/.evidence/events.jsonl" ] || { echo "no ledger written" >&2; exit 1; }
jq -e '.session=="codex-conf" and .tool=="apply_patch" and .ok==true' \
  "$TMP/.evidence/events.jsonl" >/dev/null || { echo "malformed record" >&2; exit 1; }
echo "codex adapter fixture: OK"
