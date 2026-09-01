# Director of IT onboarding and offboarding readiness automation sample

Use this automation when Scout should watch for new-hire readiness, departing-user cleanup, and role-change access work.

```text
Name: Onboarding and offboarding readiness watch

Trigger type: Schedule

Schedule: Every weekday at 4:00 PM

Purpose:
Ensure upcoming employee starts, departures, and role changes have the right device, account, app, license, and access actions prepared.

Inputs:
- HR onboarding and offboarding messages
- Calendar start-date or departure-date events where available
- Outlook and Teams threads with hiring managers
- ITSM tickets where available
- Identity, device, SaaS, and license dashboards where available

Steps:
1. Identify starts, departures, and role changes in the next 7 days.
2. Check device, account, group, license, app access, and manager confirmation status.
3. Detect missing owner, missing approval, or timing risk.
4. Draft a readiness checklist or owner reminder.

Output:
- Employee transition affected
- Missing readiness item
- Risk to productivity or security
- Recommended next action
- Draft manager, HR, or IT owner message

Guardrails:
- Do not create accounts, remove access, change licenses, or update HR systems without approval.
- Protect employee privacy and sensitive HR context.
```

## Scout automation JSON

```json
{
  "name": "Onboarding and offboarding readiness watch",
  "description": "Check upcoming employee starts, departures, and role changes for device, account, app, license, and access readiness.",
  "triggerType": "schedule",
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 4pm",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review HR onboarding and offboarding messages, calendar start-date or departure-date events, Outlook and Teams threads with hiring managers, ITSM tickets, identity, device, SaaS, and license dashboards where available. Identify starts, departures, and role changes in the next 7 days. Check device, account, group, license, app access, and manager confirmation status. Detect missing owners, missing approvals, and timing risks. Draft a readiness checklist or owner reminder. Do not create accounts, remove access, change licenses, or update HR systems without approval.",
  "steps": [
    {
      "label": "Check onboarding and offboarding readiness",
      "prompt": "Review HR onboarding and offboarding messages, calendar start-date or departure-date events, Outlook and Teams threads with hiring managers, ITSM tickets, identity, device, SaaS, and license dashboards where available. Identify starts, departures, and role changes in the next 7 days. Check device, account, group, license, app access, and manager confirmation status. Detect missing owners, missing approvals, and timing risks. Draft a readiness checklist or owner reminder. Do not create accounts, remove access, change licenses, or update HR systems without approval."
    }
  ]
}
```
