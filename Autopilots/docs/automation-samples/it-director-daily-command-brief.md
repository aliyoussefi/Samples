# Director of IT daily command brief automation sample

Use this automation when Scout should prepare a daily chief-of-staff brief for a Director of IT at a software company.

```text
Name: Daily IT command brief

Schedule: Every weekday at 7:30 AM

Purpose:
Prepare a concise morning brief that helps the Director of IT see the IT issues, stakeholder asks, security items, access blockers, and meetings that need attention today.

Inputs:
- Outlook emails from the last 24 hours
- Teams chats and channel messages from IT, Security, Engineering, Product, HR, Finance, Legal, Sales, and Operations
- Calendar meetings for today and tomorrow
- Open tasks and unresolved heartbeat items
- IT service management tickets where available
- Endpoint, identity, SaaS, and security dashboards where available
- SharePoint, OneNote, Planner, and Power BI artifacts where available

Steps:
1. Identify urgent IT asks, escalations, incidents, and access blockers.
2. Group items by workstream such as support, endpoint, identity, SaaS, security, onboarding, vendor, or project.
3. Detect missing owners, missing due dates, aging items, and unclear next steps.
4. Review today and tomorrow's meetings for preparation gaps.
5. Rank the top items that need Director of IT attention today.
6. Draft concise updates, owner asks, or meeting prep notes where enough context exists.

Output:
- Top 5 IT items needing attention today
- Stakeholder or owner
- Why it matters
- Recommended next action
- Meeting prep needs
- Draft Outlook or Teams update where applicable
- Suggested ticket, OneNote, or tracker update where applicable

Estimated time saved:
30-45 minutes each morning by replacing manual inbox, Teams, calendar, ticket, and dashboard scanning with a prioritized action brief.

Guardrails:
- Do not send messages.
- Do not update tickets, systems, devices, users, groups, licenses, or policies without approval.
- Do not expose sensitive employee, security, vendor, or incident details in broad summaries.
- Keep executive-facing language concise, factual, and action-oriented.
```

## Scout automation JSON

```json
{
  "name": "Daily IT command brief",
  "description": "Prepare a concise morning brief for a Director of IT covering urgent asks, incidents, access blockers, endpoint issues, meetings, and stakeholder follow-through.",
  "triggerType": "schedule",
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 7:30am",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Prepare a concise morning IT command brief for the Director of IT. Review Outlook, Teams, calendar, open tasks, unresolved heartbeat items, ITSM tickets where available, endpoint, identity, SaaS, security dashboards, SharePoint, OneNote, Planner, and Power BI artifacts where available. Identify urgent IT asks, escalations, incidents, access blockers, today and tomorrow meeting prep gaps, missing owners, missing due dates, aging items, and unclear next steps. Output the top 5 IT items needing attention today, stakeholder or owner, why it matters, recommended next action, meeting prep needs, draft Outlook or Teams updates where applicable, and suggested ticket, OneNote, or tracker updates where applicable. Do not send messages or update systems without approval.",
  "steps": [
    {
      "label": "Build daily IT command brief",
      "prompt": "Prepare a concise morning IT command brief for the Director of IT. Review Outlook, Teams, calendar, open tasks, unresolved heartbeat items, ITSM tickets where available, endpoint, identity, SaaS, security dashboards, SharePoint, OneNote, Planner, and Power BI artifacts where available. Identify urgent IT asks, escalations, incidents, access blockers, today and tomorrow meeting prep gaps, missing owners, missing due dates, aging items, and unclear next steps. Output the top 5 IT items needing attention today, stakeholder or owner, why it matters, recommended next action, meeting prep needs, draft Outlook or Teams updates where applicable, and suggested ticket, OneNote, or tracker updates where applicable. Do not send messages or update systems without approval."
    }
  ]
}
```
