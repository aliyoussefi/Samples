# Director of IT repeat issue automation candidate sample

Use this automation when Scout should identify recurring IT requests that should become templates, self-service guidance, or automation.

```text
Name: Repeat issue automation candidate finder

Trigger type: Schedule

Schedule: Every Friday at 3:30 PM

Purpose:
Find repeat IT issues that are consuming team capacity and recommend where automation, self-service guidance, templates, or policy changes could reduce future work.

Inputs:
- Outlook and Teams activity from the prior week
- ITSM ticket categories where available
- Knowledge-base searches or support articles where available
- Endpoint, identity, SaaS, and app admin signals where available
- Prior weekly command briefs

Steps:
1. Cluster repeated requests, questions, incidents, and access patterns.
2. Identify repeat causes such as missing documentation, unclear process, policy drift, app confusion, or manual approval steps.
3. Estimate impact by frequency, affected users, and IT effort.
4. Recommend the best improvement type.

Output:
- Top repeat issue candidates
- Estimated frequency and impact
- Root cause hypothesis
- Recommended template, knowledge article, automation, or process change
- Draft improvement backlog item

Guardrails:
- Do not create knowledge articles, automations, or backlog items without approval.
- Avoid naming individual users unless needed for follow-up.
```

## Scout automation JSON

```json
{
  "name": "Repeat issue automation candidate finder",
  "description": "Identify recurring IT requests or support patterns that should become templates, knowledge articles, self-service guidance, or automation.",
  "triggerType": "schedule",
  "schedule": "every Friday at 3:30pm",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Outlook and Teams activity from the prior week, ITSM ticket categories, knowledge-base searches or support articles, endpoint, identity, SaaS, app admin signals, and prior weekly command briefs where available. Cluster repeated requests, questions, incidents, and access patterns. Identify repeat causes such as missing documentation, unclear process, policy drift, app confusion, or manual approval steps. Estimate impact by frequency, affected users, and IT effort. Recommend a template, knowledge article, automation, process change, or backlog item. Do not create knowledge articles, automations, or backlog items without approval.",
  "steps": [
    {
      "label": "Find repeat IT automation candidates",
      "prompt": "Review Outlook and Teams activity from the prior week, ITSM ticket categories, knowledge-base searches or support articles, endpoint, identity, SaaS, app admin signals, and prior weekly command briefs where available. Cluster repeated requests, questions, incidents, and access patterns. Identify repeat causes such as missing documentation, unclear process, policy drift, app confusion, or manual approval steps. Estimate impact by frequency, affected users, and IT effort. Recommend a template, knowledge article, automation, process change, or backlog item. Do not create knowledge articles, automations, or backlog items without approval."
    }
  ]
}
```
