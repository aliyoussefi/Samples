# Legal operations manager automation sample

Use this automation when Scout should prepare a weekly legal operations command brief.

```text
Name: Weekly legal operations command brief

Schedule: Every Monday at 7:30 AM

Purpose:
Prepare a legal operations chief-of-staff brief for the week.

Inputs:
- Outlook and Teams activity from the prior week
- Upcoming legal operations meetings
- Legal intake queues where available
- Matter management systems where available
- E-billing or outside counsel systems where available
- SharePoint, OneNote, Power BI, and tracker files where available

Steps:
1. Identify stale intake requests, open operational blockers, and unresolved stakeholder asks.
2. Summarize upcoming legal operations meetings and prep needs.
3. Detect recurring themes such as unclear routing, missing templates, repeated intake questions, billing issues, or reporting gaps.
4. Identify leadership-ready updates.
5. Draft recommended messages, status notes, or dashboard updates.

Output:
- Executive summary for the legal operations week
- Top operational blockers
- Stale intake or matter follow-ups
- Outside counsel or billing issues
- Reporting and dashboard needs
- Process improvement opportunities
- Draft Teams or Outlook updates where applicable

Guardrails:
- Do not send messages.
- Do not update systems of record without approval.
- Do not expose privileged matter details in broad summaries.
- Keep external-facing language neutral and factual.
```

## Scout automation JSON

```json
{
  "name": "Weekly legal operations command brief",
  "description": "Prepare a legal operations chief-of-staff brief for the week.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook and Teams activity from the prior week, upcoming legal operations meetings, legal intake queues, matter management systems, e-billing or outside counsel systems, SharePoint, OneNote, Power BI, tracker files, and unresolved stakeholder asks where available. Identify stale intake requests, open operational blockers, upcoming meeting prep needs, recurring themes, leadership-ready updates, reporting needs, outside counsel or billing issues, and process improvement opportunities. Draft recommended messages, status notes, or dashboard updates. Do not send messages or update systems of record without approval.",
  "steps": [
    {
      "label": "Weekly legal operations command brief",
      "prompt": "Review Outlook and Teams activity from the prior week, upcoming legal operations meetings, legal intake queues, matter management systems, e-billing or outside counsel systems, SharePoint, OneNote, Power BI, tracker files, and unresolved stakeholder asks where available. Identify stale intake requests, open operational blockers, upcoming meeting prep needs, recurring themes, leadership-ready updates, reporting needs, outside counsel or billing issues, and process improvement opportunities. Draft recommended messages, status notes, or dashboard updates. Do not send messages or update systems of record without approval."
    }
  ],
  "schedule": "every Monday at 7:30am"
}
```
