# Seller stalled opportunity watch automation sample

Use this automation when Scout should help a seller act on this signal: Watch for active opportunities that have gone quiet, lack next steps, or show weak progression signals.

```text
Name: Stalled opportunity watch

Trigger type: Schedule

Schedule: every Monday, Wednesday and Friday at 9am

Purpose:
Watch for active opportunities that have gone quiet, lack next steps, or show weak progression signals.

Why it matters:
Quiet deals can look healthy until they miss a milestone. Scout turns weak signals into early action.

Estimated time saved:
20-30 min saved per pipeline review

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Stalled opportunity watch",
  "description": "Watch for active opportunities that have gone quiet, lack next steps, or show weak progression signals.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review open opportunity context, recent Outlook and Teams activity, meeting history, CRM notes where available, tasks, and unresolved heartbeat items. Identify opportunities with stale customer engagement, missing next steps, unanswered threads, no recent meeting follow-up, or close-date risk. Rank the top stalled opportunities and draft recommended seller actions, internal updates, or CRM notes for approval. Do not update CRM or send messages without approval.",
  "steps": [
    {
      "label": "Stalled opportunity watch",
      "prompt": "Review open opportunity context, recent Outlook and Teams activity, meeting history, CRM notes where available, tasks, and unresolved heartbeat items. Identify opportunities with stale customer engagement, missing next steps, unanswered threads, no recent meeting follow-up, or close-date risk. Rank the top stalled opportunities and draft recommended seller actions, internal updates, or CRM notes for approval. Do not update CRM or send messages without approval."
    }
  ],
  "schedule": "every Monday, Wednesday and Friday at 9am"
}
```
