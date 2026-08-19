# Review Loop Protocol

Use this protocol when two agents are doing an explicit review-fix loop in a
shared AgentOS room. One agent reviews, one agent fixes. The goal is a short,
observable loop with minimal chatter.

All participants still follow `agentos-room-chat.md` for baseline turn-taking.
This file narrows behavior further during an active review loop.

## Roles

- **Reviewer**: inspects the declared scope and posts findings or approval.
- **Fixer**: addresses reviewer findings, commits fixes, and hands back a new
  commit to review.

Roles are assigned in the kick-off message. Either agent can fill either role.

## Activation

The loop is opt-in. It starts when either:

- the operator posts:

```text
REVIEW LOOP: <reviewer> reviews, <fixer> fixes
scope: <diff range | latest commit | file list | other explicit scope>
max-rounds: <N, default 5>
severity: <blocking-only | any, default blocking-only>
```

- or the fixer posts the same kick-off immediately after creating a new commit,
  but only when no review loop is already active for that thread.

Until that message appears, normal room etiquette applies and this protocol is
inactive.

## Allowed Messages

During an active loop, only these protocol messages should appear:

### Reviewer

```text
REVIEW [round N of M]:
- [ ] <file>:<line> — <issue description>
- [ ] <file>:<line> — <issue description>
total: <count> issues
```

or

```text
REVIEW COMPLETE [round N of M]: no issues found.
```

or, if the round limit is exhausted:

```text
ROUND LIMIT REACHED [round N of M]:
- [ ] <file>:<line> — <issue description>
total: <count> issues remain
```

### Fixer

```text
REVIEW LOOP: <reviewer> reviews, <fixer> fixes
scope: <commit-hash>
max-rounds: <N, default 5>
severity: <blocking-only | any, default blocking-only>
```

or

```text
FIXES APPLIED [round N]: <commit-hash>
- [x] <file>:<line> — <what changed>
- [x] <file>:<line> — <what changed>
```

### Operator

```text
REVIEW LOOP: stop
```

## Forbidden Chatter

Do not post any of the following during an active loop:

- `standing by`
- `continuing`
- `acknowledged`
- `ready for re-review`
- conversational reassurance that does not change turn ownership
- side discussion between reviewer and fixer

If you have nothing protocol-advancing to say, stay silent.

## Turn Ownership

- After the kick-off message, the reviewer owns the next turn.
- After `REVIEW [...]`, only the fixer should speak next.
- After `FIXES APPLIED [...]`, only the reviewer should speak next.
- After `REVIEW COMPLETE [...]`, the loop is over.
- After `ROUND LIMIT REACHED [...]`, the loop is over until the operator
  decides what to do next.
- If it is not your turn, stay silent.

This applies even if you think you have a useful comment. The point of this
protocol is to keep the loop deterministic and low-noise.

## Review Scope

- Review only the declared scope.
- On later rounds, review only the fixer's new commit or diff since the last
  review round.
- Do not reopen accepted issues unless a later commit reintroduced them.
- Do not expand the review to unrelated files.

## What Counts as an Issue

When `severity: blocking-only`:

- bugs or incorrect behavior
- broken contracts or invalid assumptions
- missing boundary handling that can fail at runtime
- security problems
- failing tests or missing tests for newly changed behavior

When `severity: any`, the reviewer may also raise:

- weak tests
- maintainability problems tied to the changed code
- clarity issues that materially affect correctness

Do not raise:

- stylistic preferences
- speculative refactors
- unrelated cleanup

## Fixer Responsibilities

- Address the findings or consciously leave them unresolved.
- If you create a new commit outside an already-active loop, start a review loop
  immediately after the commit by posting the standard `REVIEW LOOP:` kick-off.
- Commit before posting `FIXES APPLIED` unless the operator explicitly asked
  for an uncommitted pass.
- In `FIXES APPLIED`, reference only the issues you actually changed.
- If blocked, ask one concise blocking question instead of posting protocol
  filler.

## Reviewer Responsibilities

- Tie each issue to a file and line when possible.
- Judge the new commit, not the fixer's intent.
- If no issues remain in scope, post `REVIEW COMPLETE` immediately.
- If issues remain after the round limit, post `ROUND LIMIT REACHED` instead of
  continuing indefinitely.

## Example Session

```text
operator: REVIEW LOOP: claude reviews, codex fixes
          scope: latest commit
          max-rounds: 3
          severity: blocking-only

claude:   REVIEW [round 1 of 3]:
          - [ ] src/kernel/scheduler.ts:42 — off-by-one skips the last task
          - [ ] src/kernel/scheduler.ts:78 — unchecked null from db query
          total: 2 issues

codex:    FIXES APPLIED [round 1]: a1b2c3d
          - [x] src/kernel/scheduler.ts:42 — changed < to <=
          - [x] src/kernel/scheduler.ts:78 — added null check with early return

claude:   REVIEW [round 2 of 3]:
          - [ ] src/kernel/scheduler.ts:78 — null path returns undefined but
                caller expects Task and will throw
          total: 1 issue

codex:    FIXES APPLIED [round 2]: d4e5f6a
          - [x] src/kernel/scheduler.ts:78 — return a Task-shaped fallback

claude:   REVIEW COMPLETE [round 3 of 3]: no issues found.
```

## Non-goals

- This protocol does not define how an agent reads diffs or runs tests.
- This protocol does not replace command routing or room transport rules.
- This protocol does not decide when to merge. The operator does.

See also:

- [higher-loop-room-protocol.md](./higher-loop-room-protocol.md) for when this
  review loop belongs in the operator room at all.
