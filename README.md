# agentos-skills

The durable substrate of [agentos](https://github.com/MSX-Securities-LLC/agentos-src), harvested into Claude Code skills and hooks.

agentos was a 62k-LOC TypeScript kernel for orchestrating fleets of coding agents. By mid-2026, ~70% of its surface (scheduling, worktree isolation, adapters, GitHub/Linear plumbing) was absorbed by vendor harnesses — exactly the absorption curve its own VISION.md predicted. This repo keeps the ~30% that stayed differentiated, reshaped to run *around* Claude Code instead of *beneath* it:

| Asset | Was (agentos) | Is (here) |
|---|---|---|
| Review-loop protocol | Room-chat protocol between codex/claude | `.claude/skills/review-loop` |
| Steward policy envelope | Kernel-gated autonomous roadmap actions | `.claude/skills/steward-envelope` |
| Failure classification matrix | Supervisor recovery routing | `.claude/skills/failure-triage` |
| Commit provenance + evidence ledger | Kernel-side record writers | `hooks/` (git + Claude Code hooks) |
| Operating law (honesty policy, principle order) | agentos CLAUDE.md | `CLAUDE.md` |
| GitHub event-intake classifier | `src/github-pr-automation-events.ts` | `reference/` (dormant, tested, pure) |

## Layout

- `.claude/skills/` — skills any Claude Code session in this repo (or symlinked into others) can invoke
- `hooks/` — evidence/provenance hooks with wiring instructions
- `reference/` — code and rule docs carried over verbatim from agentos for future use
- `VISION.md` — the strategy doc that predicted its own project's obsolescence, trimmed to what still governs

## Non-goals

No kernel. No scheduler. No dashboard. No adapters. If a future regulated product needs auditor-grade evidence that vendor harnesses still cannot produce, that is the one trigger for revisiting a standalone runtime — see VISION.md.

## Provenance

Source repo: `MSX-Securities-LLC/agentos-src`, archived read-only at commit `c7af79e` (2026-06-18). Salvage performed 2026-08-19.
