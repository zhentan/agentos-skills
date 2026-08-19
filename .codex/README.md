# Codex CLI adapter

Activation/enforcement only — protocol content lives in `AGENTS.md` and `.agents/skills/` (Codex reads `AGENTS.md` natively; no skill wiring is needed for the protocol text).

## What's here

- `hooks.json` — project-local `PostToolUse` wiring: `Bash|Edit|Write` tool calls append to the same `.evidence/events.jsonl` ledger the Claude Code adapter writes (shared script: `hooks/evidence-log.sh`, which discovers the project root harness-neutrally).
- `config.toml.example` — recommended sandbox/approval posture; copy what you want.
- `conformance-fixture.sh` — one Codex-shaped payload through the shared hook; invoked by `tests/conformance.sh`.

## Install

1. Trust the project layer: open Codex in this repo and accept the `.codex/` trust prompt.
2. Review and trust the hook: run `/hooks` in Codex — project-local hooks are listed, reviewed, and trusted against their current hash; a changed hook is re-flagged and skipped until re-trusted (fail-closed, as it should be).
3. Optionally copy `config.toml.example` into `.codex/config.toml`.

## Honest limitations (per the Codex hooks docs)

- Hosted tools (e.g. WebSearch) don't traverse the local function-tool hook path — those calls produce no ledger record.
- Some specialized tool paths can opt out of the default hook path: treat tool hooks as "a useful guardrail, not a complete enforcement boundary" (their words). The enforcement boundary for code changes remains branch protection + required review — see `.agents/skills/landing-evidence`.
- File edits arrive as `tool_name: "apply_patch"` (the `Edit|Write` matcher values are aliases), so ledger records from Codex sessions show `apply_patch` where Claude sessions show `Edit`/`Write`.

## Provenance

Specified by Codex CLI (gpt-5.x) in a cross-model review; transcribed by Claude because Codex's own sandbox — correctly — refuses to write to `.codex/`.
