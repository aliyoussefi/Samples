# Seller poc, demo, and workshop readiness automation sample

Use this automation when Scout should help a seller act on this signal: Check whether upcoming demos, POCs, workshops, and technical sessions have owners, agenda, assets, and success criteria.

```text
Name: POC, demo, and workshop readiness

Trigger type: Condition

Condition: A demo, POC, workshop, technical validation, or enablement session is scheduled in the next 72 hours.

Purpose:
Check whether upcoming demos, POCs, workshops, and technical sessions have owners, agenda, assets, and success criteria.

Why it matters:
Good demos and workshops need prep. Scout catches missing prerequisites before the customer meeting.

Estimated time saved:
20-40 min saved per session

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "POC, demo, and workshop readiness",
  "description": "Check whether upcoming demos, POCs, workshops, and technical sessions have owners, agenda, assets, and success criteria.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review upcoming demos, POCs, workshops, technical validations, and enablement sessions in the next 72 hours. Check Outlook, Teams, calendar, tasks, shared files, opportunity context, and prior follow-ups. Identify missing agenda, owner, assets, prerequisites, success criteria, customer attendee alignment, and next-step plan. Draft a readiness checklist, internal prep note, or customer-safe agenda for review. Do not create artifacts, send messages, or update systems without approval.",
  "steps": [
    {
      "label": "POC, demo, and workshop readiness",
      "prompt": "Review upcoming demos, POCs, workshops, technical validations, and enablement sessions in the next 72 hours. Check Outlook, Teams, calendar, tasks, shared files, opportunity context, and prior follow-ups. Identify missing agenda, owner, assets, prerequisites, success criteria, customer attendee alignment, and next-step plan. Draft a readiness checklist, internal prep note, or customer-safe agenda for review. Do not create artifacts, send messages, or update systems without approval."
    }
  ],
  "condition": "A demo, POC, workshop, technical validation, or enablement session is scheduled in the next 72 hours.",
  "conditionCheckInterval": 60,
  "oneShot": true
}
```
