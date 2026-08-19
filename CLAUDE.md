# CLAUDE.md

This repo packages agent-operating protocols as Claude Code skills and hooks. It contains almost no runtime code — the deliverables are the skills, hooks, and reference docs themselves. Treat protocol text as production code: reviewed, versioned, and tested by use.

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

- Skills live in `.claude/skills/<name>/SKILL.md` with `name` and `description` frontmatter.
- Hooks live in `hooks/` as standalone scripts; each documents its own wiring in `hooks/README.md`. Never wire a hook into settings.json without documenting it there.
- `reference/` is read-mostly: files carried over from agentos-src verbatim. Do not "improve" them; if one becomes live, move it out of `reference/` first.
- Keep every skill self-contained — a skill that requires the reader to open three other files to act is a bug.
- Simplicity discipline: no speculative flexibility, no abstractions for single-use paths, every changed line traces to a request, a contract, or a verified blocker.
