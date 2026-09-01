# Seller forecast and crm note draft automation sample

Use this automation when Scout should help a seller act on this signal: Detect when recent customer activity should become a forecast comment, activity note, or CRM update draft.

```text
Name: Forecast and CRM note draft

Trigger type: Condition

Condition: Recent customer activity changes timing, scope, risk, next steps, stakeholder alignment, decision criteria, or forecast confidence.

Purpose:
Detect when recent customer activity should become a forecast comment, activity note, or CRM update draft.

Why it matters:
Forecast quality depends on current notes. Scout drafts the update while the signal is fresh.

Estimated time saved:
10-15 min saved per CRM update

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Forecast and CRM note draft",
  "description": "Detect when recent customer activity should become a forecast comment, activity note, or CRM update draft.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review recent customer meetings, emails, Teams messages, transcripts, tasks, and opportunity context. Identify signals that should change forecast confidence, next steps, CRM activity notes, or opportunity comments. Draft a CRM-safe note with key updates, risks, next steps, and owner. Do not update CRM without approval.",
  "steps": [
    {
      "label": "Forecast and CRM note draft",
      "prompt": "Review recent customer meetings, emails, Teams messages, transcripts, tasks, and opportunity context. Identify signals that should change forecast confidence, next steps, CRM activity notes, or opportunity comments. Draft a CRM-safe note with key updates, risks, next steps, and owner. Do not update CRM without approval."
    }
  ],
  "condition": "Recent customer activity changes timing, scope, risk, next steps, stakeholder alignment, decision criteria, or forecast confidence.",
  "conditionCheckInterval": 15,
  "oneShot": true
}
```
