# Anti-Policy-Bloat Rules

Date: 2026-05-04

Use these rules whenever adding higher-loop recovery logic, runtime policy, or
new operator controls.

1. Policy only gates authority, scope, hard budgets, destructive actions,
   evidence requirements, and human-only boundaries.
2. Policy must not choose diagnosis, strategy, or recovery action from blocker
   semantics. That is model judgment.
3. A canary failure does not justify new policy by default. Record it as
   evidence, a test, model context, or backlog first.
4. Admit new policy only when it can be expressed as allow / deny / ask over
   action, scope, budget, or required evidence.
5. Repeated incidents become policy only when they reduce to a durable boundary;
   otherwise they remain incident memory or training/context material.
6. Delete or clarify ambiguous controls before adding policy around them.

## Admission Test

A proposed policy rule must answer yes to at least one:

- Does it enforce an authority boundary?
- Does it constrain file, project, or repair scope?
- Does it enforce a hard budget or retry ceiling?
- Does it block destructive or irreversible action?
- Does it make merge/acceptance evidence deterministic?
- Does it identify a human-only boundary?

Reject it if it answers yes to any of these:

- Does it inspect blocker prose to choose strategy?
- Does it encode a single incident or canary as a permanent rule?
- Does it add compliance-like behavior without a concrete boundary?
- Does it add a control whose workflow is still unclear?
