---
name: steward-envelope
description: Fail-closed policy envelope for autonomous sessions — propose typed actions, gate them mechanically against an allowlist and budget, ledger every decision. Use when running unattended (scheduled agents, loops, autonomous roadmap/backlog work) or when the user asks for the steward pattern.
---

# Steward Envelope

> **Status: dormant blueprint.** For *code* changes, branch protection + required reviews already provide a fail-closed envelope enforced by GitHub — use that (see [[landing-evidence]]). This skill matters only for unattended agents taking **non-PR actions** (running commands, spending budgets, infra changes, scheduled triage). Activate it when that workload exists; don't invest before.

Ported from agentos's roadmap steward: the model proposes, a mechanical gate decides, every decision persists. The point is that autonomy is bounded by policy the model cannot argue with — "fail closed over convenience."

## The loop

For every action an unattended session wants to take:

1. **Type the action.** Before doing anything, state it as a record:

```json
{"ts":"<iso8601>","action":"<verb>","targets":["<paths or resources>"],
 "risk":"low|medium|high","rationale":"<one line>","evidence":"<what verified it's needed>"}
```

2. **Gate it mechanically.** An action is `auto_approved` only if ALL hold:
   - Every target path matches the allowlist in `steward-policy.json` (repo root; if the file is absent, the allowlist is empty and NOTHING is auto-approved).
   - Risk is `low`. Low means: docs, tests, comments, formatting, additive non-behavioral changes. Anything touching behavior, config, CI, dependencies, permissions, or deletion is not low.
   - Budget remains: the policy file's `max_auto_actions` per session has not been reached.
3. **Ledger the decision.** Append the record plus `"decision":"auto_approved|held|escalated"` to `.steward/gate-decisions.jsonl` **before** executing. Denials get ledgered too — a hold with no record is a protocol violation.
4. **Execute only `auto_approved` actions.** Everything else accumulates into an escalation summary for the human, with the ledger as backing evidence.

## Policy file shape

```json
{
  "allowlist": ["docs/**", "tests/**", "**/*.md"],
  "max_auto_actions": 10
}
```

The policy file is owned by the human. An autonomous session never edits `steward-policy.json` or `.steward/` contents beyond appending to the ledger — proposing a policy change is itself an escalation.

## Hard rules

- Uncertain whether an action fits the allowlist → it doesn't. Escalate.
- A crashed or ambiguous gate check blocks the action, never waves it through.
- The ledger is append-only JSONL. Never rewrite history; corrections are new records referencing the old `ts`.
- On session end, if anything was escalated, the final message leads with the escalation list, not the completed work.
