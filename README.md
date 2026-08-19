# agentos-skills

The durable substrate of [agentos](https://github.com/MSX-Securities-LLC/agentos-src), harvested into Claude Code skills and hooks.

agentos was a 62k-LOC TypeScript kernel for orchestrating fleets of coding agents. By mid-2026, ~70% of its surface (scheduling, worktree isolation, adapters, GitHub/Linear plumbing) was absorbed by vendor harnesses — exactly the absorption curve its own VISION.md predicted. This repo keeps the ~30% that stayed differentiated, reshaped to run *around* Claude Code instead of *beneath* it:

A second round of pruning followed a simple realization: **GitHub itself became the audit substrate.** PR review history is immutable, third-party-attested evidence — better than homegrown ledgers — and branch protection + required reviews are a fail-closed policy envelope enforced by someone else's uptime. Everything that competed with that got cut or demoted; what remains is only what has no PR-native analog.

| Asset | Was (agentos) | Is (here) |
|---|---|---|
| Review-loop protocol | Room-chat protocol between codex/claude | Superseded by GitHub PR review; discipline survives as `.claude/skills/pr-review-etiquette` |
| Landing gate + evidence records | Kernel merge gate, engagement summaries | `.claude/skills/landing-evidence` (PRs as the evidence record) |
| Decomposition-as-reviewed-artifact | Decomposer pipeline, task packs | `.claude/skills/decomposition-review` (still not commoditized) |
| Failure classification matrix | Supervisor recovery routing | `.claude/skills/failure-triage` |
| Steward policy envelope | Kernel-gated autonomous roadmap actions | `.claude/skills/steward-envelope` — dormant blueprint for unattended non-PR actions |
| Commit provenance + evidence ledger | Kernel-side record writers | `hooks/` (git + Claude Code hooks; supplementary to PR history) |
| Operating law (honesty policy, principle order) | agentos CLAUDE.md | `CLAUDE.md` |
| GitHub event-intake classifier | `src/github-pr-automation-events.ts` | `reference/` (dormant — GitHub/Anthropic ship this natively) |

## Layout

Harness-neutral by design (a cross-model review by Codex pushed this — the canonical layer must not re-create lock-in one level up):

- `AGENTS.md` — canonical operating law; `CLAUDE.md` is `@AGENTS.md` plus a Claude-only delta
- `.agents/skills/` — canonical portable skills; `.claude/skills/` holds only symlinks to them
- `.codex/` — Codex CLI adapter (activation/enforcement only, no protocol content)
- `hooks/` — harness-neutral evidence/provenance scripts with wiring instructions
- `tests/conformance.sh` — instruction indirection, skill discovery, and one fixture per hook adapter
- `reference/` — code and rule docs carried over verbatim from agentos for future use
- `VISION.md` — the strategy doc that predicted its own project's obsolescence, trimmed to what still governs

## Non-goals

No kernel. No scheduler. No dashboard. No adapters. If a future regulated product needs auditor-grade evidence that vendor harnesses still cannot produce, that is the one trigger for revisiting a standalone runtime — see VISION.md.

## Provenance

Source repo: `MSX-Securities-LLC/agentos-src`, archived read-only at commit `c7af79e` (2026-06-18). Salvage performed 2026-08-19.
