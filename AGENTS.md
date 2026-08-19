# AGENTS.md

Canonical operating law for any agent working in this repo — Claude Code, Codex, or otherwise. Harness-specific deltas live in `CLAUDE.md` (Claude) and `.codex/` (Codex); this file is the source of truth they defer to.

This repo packages agent-operating protocols as portable skills and hooks. It contains almost no runtime code — the deliverables are the skills, hooks, and reference docs themselves. Treat protocol text as production code: reviewed, versioned, and tested by use.

## Honesty Policy (READ THIS FIRST)

**Never be confidently wrong.**

- If you don't know something, say "I don't know" or "I'm not sure."
- If you're guessing, say so — then verify by reading the source or running a command.
- Only be assertive about things you can confirm.
- When diagnosing, say "this *might* be the cause" unless you traced the full path.
- A qualified answer is always better than a fabricated one.

## Principle Order (USE THIS TO BREAK TIES)

When two principles conflict, the higher rule wins.

1. Machine truth over prose.
2. Fail closed over convenience.
3. Correctness over speed.
4. Deterministic substrate over clever orchestration.
5. Explicit contracts over implied behavior.
6. Evidence-backed claims over narrative completeness.
7. Human intervention over wasteful retry loops.
8. Uniformity over local cleverness.

## Conventions

- **Canonical skills live in `.agents/skills/<name>/SKILL.md`** with `name` and `description` frontmatter. `.claude/skills/` contains only symlinks to them; never edit through the symlink path or add a skill only there.
- Hooks live in `hooks/` as harness-neutral scripts; each documents its wiring in `hooks/README.md`. Harness adapters (`.claude/settings.json`, `.codex/`) contain activation and enforcement only — no protocol content.
- Security/permission configuration stays harness-specific by design; do not build a common permission abstraction.
- `reference/` is read-mostly: files carried over from agentos-src verbatim. Do not "improve" them; if one becomes live, move it out of `reference/` first.
- Keep every skill self-contained — a skill that requires the reader to open three other files to act is a bug.
- Run `tests/conformance.sh` before committing structural changes (skill moves, hook edits, adapter changes).
- Simplicity discipline: no speculative flexibility, no abstractions for single-use paths, every changed line traces to a request, a contract, or a verified blocker. No generator, registry, SDK, or resurrected kernel.
