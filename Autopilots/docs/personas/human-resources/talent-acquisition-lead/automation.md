# Talent Acquisition Lead automation sample

Use this automation when Scout should prepare a daily hiring pipeline and interview coordination queue.

```text
Name: Daily hiring pipeline and interview coordination queue

Schedule: Every weekday at 8:00 AM

Purpose:
Create a daily recruiting queue for candidate responsiveness, interview coordination, and hiring manager follow-through.

Inputs:
- Outlook emails from the last 24 hours
- Teams messages from hiring managers and interview loops
- Calendar interviews in the next 48 hours
- Recruiting systems where available
- Tasks and unresolved heartbeat items

Steps:
1. Identify candidate and hiring manager follow-ups.
2. Detect missing feedback, interview prep gaps, and offer blockers.
3. Group items by candidate, requisition, hiring manager, or loop.
4. Rank the top items that need attention today.
5. Draft candidate updates, hiring manager reminders, or interview prep notes.

Output:
- Top recruiting items needing action
- Candidate or requisition affected
- Current blocker
- Recommended next action
- Draft email or Teams update where applicable
- Suggested recruiting system note where applicable

Guardrails:
- Do not send messages.
- Do not update recruiting systems without approval.
- Do not expose interview feedback or compensation details in broad summaries.
- Keep candidate-facing language neutral, timely, and respectful.
```

## Scout automation JSON

```json
{
  "name": "Daily hiring pipeline and interview coordination queue",
  "description": "Create a daily recruiting queue for candidate responsiveness, interview coordination, and hiring manager follow-through.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook emails from the last 24 hours, Teams messages from hiring managers and interview loops, calendar interviews in the next 48 hours, recruiting systems where available, tasks, and unresolved heartbeat items. Identify candidate and hiring manager follow-ups, missing feedback, interview prep gaps, offer blockers, candidates, requisitions, hiring managers, and loops that need attention today. Draft candidate updates, hiring manager reminders, or interview prep notes. Do not send messages or update recruiting systems without approval.",
  "steps": [
    {
      "label": "Daily hiring pipeline and interview coordination queue",
      "prompt": "Review Outlook emails from the last 24 hours, Teams messages from hiring managers and interview loops, calendar interviews in the next 48 hours, recruiting systems where available, tasks, and unresolved heartbeat items. Identify candidate and hiring manager follow-ups, missing feedback, interview prep gaps, offer blockers, candidates, requisitions, hiring managers, and loops that need attention today. Draft candidate updates, hiring manager reminders, or interview prep notes. Do not send messages or update recruiting systems without approval."
    }
  ],
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 8am"
}
```
