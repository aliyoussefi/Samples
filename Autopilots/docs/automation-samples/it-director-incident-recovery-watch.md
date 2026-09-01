# Director of IT incident recovery watch automation sample

Use this automation when Scout should watch for stale incidents, escalated support issues, and recovery follow-through.

```text
Name: Incident recovery watch

Trigger type: Condition

Condition:
Run when an incident, support escalation, service interruption, or repeated user report appears in Outlook, Teams, ITSM, or monitoring context and the recovery owner, status, or next update is unclear.

Purpose:
Keep incident recovery moving after detection, especially when communication and ownership are scattered.

Inputs:
- Outlook and Teams messages about incidents or outages
- ITSM incidents and escalations where available
- Monitoring or service health alerts where available
- Endpoint, identity, or SaaS admin dashboards where available
- Prior unresolved incident follow-ups

Steps:
1. Identify the incident, affected users or systems, and current severity.
2. Check for recovery owner, next update time, mitigation status, and customer or employee impact.
3. Detect stale updates, missing post-incident actions, or unclear recovery steps.
4. Draft an incident recovery summary and next-action checklist.

Output:
- Incident summary
- Current recovery status
- Missing owner, update, or mitigation
- Recommended next action
- Draft stakeholder update, IT bridge note, or post-incident follow-up

Guardrails:
- Do not send incident communications without approval.
- Do not change incident severity, close tickets, or update systems without approval.
- Keep sensitive security or customer-impact details limited to appropriate audiences.
```

