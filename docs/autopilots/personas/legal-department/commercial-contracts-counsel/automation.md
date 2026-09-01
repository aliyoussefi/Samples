# Commercial contracts counsel automation sample

Use this automation when Scout should prepare a daily contract risk and response queue for commercial contracts counsel.

```text
Name: Commercial contracts daily response queue

Schedule: Every weekday at 8:00 AM

Purpose:
Create a morning queue of contract matters that need counsel attention today.

Inputs:
- Outlook emails from the last 24 hours
- Teams chats and channel messages mentioning contract, MSA, SOW, DPA, NDA, redline, approval, signature, renewal, indemnity, liability, privacy, security, AI terms, or procurement
- Calendar meetings in the next 48 hours
- Open contract requests from CLM or matter tools where available
- Recent files in SharePoint, OneDrive, iManage, or NetDocuments where available

Steps:
1. Identify contract-related requests and follow-ups.
2. Group them by matter, customer, vendor, or business owner.
3. Detect urgency, blockers, missing inputs, and upcoming meetings.
4. Rank the top items that need legal response.
5. Draft stakeholder updates or Outlook responses where enough context exists.
6. Prepare a concise daily contract queue.

Output:
- Top 5 contract items needing attention
- Owner or stakeholder
- Current blocker
- Recommended next action
- Draft email or Teams response where applicable
- Suggested legal system note where applicable

Guardrails:
- Do not send messages.
- Do not approve clauses or accept redlines.
- Do not update CLM, DMS, matter, or e-billing systems without approval.
- Do not expose privileged or internal legal analysis in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Commercial contracts daily response queue",
  "description": "Create a morning queue of contract matters that need counsel attention today.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook emails from the last 24 hours, Teams chats and channel messages mentioning contract, MSA, SOW, DPA, NDA, redline, approval, signature, renewal, indemnity, liability, privacy, security, AI terms, or procurement, calendar meetings in the next 48 hours, open contract requests from CLM or matter tools where available, and recent files in SharePoint, OneDrive, iManage, or NetDocuments where available. Identify contract-related requests and follow-ups, group them by matter, customer, vendor, or business owner, detect urgency, blockers, missing inputs, and upcoming meetings, rank the top items that need legal response, and draft stakeholder updates or Outlook responses where enough context exists. Do not send messages, approve clauses, accept redlines, or update legal systems without approval.",
  "steps": [
    {
      "label": "Commercial contracts daily response queue",
      "prompt": "Review Outlook emails from the last 24 hours, Teams chats and channel messages mentioning contract, MSA, SOW, DPA, NDA, redline, approval, signature, renewal, indemnity, liability, privacy, security, AI terms, or procurement, calendar meetings in the next 48 hours, open contract requests from CLM or matter tools where available, and recent files in SharePoint, OneDrive, iManage, or NetDocuments where available. Identify contract-related requests and follow-ups, group them by matter, customer, vendor, or business owner, detect urgency, blockers, missing inputs, and upcoming meetings, rank the top items that need legal response, and draft stakeholder updates or Outlook responses where enough context exists. Do not send messages, approve clauses, accept redlines, or update legal systems without approval."
    }
  ],
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 8am"
}
```
