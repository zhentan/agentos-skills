# Vision (carried over from agentos, trimmed to what still governs)

The original agentos VISION.md made one strategic bet: **treat intelligence as perishable, infrastructure as compounding.** Scheduling heuristics, failure taxonomies, workflow sequencing, and decomposition strategies get absorbed into models and vendor harnesses; durable state, evidence, resource boundaries, trust verification, and coordination protocols endure.

That bet settled in 2026, against the project and in favor of the thesis. Claude Code (subagents, hooks, headless, worktrees, scheduled agents), Codex cloud, Copilot coding agent, and Linear agent delegation absorbed the kernel's perishable 70% within months of its last commit. What follows is the part of the vision that still holds, governing this repo.

## What endures

- **Evidence and auditability.** Regulated environments need verifiable records no matter how capable agents become. Evidence must be produced as a side effect of normal operation, not post-hoc log scraping. For a regulated product, an agent action is simultaneously a change-control, access-control, review-and-approval, vendor-usage, and record-retention event.
- **Trust verification.** No model judges its own work. Cross-model adversarial review is not a scaling problem — it is an epistemological one.
- **Fail closed.** Evaluator crash? Block. Unknown exit code? Don't retry blindly. Conflicting signals? Escalate. The cost of a false negative is always higher than a false positive.
- **Policy separates from mechanism.** The model proposes typed actions; a mechanical gate (allowlist, budget) decides; every decision lands in a durable ledger.
- **Decomposition is where intelligence belongs; execution is where infrastructure should dominate.** Plans become reviewed artifacts before they become runnable work, and the decomposition itself gets adversarially reviewed.

## Current form

These principles now ship as skills and hooks around vendor harnesses instead of a standalone kernel. That is not a retreat — it is the Bitter Lesson executed on ourselves.

## The one resumption trigger

Build a standalone runtime again only if: a regulated product requirement is real, **and** vendor harnesses still cannot produce auditor-grade evidence for agent actions at that time. Both conditions, not either.

## Lineage

Full original: `MSX-Securities-LLC/agentos-src` @ `c7af79e` (`VISION.md`), archived 2026-06. Inspirations preserved there: Sutton's Bitter Lesson, OpenAI's "Harness Engineering," Anthropic's harness-design writeups.
