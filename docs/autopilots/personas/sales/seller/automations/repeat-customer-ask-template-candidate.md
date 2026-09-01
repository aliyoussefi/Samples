# Seller repeat customer ask template candidate automation sample

Use this automation when Scout should help a seller act on this signal: Find recurring customer questions or seller follow-up patterns that should become reusable templates or assets.

```text
Name: Repeat customer ask template candidate

Trigger type: Schedule

Schedule: every Friday at 3pm

Purpose:
Find recurring customer questions or seller follow-up patterns that should become reusable templates or assets.

Why it matters:
Repeated asks are a signal to scale seller productivity. Scout identifies what should become reusable.

Estimated time saved:
30-60 min saved per week

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Repeat customer ask template candidate",
  "description": "Find recurring customer questions or seller follow-up patterns that should become reusable templates or assets.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook, Teams, meeting notes, CRM notes, and prior seller follow-ups from the past week. Identify repeated customer questions, repeated seller requests, recurring technical asks, and repeated follow-up patterns. Recommend reusable templates, customer-ready snippets, FAQ content, deck updates, or process improvements. Draft a backlog item or asset outline for approval. Do not create artifacts or update repositories without approval.",
  "steps": [
    {
      "label": "Repeat customer ask template candidate",
      "prompt": "Review Outlook, Teams, meeting notes, CRM notes, and prior seller follow-ups from the past week. Identify repeated customer questions, repeated seller requests, recurring technical asks, and repeated follow-up patterns. Recommend reusable templates, customer-ready snippets, FAQ content, deck updates, or process improvements. Draft a backlog item or asset outline for approval. Do not create artifacts or update repositories without approval."
    }
  ],
  "schedule": "every Friday at 3pm"
}
```
