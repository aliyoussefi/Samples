# Director of IT identity and access blocker automation sample

Use this automation when Scout should watch for identity, access, onboarding, offboarding, and app-permission blockers.

```text
Name: Identity and access blocker watch

Trigger type: Condition

Condition:
Run when a message, ticket, or meeting note indicates a user cannot access an app, a privileged access request is waiting, or onboarding/offboarding access is incomplete.

Purpose:
Reduce productivity loss and security risk from unresolved access work.

Inputs:
- Outlook and Teams access requests
- ITSM access tickets where available
- Microsoft Entra ID, Okta, or identity dashboards where available
- HR onboarding/offboarding context where available
- App owner or SaaS admin messages

Steps:
1. Identify the user, app, access type, and business urgency.
2. Check whether manager, app owner, security, or HR approval is missing.
3. Detect whether the access request is stale or blocks an upcoming start date, meeting, or deliverable.
4. Draft an owner reminder or access-readiness checklist.

Output:
- User or group affected
- Access blocker summary
- Missing approval or owner
- Recommended next action
- Draft manager, app owner, or IT admin message

Guardrails:
- Do not grant, remove, or approve access.
- Do not change groups, roles, licenses, or privileged access settings without approval.
- Protect employee and security-sensitive context.
```

## Scout automation JSON

```json
{
  "name": "Identity and access blocker watch",
  "description": "Watch for access blockers, privileged access waits, onboarding access gaps, offboarding gaps, and app permission issues.",
  "triggerType": "condition",
  "condition": "A message, ticket, or meeting note indicates a user cannot access an app, a privileged access request is waiting, or onboarding/offboarding access is incomplete.",
  "conditionCheckInterval": 15,
  "enabled": true,
  "oneShot": true,
  "teamsNotify": "always",
  "prompt": "Review recent Outlook, Teams, ITSM, identity, HR onboarding/offboarding, and app owner context where available. Find identity, access, app permission, onboarding, offboarding, or privileged access blockers. Identify the user or group affected, app or access type, business urgency, missing manager, app owner, security, or HR approval, stale status, and productivity or security risk. Draft an owner reminder or access-readiness checklist. Do not grant, remove, or approve access without approval.",
  "steps": [
    {
      "label": "Check identity and access blockers",
      "prompt": "Review recent Outlook, Teams, ITSM, identity, HR onboarding/offboarding, and app owner context where available. Find identity, access, app permission, onboarding, offboarding, or privileged access blockers. Identify the user or group affected, app or access type, business urgency, missing manager, app owner, security, or HR approval, stale status, and productivity or security risk. Draft an owner reminder or access-readiness checklist. Do not grant, remove, or approve access without approval."
    }
  ]
}
```
