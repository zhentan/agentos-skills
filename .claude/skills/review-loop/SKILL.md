---
name: review-loop
description: Run a deterministic two-agent review-fix loop (one reviewer, one fixer) with strict turn ownership and zero filler. Use when the user asks for a review loop, adversarial review rounds, or cross-model review of a commit/diff.
---

# Review Loop Protocol

A short, observable loop between a **Reviewer** and a **Fixer** — two sessions, two subagents, or two models. Ported from agentos's room protocol; the transport is now whatever channel the two participants share (a PR thread, a shared file, an operator relaying messages, or a parent session orchestrating two subagents).

## Roles

- **Reviewer**: inspects the declared scope, posts findings or approval. Judges the commit, not the intent.
- **Fixer**: addresses findings, commits fixes, hands back a new commit.

Neither participant reviews its own work. Prefer different models for the two roles.

## Activation

The loop starts with an explicit kick-off:

```text
REVIEW LOOP: <reviewer> reviews, <fixer> fixes
scope: <diff range | latest commit | file list>
max-rounds: <N, default 5>
severity: <blocking-only | any, default blocking-only>
```

## Message grammar (the ONLY allowed messages)

Reviewer:

```text
REVIEW [round N of M]:
- [ ] <file>:<line> — <issue>
total: <count> issues
```

or `REVIEW COMPLETE [round N of M]: no issues found.`
or `ROUND LIMIT REACHED [round N of M]: <remaining issues>`

Fixer:

```text
FIXES APPLIED [round N]: <commit-hash>
- [x] <file>:<line> — <what changed>
```

Operator: `REVIEW LOOP: stop`

## Turn ownership

- After kick-off → reviewer speaks.
- After `REVIEW` → only the fixer speaks.
- After `FIXES APPLIED` → only the reviewer speaks.
- `REVIEW COMPLETE` or `ROUND LIMIT REACHED` ends the loop.
- Not your turn → stay silent, even if you have a useful comment.

## Forbidden

"standing by", "acknowledged", "ready for re-review", reassurance, side discussion. If a message doesn't advance the protocol, don't send it.

## Scope discipline

- Review only the declared scope; later rounds review only the new diff.
- Don't reopen accepted issues unless a later commit reintroduced them.
- `blocking-only` means: bugs, broken contracts, missing boundary handling, security problems, failing/missing tests for changed behavior. Never style preferences or speculative refactors.

## Fixer duties

- Commit before posting `FIXES APPLIED` (unless an uncommitted pass was requested).
- Reference only issues actually changed; consciously leave the rest with a stated reason.
- If blocked, ask one concise blocking question — not protocol filler.
