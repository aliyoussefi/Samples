# Seller stakeholder and decision signal watch automation sample

Use this automation when Scout should help a seller act on this signal: Watch for changes in stakeholders, decision criteria, timing, procurement, or executive alignment.

```text
Name: Stakeholder and decision signal watch

Trigger type: Condition

Condition: Recent customer activity indicates a change in stakeholders, decision criteria, budget, procurement, timing, urgency, or executive alignment.

Purpose:
Watch for changes in stakeholders, decision criteria, timing, procurement, or executive alignment.

Why it matters:
Decision signals are easy to miss. Scout helps sellers adapt deal strategy before the opportunity drifts.

Estimated time saved:
10-20 min saved per signal

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Stakeholder and decision signal watch",
  "description": "Watch for changes in stakeholders, decision criteria, timing, procurement, or executive alignment.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review recent customer emails, Teams messages, meetings, transcripts, CRM notes, and opportunity context. Identify changes in stakeholders, decision criteria, budget, procurement, timing, urgency, or executive alignment. Explain why the signal matters commercially and draft a recommended seller action, internal alignment note, or CRM update for approval. Do not send or update systems without approval.",
  "steps": [
    {
      "label": "Stakeholder and decision signal watch",
      "prompt": "Review recent customer emails, Teams messages, meetings, transcripts, CRM notes, and opportunity context. Identify changes in stakeholders, decision criteria, budget, procurement, timing, urgency, or executive alignment. Explain why the signal matters commercially and draft a recommended seller action, internal alignment note, or CRM update for approval. Do not send or update systems without approval."
    }
  ],
  "condition": "Recent customer activity indicates a change in stakeholders, decision criteria, budget, procurement, timing, urgency, or executive alignment.",
  "conditionCheckInterval": 15,
  "oneShot": true
}
```
