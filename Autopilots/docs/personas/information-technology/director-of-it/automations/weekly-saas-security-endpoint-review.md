# Director of IT weekly SaaS, security, and endpoint review automation sample

Use this automation when Scout should prepare a weekly operating review for a Director of IT at a software company.

```text
Name: Weekly SaaS, security, and endpoint review

Schedule: Every Monday at 7:00 AM

Purpose:
Prepare a leadership-ready weekly brief covering SaaS renewals, license usage, endpoint compliance, security follow-through, vendor actions, and IT project blockers.

Inputs:
- Outlook and Teams activity from the prior week
- Upcoming vendor, security, budget, and IT roadmap meetings
- SaaS renewal trackers and procurement files where available
- License usage, spend, and application inventory data where available
- Endpoint compliance and device health dashboards where available
- Security findings, vulnerability queues, and audit evidence requests where available
- IT project trackers, OneNote notes, Planner plans, and Power BI reports where available
- Prior unresolved heartbeat and automation items

Steps:
1. Identify renewals, vendor asks, and budget items due in the next 30-60 days.
2. Detect license waste, unused apps, duplicate tools, or app consolidation opportunities.
3. Summarize endpoint compliance, device health, agent coverage, and policy drift signals.
4. Review security follow-through, audit requests, vulnerability ownership, and evidence gaps.
5. Identify IT project blockers, missing owners, and delayed decisions.
6. Draft a weekly leadership brief with recommended decisions and follow-ups.

Output:
- Executive summary for the IT operating week
- SaaS renewal and vendor actions
- License optimization opportunities
- Endpoint compliance and device health signals
- Security and audit follow-through items
- IT project blockers and decisions needed
- Draft leadership update, Teams message, or owner checklist where applicable

Estimated time saved:
1-2 hours each week by consolidating vendor, SaaS, endpoint, security, and project review prep into a single brief.

Guardrails:
- Do not send messages.
- Do not change licenses, vendor records, endpoint policies, security settings, or project trackers without approval.
- Do not expose sensitive security findings, employee details, vendor pricing, or non-public business context in broad summaries.
- Keep leadership-facing language concise, factual, and decision-oriented.
```

## Scout automation JSON

```json
{
  "name": "Weekly SaaS, security, and endpoint review",
  "description": "Prepare a weekly Director of IT operating review covering SaaS renewals, license usage, endpoint compliance, security follow-through, vendor actions, and IT project blockers.",
  "triggerType": "schedule",
  "schedule": "every Monday at 7am",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Prepare a leadership-ready weekly IT operating brief for the Director of IT. Review Outlook and Teams activity from the prior week, upcoming vendor, security, budget, and IT roadmap meetings, SaaS renewal trackers, license usage, endpoint compliance, device health dashboards, security findings, vulnerability queues, audit evidence requests, IT project trackers, OneNote notes, Planner plans, Power BI reports, and prior unresolved heartbeat and automation items where available. Identify renewals and vendor asks due in the next 30 to 60 days, license waste, duplicate tools, endpoint compliance issues, security follow-through gaps, audit evidence gaps, project blockers, missing owners, and decisions needed. Do not send messages or update systems without approval.",
  "steps": [
    {
      "label": "Build weekly IT operating review",
      "prompt": "Prepare a leadership-ready weekly IT operating brief for the Director of IT. Review Outlook and Teams activity from the prior week, upcoming vendor, security, budget, and IT roadmap meetings, SaaS renewal trackers, license usage, endpoint compliance, device health dashboards, security findings, vulnerability queues, audit evidence requests, IT project trackers, OneNote notes, Planner plans, Power BI reports, and prior unresolved heartbeat and automation items where available. Identify renewals and vendor asks due in the next 30 to 60 days, license waste, duplicate tools, endpoint compliance issues, security follow-through gaps, audit evidence gaps, project blockers, missing owners, and decisions needed. Do not send messages or update systems without approval."
    }
  ]
}
```
