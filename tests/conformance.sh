#!/usr/bin/env bash
# Conformance check (per cross-model review): instruction indirection,
# skill discovery, and one fixture payload per hook adapter. Nothing more.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. Instruction indirection: CLAUDE.md defers to canonical AGENTS.md
grep -q '@AGENTS.md' "$ROOT/CLAUDE.md" || fail "CLAUDE.md does not reference AGENTS.md"
[ -f "$ROOT/AGENTS.md" ] || fail "AGENTS.md missing"

# 2. Skill discovery: every canonical skill has frontmatter; every .claude symlink resolves
for d in "$ROOT"/.agents/skills/*/; do
  s="$d/SKILL.md"
  [ -f "$s" ] || fail "missing SKILL.md in $d"
  head -6 "$s" | grep -q '^name:' || fail "no name frontmatter in $s"
  head -6 "$s" | grep -q '^description:' || fail "no description frontmatter in $s"
done
for l in "$ROOT"/.claude/skills/*; do
  [ -e "$l" ] || fail "dangling symlink: $l"
done
n_canon=$(ls -d "$ROOT"/.agents/skills/*/ | wc -l)
n_claude=$(ls "$ROOT"/.claude/skills/ | wc -l)
[ "$n_canon" -eq "$n_claude" ] || fail "skill count mismatch: $n_canon canonical vs $n_claude in .claude"

# 3. Hook fixtures
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

# 3a. evidence-log.sh: fixture payload -> one valid JSONL line
printf '{"session_id":"conf-test","tool_name":"Write","tool_input":{"file_path":"x"},"tool_response":{}}' \
  | CLAUDE_PROJECT_DIR="$TMP" bash "$ROOT/hooks/evidence-log.sh"
[ -f "$TMP/.evidence/events.jsonl" ] || fail "evidence-log wrote no ledger"
jq -e '.session=="conf-test" and .tool=="Write" and .ok==true' "$TMP/.evidence/events.jsonl" >/dev/null \
  || fail "evidence-log record malformed"

# 3b. commit-provenance.sh: stamps trailers only when a session id is present
MSG="$TMP/msg"; echo "test commit" > "$MSG"
CLAUDE_SESSION_ID=conf-test bash "$ROOT/hooks/commit-provenance.sh" "$MSG"
grep -q '^Agent-Session: conf-test' "$MSG" || fail "provenance trailer not stamped"
echo "clean commit" > "$MSG"
bash "$ROOT/hooks/commit-provenance.sh" "$MSG"
grep -q '^Agent-Session:' "$MSG" && fail "provenance stamped without session env"

# 3c. codex adapter fixture, if present
if [ -f "$ROOT/.codex/conformance-fixture.sh" ]; then
  bash "$ROOT/.codex/conformance-fixture.sh" || fail "codex adapter fixture failed"
fi

echo "conformance: OK"
