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

