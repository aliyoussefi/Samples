# Director of IT project risk watch automation sample

Use this automation when Scout should watch for IT project delivery risks and blocked commitments.

```text
Name: IT project risk watch

Trigger type: Condition

Condition:
Run when a project thread, meeting note, task, or tracker indicates a delayed milestone, missing owner, blocked dependency, scope change, or unclear decision.

Purpose:
Surface project risk before it becomes an executive escalation.

Inputs:
- Outlook and Teams project threads
- Planner, Jira, Azure DevOps, or project trackers where available
- Calendar meetings and transcripts where available
- OneNote, SharePoint, and status documents where available
- Prior unresolved project risks

Steps:
1. Identify project, milestone, blocker, and owner.
2. Determine whether the risk affects timeline, budget, scope, security, employee productivity, or executive commitment.
3. Check whether a next action, owner, and due date are visible.
4. Draft a project risk summary and owner checklist.

Output:
- Project and milestone affected
- Risk detected
- Business impact
- Missing owner or next step
- Draft Teams update, project note, or escalation summary

Guardrails:
- Do not update project trackers, change dates, or assign tasks without approval.
- Keep risk language factual and non-alarmist.
```

## Scout automation JSON

```json
{
  "name": "IT project risk watch",
  "description": "Watch for delayed milestones, missing owners, blocked dependencies, scope changes, and unclear IT project decisions.",
  "triggerType": "condition",
  "condition": "A project thread, meeting note, task, or tracker indicates a delayed milestone, missing owner, blocked dependency, scope change, or unclear decision.",
  "conditionCheckInterval": 15,
  "enabled": true,
  "oneShot": true,
  "teamsNotify": "always",
  "prompt": "Review recent Outlook, Teams, Planner, Jira, Azure DevOps, project tracker, calendar, meeting transcript, OneNote, SharePoint, and status document context where available. Find IT project risks such as delayed milestones, missing owners, blocked dependencies, scope changes, unclear decisions, and unresolved prior risks. Identify project, milestone, blocker, owner, impact to timeline, budget, scope, security, employee productivity, or executive commitment. Draft a project risk summary and owner checklist. Do not update trackers or assign tasks without approval.",
  "steps": [
    {
      "label": "Check IT project risk",
      "prompt": "Review recent Outlook, Teams, Planner, Jira, Azure DevOps, project tracker, calendar, meeting transcript, OneNote, SharePoint, and status document context where available. Find IT project risks such as delayed milestones, missing owners, blocked dependencies, scope changes, unclear decisions, and unresolved prior risks. Identify project, milestone, blocker, owner, impact to timeline, budget, scope, security, employee productivity, or executive commitment. Draft a project risk summary and owner checklist. Do not update trackers or assign tasks without approval."
    }
  ]
}
```
