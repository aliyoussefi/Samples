# Scout heartbeat prompts for role-based enablement

Scout heartbeat is a recurring, user-scoped reasoning loop. The schedule answers **when to wake up**; the prompt defines **what context to re-check, what unresolved items to carry forward, when to stay silent, and when to ask the user for approval-ready action**.

Use these samples when enabling Frontier users who want Scout to act as an always-on assistant for a specific job role.

---

## Persona-centered layout

Heartbeat markdown and HTML files now live inside each persona folder:

```text
docs/
  personas/
    <division>/
      <persona>/
        heartbeat.md
        heartbeat.html
```

---

## Available samples

| Role | Heartbeat |
|---|---|
| IT Admin | [IT admin heartbeat prompt](personas/information-technology/it-admin/heartbeat.md) |
| Seller / Sales Specialist | [Seller heartbeat prompt](personas/sales/seller/heartbeat.md) |
| Sales Manager | [Sales manager heartbeat prompt](personas/sales/sales-manager/heartbeat.md) |
| Account Executive | [Account executive heartbeat prompt](personas/sales/account-executive/heartbeat.md) |
| Legal - Commercial Contracts Counsel | [Commercial contracts counsel heartbeat prompt](personas/legal-department/commercial-contracts-counsel/heartbeat.md) |
| Legal - Legal Operations Manager | [Legal operations manager heartbeat prompt](personas/legal-department/legal-operations-manager/heartbeat.md) |
| Human Resources - Talent Acquisition Lead | [Talent Acquisition Lead heartbeat prompt](personas/human-resources/talent-acquisition-lead/heartbeat.md) |
| Human Resources - HR Business Partner | [HR Business Partner heartbeat prompt](personas/human-resources/hr-business-partner/heartbeat.md) |
| Finance - Procurement Manager | [Procurement Manager heartbeat prompt](personas/finance/procurement-manager/heartbeat.md) |
| Finance - FP&A Manager | [FP&A Manager heartbeat prompt](personas/finance/fpa-manager/heartbeat.md) |

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
