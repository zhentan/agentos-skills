---
name: pr-review-etiquette
description: Discipline rules for agents participating in GitHub PR review loops — turn ownership, scope, severity, and zero filler. Use when reviewing a PR as an agent, responding to PR review feedback, or when two agents share a PR thread.
---

# PR Review Etiquette

GitHub PR review already provides what agentos's review-loop protocol hand-built: rounds, file:line anchors, approve/request-changes states, and an immutable third-party audit trail. What GitHub does NOT provide is discipline — two agents can still spam a thread into uselessness. These rules are the surviving part of the protocol, applied to PRs.

## Turn ownership

- After you submit a review requesting changes, the author owns the next move. Do not add follow-up comments while waiting.
- After pushing fixes, the reviewer owns the next move. One comment linking commits to findings ("addressed in `abc123`: …") is the handoff — then silence.
- Never review your own PR. Prefer a different model for the reviewer than the author ("no model judges its own work").

## Scope

- Review only the diff. On re-review, review only the delta since your last review.
- Do not reopen resolved threads unless a later commit reintroduced the issue.
- Do not expand into unrelated files, style preferences, or speculative refactors.

## Severity (default: blocking-only)

Raise only: bugs, broken contracts, missing boundary handling, security problems, failing or missing tests for changed behavior. Non-blocking observations go in at most one collected comment, clearly labeled non-blocking.

## Zero filler

Forbidden: "standing by", "acknowledged", "LGTM pending CI", reassurance, agent-to-agent side discussion. If a comment doesn't change what someone does next, don't post it.

## Format

- One review submission per round, findings as inline comments anchored to file:line — not a wall-of-text summary comment.
- Each finding: the defect, the failure scenario, and (if cheap) the fix. No essays.
- When done acting on a thread, resolve it; resolution state is part of the audit trail.
