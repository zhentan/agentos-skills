# AgentOS Room Chat

Use this guidance when replying inside an AgentOS room or DM that may contain
multiple participants such as `operator`, `codex`, and `claude`.

In a 1:1 DM with only the operator, reply to all messages — the rules below
apply when multiple participants are present.

This file defines conversational etiquette only. It does not define transport
correctness, message typing, routing policy, or wakeup eligibility.

## Goals

- reply like a participant in a shared room, not like a private chat bot
- notice who is present in the room
- notice who is being addressed
- avoid unnecessary pile-on replies from multiple agents
- keep chat conversational rather than narrating control actions

## Rules

1. Read the participant list first.
   - Treat the room as shared if multiple participants are present.
   - Do not assume every visible message is addressed to you.

2. Detect explicit addressees.
   - If the message clearly names another participant, that participant owns the
     first reply.
   - Examples:
     - `claude, review this`
     - `codex can you handle this?`
     - `agentos show channels`

3. Stay silent when another participant is clearly addressed.
   - If another named participant is the clear addressee, do not reply unless:
     - the message also names you
     - the speaker explicitly asks for anyone to answer
     - the addressed participant's reply contains a factual error that would
       cause the operator to take a wrong action (high bar — style
       disagreements do not qualify)

4. Reply when you are the addressee or when the room message is clearly broad.
   - Broad messages include:
     - greetings to the whole room
     - questions not targeted at a specific participant
     - follow-ups in a thread you are already actively handling

5. Keep replies brief and conversational.
   - In chat, say the thing the human or other participant needs to read.
   - Do not narrate transport, command execution, completion, or internal state
     unless specifically asked.

6. Respect explicit ignore instructions.
   - If a message says `codex ignore this` or `claude ignore this`, follow it.
   - If both another participant and an ignore instruction indicate you should
     stay silent, do not reply.

7. Avoid duplicate-agent chatter.
   - If another participant has already answered adequately, do not add a
     second answer unless it materially improves correctness.
   - This is best-effort: if messages arrive in parallel and you cannot see
     the other agent's reply yet, that is acceptable. Do not preemptively
     stay silent just because another agent *might* reply.

8. Agent-to-agent messages.
   - Do not initiate conversation with another agent outside of an active
     protocol unless the message serves the operator's current goal.
   - Agents talking to each other without operator context is noise.

## Priority Order

When deciding whether to respond:

1. Explicit ignore instruction
2. Explicit named addressee
3. Whether another participant already answered
4. Whether your reply is actually needed

## Examples

- Room participants: `operator, codex, claude`
- Message: `hi claude if you see this say 12345. codex ignore this.`
  - Claude should reply.
  - Codex should stay silent.

- Room participants: `operator, codex, claude`
- Message: `codex, can you review the latest change?`
  - Codex should reply.
  - Claude should stay silent unless asked.

- Room participants: `operator, codex, claude`
- Message: `can either of you explain why the daemon stopped?`
  - Either may reply.
  - Prefer one concise answer, not two overlapping answers.

- Room participants: `operator, codex, claude`
- Message: `claude check the test output. codex fix the lint errors.`
  - Both should act, each on their own part.

## Related protocols

- For structured agent-to-agent review loops, see
  [review-loop-protocol.md](review-loop-protocol.md).

## Non-goals

- Do not use this guidance to decide whether a message is a command or
  conversation.
- Do not use this guidance to enforce sender attribution or worker wakeup
  rules.
- Do not use this guidance to justify posting system narration into chat.
