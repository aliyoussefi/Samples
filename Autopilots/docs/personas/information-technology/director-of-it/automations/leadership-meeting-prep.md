# Director of IT leadership meeting prep automation sample

Use this automation when Scout should prepare a Director of IT for executive, budget, security, roadmap, vendor, or operations meetings.

```text
Name: IT leadership meeting prep

Trigger type: Condition

Condition:
Run when the Director of IT has an executive, budget, security, roadmap, vendor, compliance, or operations meeting in the next 24 hours.

Purpose:
Prepare a concise meeting brief so the Director of IT walks in with current risks, decisions, blockers, and recommended talking points.

Inputs:
- Calendar events in the next 24 hours
- Related Outlook and Teams threads
- Meeting transcripts and notes where available
- Tickets, project trackers, dashboards, and files related to the meeting topic
- Prior unresolved heartbeat and automation items

Steps:
1. Identify meeting topic, attendees, and likely decision points.
2. Gather relevant IT signals from recent communications and systems.
3. Summarize risks, decisions needed, blockers, and follow-ups.
4. Draft talking points and questions for the meeting.

Output:
- Meeting brief
- Decisions needed
- Open risks or blockers
- Recommended talking points
- Draft follow-up note outline

Guardrails:
- Do not send meeting materials without approval.
- Do not include sensitive details that are not appropriate for the attendee list.
```

## Scout automation JSON

```json
{
  "name": "IT leadership meeting prep",
  "description": "Prepare a Director of IT for executive, budget, security, roadmap, vendor, compliance, or operations meetings.",
  "triggerType": "condition",
  "condition": "The Director of IT has an executive, budget, security, roadmap, vendor, compliance, or operations meeting in the next 24 hours.",
  "conditionCheckInterval": 60,
  "enabled": true,
  "oneShot": true,
  "teamsNotify": "always",
  "prompt": "Review calendar events in the next 24 hours and related Outlook, Teams, meeting transcripts, notes, tickets, project trackers, dashboards, files, and unresolved heartbeat or automation items. Identify the meeting topic, attendees, likely decision points, relevant IT signals, risks, blockers, decisions needed, follow-ups, recommended talking points, and draft follow-up note outline. Do not send meeting materials without approval and do not include sensitive details inappropriate for the attendee list.",
  "steps": [
    {
      "label": "Prepare IT leadership meeting brief",
      "prompt": "Review calendar events in the next 24 hours and related Outlook, Teams, meeting transcripts, notes, tickets, project trackers, dashboards, files, and unresolved heartbeat or automation items. Identify the meeting topic, attendees, likely decision points, relevant IT signals, risks, blockers, decisions needed, follow-ups, recommended talking points, and draft follow-up note outline. Do not send meeting materials without approval and do not include sensitive details inappropriate for the attendee list."
    }
  ]
}
```
