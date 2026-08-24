# HR Business Partner automation sample

Use this automation when Scout should prepare a weekly manager and employee follow-through brief.

```text
Name: Weekly HRBP follow-through brief

Schedule: Every Monday at 7:30 AM

Purpose:
Prepare a weekly HR chief-of-staff brief for manager and employee follow-through.

Inputs:
- Outlook and Teams activity from the prior week
- Upcoming HRBP, manager, and employee meetings
- HR case queues where available
- OneNote, SharePoint, Planner, and Power BI where available
- Prior unresolved heartbeat items

Steps:
1. Identify unresolved manager and employee asks.
2. Summarize upcoming sensitive meetings and prep needs.
3. Detect stale cases, missing inputs, and repeated policy questions.
4. Identify coaching or enablement opportunities.
5. Draft recommended manager updates, case notes, or prep briefs.

Output:
- Top HR follow-through items for the week
- Upcoming meeting prep needs
- Stale cases or missing inputs
- Manager coaching or enablement opportunities
- Draft manager or employee-safe messages where applicable

Guardrails:
- Do not send messages.
- Do not update HR systems without approval.
- Do not expose sensitive employee details in broad summaries.
- Keep language neutral, factual, and privacy-safe.
```
