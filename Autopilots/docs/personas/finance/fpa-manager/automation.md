# FP&A manager automation sample

Use this automation when Scout should prepare a weekly forecast and variance prep brief.

```text
Name: Weekly forecast and variance prep brief

Schedule: Every Monday at 7:30 AM

Purpose:
Prepare a finance chief-of-staff brief for the week.

Inputs:
- Outlook and Teams activity from the prior week
- Upcoming forecast, budget, and leadership meetings
- Power BI reports, Excel workbooks, and planning files where available
- Open tasks and unresolved finance asks
- Prior heartbeat unresolved items

Steps:
1. Identify open finance questions, missing inputs, and stale approvals.
2. Summarize upcoming forecast and budget meetings.
3. Detect variance themes that need explanation.
4. Identify leadership-ready updates and blockers.
5. Draft recommended messages, status notes, or dashboard updates.

Output:
- Executive summary for the finance week
- Top forecast and budget risks
- Missing inputs by owner
- Variance explanations needing review
- Reporting and dashboard update recommendations
- Draft Teams or Outlook updates where applicable

Guardrails:
- Do not send messages.
- Do not update finance systems or files without approval.
- Do not expose confidential financial data in broad summaries.
- Keep external-facing language neutral and factual.
```

## Scout automation JSON

```json
{
  "name": "Weekly forecast and variance prep brief",
  "description": "Prepare a finance chief-of-staff brief for the week.",
  "triggerType": "schedule",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook and Teams activity from the prior week, upcoming forecast, budget, and leadership meetings, Power BI reports, Excel workbooks, planning files, open tasks, unresolved finance asks, and prior heartbeat unresolved items where available. Identify open finance questions, missing inputs, stale approvals, upcoming forecast and budget meetings, variance themes that need explanation, leadership-ready updates, and blockers. Draft recommended messages, status notes, or dashboard updates. Do not send messages or update finance systems or files without approval.",
  "steps": [
    {
      "label": "Weekly forecast and variance prep brief",
      "prompt": "Review Outlook and Teams activity from the prior week, upcoming forecast, budget, and leadership meetings, Power BI reports, Excel workbooks, planning files, open tasks, unresolved finance asks, and prior heartbeat unresolved items where available. Identify open finance questions, missing inputs, stale approvals, upcoming forecast and budget meetings, variance themes that need explanation, leadership-ready updates, and blockers. Draft recommended messages, status notes, or dashboard updates. Do not send messages or update finance systems or files without approval."
    }
  ],
  "schedule": "every Monday at 7:30am"
}
```
