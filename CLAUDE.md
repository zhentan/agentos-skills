# CLAUDE.md

@AGENTS.md

Claude-only delta (everything substantive lives in AGENTS.md):

- Skills are discovered via `.claude/skills/` — those are symlinks into the canonical `.agents/skills/`; edit the canonical files, never through the symlink path.
- Hook wiring for Claude Code sessions is documented in `hooks/README.md` (PostToolUse → `hooks/evidence-log.sh`; git prepare-commit-msg → `hooks/commit-provenance.sh`).
- The Codex adapter under `.codex/` is Codex's concern — don't edit it to solve a Claude-side problem.
