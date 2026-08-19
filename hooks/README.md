# Hooks

Evidence and provenance produced as a side effect of normal operation — the agentos principle, without the kernel. Two independent hooks; adopt either alone.

## commit-provenance.sh (git hook)

Appends machine-queryable trailers (`Agent-Session`, `Agent-Runtime`, `Provenance-Time`) to commits made during agent sessions. Human commits are untouched — the hook stamps only when a session id is present in the environment, and never guesses.

Install per repo:

```bash
ln -sf /home/ztan/Projects/agentos-skills/hooks/commit-provenance.sh <repo>/.git/hooks/prepare-commit-msg
```

Query later:

```bash
git log --format='%h %(trailers:key=Agent-Session,valueonly)'
```

## evidence-log.sh (Claude Code hook)

Appends one JSONL record per state-changing tool call to `.evidence/events.jsonl` in the project. Wire it in the target project's `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|Bash",
        "hooks": [{ "type": "command",
                    "command": "/home/ztan/Projects/agentos-skills/hooks/evidence-log.sh" }]
      }
    ]
  }
}
```

Notes:

- Ledgers are **append-only**. Corrections are new records; never rewrite.
- Add `.evidence/` to the target repo's `.gitignore` unless the project *wants* evidence versioned (a regulated repo might).
- `input_digest` truncates tool input to 400 chars — enough to identify the action without turning the ledger into a transcript. Raise it deliberately if an audit context needs full inputs.
- Requires `jq`.
