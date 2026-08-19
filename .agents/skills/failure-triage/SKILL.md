---
name: failure-triage
description: Classify an agent/task failure into one of four modalities before reacting — retry, revise, bypass, or escalate. Use when a build, agent run, test suite, or automation fails and the next step isn't obvious, or when the user asks to triage a failure.
---

# Failure Triage

Ported from agentos's supervisor. The core rule: **never blind-retry.** Classify first; each modality has a different correct response, and applying the wrong one wastes budget or hides real breakage.

## Evidence precedence

When signals conflict, trust them in this order:

1. **Signal/artifact files** written by the failing process (structured completion/error records)
2. **Supervisor intent** (did something deliberately stop it — timeout, human stop, budget cap?)
3. **Exit code**
4. **Output pattern matching** (stderr/stdout regex) — last resort, weakest evidence

## The four modalities

| Modality | Signature | Response |
|---|---|---|
| **Infra transient** | Network flake, rate limit, OOM-adjacent resource contention, service restart | Retry with backoff. Cap retries; count them. |
| **Code rejection** | Tests fail, review found real issues, output rejected on the merits | Revise with the feedback attached. Retrying unchanged input is a protocol violation. |
| **Fatal environmental** | Missing credentials, wrong toolchain, broken checkout, incompatible versions | Bypass the retry budget entirely — no retry can succeed. Fix the environment or escalate. |
| **Budget exhausted** | Attempt/time/token cap reached without convergence | Escalate to a human. The residue is now narrower than another full loop; a human decision beats another attempt. |

## Traps (hard-won)

- **Exit 137 is not "OOM".** It is `sigkill_unknown` — could be timeout, human stop, or OOM. Demand corroborating evidence (dmesg, supervisor record) before treating it as memory pressure.
- **Poison pill:** the same task crashing repeatedly across restarts is not transient no matter what the individual failures look like. Track a crash count; past threshold, escalate.
- **Both a success artifact and an error artifact present = protocol corruption.** Trust neither; investigate before any retry.
- Conflicting signals with no tiebreaker → fail closed: escalate, don't guess.
