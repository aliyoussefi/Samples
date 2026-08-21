# Scout heartbeat prompts for role-based enablement

Scout heartbeat is a recurring, user-scoped reasoning loop. The schedule answers **when to wake up**; the prompt defines **what context to re-check, what unresolved items to carry forward, when to stay silent, and when to ask the user for approval-ready action**.

Use these samples when enabling Frontier users who want Scout to act as an always-on assistant for a specific job role.

---

## Core heartbeat pattern

Every role-specific heartbeat prompt should follow the same structure:

1. **Role:** Tell Scout what job it is performing for the user.
2. **Context:** Define the recent signals Scout should inspect.
3. **State:** Tell Scout to compare new signals against prior unresolved items.
4. **Decision:** Tell Scout to stay silent when nothing meaningful changed.
5. **Output:** Define the exact nudge or approval-ready artifact to produce.
6. **Guardrails:** Require approval before sending messages, updating systems, or acting externally.

The key distinction:

> Cowork automates workflows; Scout operationalizes the user's day through stateful, user-facing reasoning.

---

## Prompt design rules

- **Prefer action over summaries.** Heartbeat should answer, "What needs my attention now?"
- **Carry unresolved items forward.** The prompt should tell Scout to remember prior open threads and suppress duplicates once resolved, dismissed, or snoozed.
- **Stay silent by default.** A good heartbeat does not interrupt unless there is a high-confidence action.
- **Make output approval-ready.** Ask Scout to draft the message, task, note, or system update, but not send or write it without approval.
- **Keep outbound content safe.** Customer-facing or team-facing drafts should not expose private calendar, email, or internal details unless the user confirms.
- **Tune to the role.** IT admins need operations risk and escalations; sellers need deal follow-through; managers need coaching and forecast signals; account executives need account, stakeholder, and relationship continuity.

---

## Available samples

| Role | Sample prompt |
|---|---|
| IT Admin | [IT admin heartbeat prompt](heartbeat-prompts/it-admin.md) |
| Seller / Sales Specialist | [Seller heartbeat prompt](heartbeat-prompts/seller.md) |
| Sales Manager | [Sales manager heartbeat prompt](heartbeat-prompts/sales-manager.md) |
| Account Executive | [Account executive heartbeat prompt](heartbeat-prompts/account-executive.md) |

---

## Reusable starter template

```text
Act as my always-on [role] copilot.

Every heartbeat, review my recent work context: [signals], plus unresolved items from prior heartbeat runs.

Your goal is to detect [role-specific outcomes] that need attention now.

Look for:
- [signal 1]
- [signal 2]
- [signal 3]
- [signal 4]

Compare what changed since the last heartbeat against prior unresolved items and known business state.

If nothing meaningful needs action, stay silent.

If action is needed, provide:
1. What changed
2. Why it matters
3. Recommended next action
4. Draft message, note, task, or update for approval if useful

Do not send messages, update systems, or act externally without my explicit approval.
Suppress duplicate reminders once I resolve, dismiss, or snooze an item.
```

