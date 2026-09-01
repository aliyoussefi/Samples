# Seller customer meeting prep brief automation sample

Use this automation when Scout should help a seller act on this signal: Prepare the seller before customer meetings with context, open asks, opportunity status, and recommended questions.

```text
Name: Customer meeting prep brief

Trigger type: Condition

Condition: A customer or account meeting is scheduled in the next 24 hours and recent context suggests prep is needed.

Purpose:
Prepare the seller before customer meetings with context, open asks, opportunity status, and recommended questions.

Why it matters:
Sellers lose time rebuilding context before meetings. Scout makes the next conversation sharper.

Estimated time saved:
15-30 min saved per meeting

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Customer meeting prep brief",
  "description": "Prepare the seller before customer meetings with context, open asks, opportunity status, and recommended questions.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review calendar events in the next 24 hours, related Outlook and Teams threads, meeting transcripts, tasks, opportunity context, CRM notes, and prior unresolved follow-ups. Prepare a concise seller meeting brief with account context, opportunity status, open customer asks, recent commitments, likely risks, recommended discovery questions, and suggested next step. Do not send the brief or update systems without approval.",
  "steps": [
    {
      "label": "Customer meeting prep brief",
      "prompt": "Review calendar events in the next 24 hours, related Outlook and Teams threads, meeting transcripts, tasks, opportunity context, CRM notes, and prior unresolved follow-ups. Prepare a concise seller meeting brief with account context, opportunity status, open customer asks, recent commitments, likely risks, recommended discovery questions, and suggested next step. Do not send the brief or update systems without approval."
    }
  ],
  "condition": "A customer or account meeting is scheduled in the next 24 hours and recent context suggests prep is needed.",
  "conditionCheckInterval": 60,
  "oneShot": true
}
```
