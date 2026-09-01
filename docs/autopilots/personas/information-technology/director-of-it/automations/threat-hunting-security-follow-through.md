# Director of IT threat hunting and security follow-through automation sample

Use this automation when Scout should watch for threat hunting, vulnerability, audit, and security follow-through items.

```text
Name: Threat hunting and security follow-through

Trigger type: Schedule

Schedule: Every weekday at 3:00 PM

Purpose:
Prepare a security follow-through nudge for threat hunting leads, vulnerability owners, audit evidence requests, and endpoint or identity risk items.

Inputs:
- Defender XDR, Sentinel, CrowdStrike, Wiz, or similar security findings where available
- Outlook and Teams security requests
- Audit evidence requests
- Endpoint compliance and vulnerability queues where available
- Security review meetings in the next 48 hours
- Prior unresolved security follow-ups

Steps:
1. Identify active threat hunting leads, unresolved findings, or audit asks.
2. Match each item to an owner, system, severity, and due date.
3. Detect missing evidence, stale remediation, or unclear next action.
4. Draft a concise security follow-through summary for the Director of IT.

Output:
- Top security follow-through items
- Owner and affected system
- Risk or audit impact
- Recommended next action
- Draft owner reminder or leadership-safe update

Guardrails:
- Do not change security policies, close findings, or update security tools without approval.
- Do not expose sensitive threat details in broad summaries.
- Keep leadership-facing language factual and appropriately scoped.
```

## Scout automation JSON

```json
{
  "name": "Threat hunting and security follow-through",
  "description": "Prepare a security follow-through nudge for threat hunting leads, vulnerabilities, audit evidence, and endpoint or identity risk items.",
  "triggerType": "schedule",
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 3pm",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Prepare a security follow-through nudge for the Director of IT. Review Defender XDR, Sentinel, CrowdStrike, Wiz, or similar security findings where available, Outlook and Teams security requests, audit evidence requests, endpoint compliance and vulnerability queues, security review meetings in the next 48 hours, and prior unresolved security follow-ups. Identify active threat hunting leads, unresolved findings, audit asks, owners, affected systems, severity, due dates, missing evidence, stale remediation, and unclear next actions. Draft an owner reminder or leadership-safe update. Do not change security tools or disclose sensitive threat details broadly.",
  "steps": [
    {
      "label": "Review threat hunting and security follow-through",
      "prompt": "Prepare a security follow-through nudge for the Director of IT. Review Defender XDR, Sentinel, CrowdStrike, Wiz, or similar security findings where available, Outlook and Teams security requests, audit evidence requests, endpoint compliance and vulnerability queues, security review meetings in the next 48 hours, and prior unresolved security follow-ups. Identify active threat hunting leads, unresolved findings, audit asks, owners, affected systems, severity, due dates, missing evidence, stale remediation, and unclear next actions. Draft an owner reminder or leadership-safe update. Do not change security tools or disclose sensitive threat details broadly."
    }
  ]
}
```
