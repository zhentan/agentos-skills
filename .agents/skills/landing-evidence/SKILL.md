---
name: landing-evidence
description: Make GitHub the audit substrate — structure every agent-authored PR so its body, checks, and trailers form a self-contained evidence record. Use when opening a PR for agent-authored work, or when the user asks for an evidence-grade PR.
---

# Landing Evidence

For a regulated product, an agent code change is simultaneously a change-control, review, and record-retention event. GitHub's PR history is third-party-attested and immutable — better evidence than any self-written ledger. This skill makes each PR carry its evidence deliberately instead of incidentally.

## PR body template

```markdown
## What
<one paragraph: the change and why now>

## Verification
| Claim | How verified | Result |
|---|---|---|
| <behavior X works> | `<exact command>` | <pass/output summary> |
| <no regression in Y> | `<test suite / check>` | <pass> |

## Not verified
<anything shipped on inspection alone, stated plainly — an honest gap beats a fabricated pass>

## Residue
<follow-up work this PR deliberately excludes, filed as issues or listed here>

## Provenance
Authored by: <agent runtime + model> in session <id>
Reviewed by: <different model/human — never the author>
```

## Rules

- **Only claim what ran.** Every Verification row names the exact command; if the full suite wasn't run, say which subset was. Machine-captured results outrank prose restatements.
- **Checks are the enforcement.** Required status checks + branch protection make the evidence fail-closed: no green table, no merge. Do not merge through failing checks — fix or escalate.
- **Commits carry trailers** (`Agent-Session`, `Agent-Runtime` — see `hooks/commit-provenance.sh`), so `git log --format='%(trailers:...)'` reconstructs authorship without external records.
- **Cross-model review before merge.** Request review from a model that didn't author the change; the review thread itself is the adversarial-review record.
- **The PR is the record.** Don't restate its content into side ledgers; link to it. Session-level JSONL (see `hooks/evidence-log.sh`) is supplementary detail for what never reached a PR.
