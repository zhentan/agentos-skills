---
name: decomposition-review
description: Turn a plan into independently-executable tasks and adversarially review the decomposition itself before any implementation starts. Use when breaking a large feature/migration into parallel agent tasks, or when the user asks to decompose work.
---

# Decomposition Review

The agentos thesis that has NOT been commoditized: large-scale agent concurrency is a decomposition problem, not a scheduling problem — and the decomposition itself deserves review like code. Vendor harnesses give you subagents and workflows; nothing off-the-shelf reviews whether your task split is sound.

## Produce the decomposition as an artifact

Write a spec (markdown, in-repo or in the plan) where every task states:

1. **One dominant correctness question.** If a task proves two independent things, split it.
2. **Write surface.** The files/paths it may touch. Overlapping write surfaces between parallel tasks are a decomposition bug, not a merge problem to absorb later.
3. **Interface contract.** What it consumes from and exposes to sibling tasks — explicit enough that recombination is mechanical.
4. **Acceptance check.** The test or command that proves it done. "Seems to work" is not a check.
5. **Residue.** Known follow-up work it deliberately does not do, recorded as future tasks — not silently dropped.

## Adversarially review the decomposition BEFORE executing

Send the spec to a reviewer that did not write it (different model or fresh-context subagent) with this brief:

- Which tasks secretly share write surfaces or hidden ordering dependencies?
- Which task's acceptance check would pass while the feature is still broken?
- What integration work is unassigned — who recomposes the pieces, and what proves the composition?
- What is missing entirely?

Revise until the reviewer finds no blocking issues. Only then fan out execution.

## Execution rules

- Intelligent decomposition, mechanical execution: once the spec is approved, executors implement their task as written — an executor who discovers the spec is wrong stops and escalates rather than silently re-scoping.
- Acceptance criteria are frozen at approval. The party who wrote a task's implementation never rewrites its acceptance check.
