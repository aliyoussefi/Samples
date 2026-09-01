# Seller customer follow-up watch automation sample

Use this automation when Scout should help a seller act on this signal: Watch for customer commitments, promised follow-ups, and unanswered customer asks that need seller action.

```text
Name: Customer follow-up watch

Trigger type: Condition

Condition: A customer email, Teams message, meeting note, or transcript indicates a promised follow-up, unanswered ask, or next step without a visible owner or response.

Purpose:
Watch for customer commitments, promised follow-ups, and unanswered customer asks that need seller action.

Why it matters:
Customer trust depends on quick, reliable follow-through. Scout catches commitments before they slip.

Estimated time saved:
10-20 min saved per detected follow-up

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Customer follow-up watch",
  "description": "Watch for customer commitments, promised follow-ups, and unanswered customer asks that need seller action.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review recent customer emails, Teams messages, meeting notes, transcripts, tasks, and unresolved seller follow-ups. Identify promised follow-ups, unanswered customer asks, missing owners, due dates, and next steps. Match each item to the likely account, opportunity, stakeholder, or workstream. Draft a concise customer follow-up or internal owner reminder for review. Do not send messages or update CRM without approval.",
  "steps": [
    {
      "label": "Customer follow-up watch",
      "prompt": "Review recent customer emails, Teams messages, meeting notes, transcripts, tasks, and unresolved seller follow-ups. Identify promised follow-ups, unanswered customer asks, missing owners, due dates, and next steps. Match each item to the likely account, opportunity, stakeholder, or workstream. Draft a concise customer follow-up or internal owner reminder for review. Do not send messages or update CRM without approval."
    }
  ],
  "condition": "A customer email, Teams message, meeting note, or transcript indicates a promised follow-up, unanswered ask, or next step without a visible owner or response.",
  "conditionCheckInterval": 15,
  "oneShot": true
}
```
