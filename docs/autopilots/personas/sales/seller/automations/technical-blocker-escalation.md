# Seller technical blocker escalation automation sample

Use this automation when Scout should help a seller act on this signal: Watch for quota, POC, demo, architecture, integration, security, or deployment blockers that could stall a deal.

```text
Name: Technical blocker escalation

Trigger type: Condition

Condition: A customer, seller, specialist, or technical stakeholder mentions a blocker such as quota, POC, demo, architecture, integration, security, access, or deployment.

Purpose:
Watch for quota, POC, demo, architecture, integration, security, or deployment blockers that could stall a deal.

Why it matters:
Technical blockers often hide across customer and internal threads. Scout brings owner and next action into focus.

Estimated time saved:
15-25 min saved per blocker

Guardrails:
- Do not send messages.
- Do not update CRM, tasks, files, or other systems without approval.
- Keep customer-facing language professional, concise, and safe.
- Do not expose internal-only details in external drafts.
```

## Scout automation JSON

```json
{
  "name": "Technical blocker escalation",
  "description": "Watch for quota, POC, demo, architecture, integration, security, or deployment blockers that could stall a deal.",
  "triggerType": "condition",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review recent Outlook, Teams, meeting, task, opportunity, and technical workstream context. Identify technical blockers that could stall a deal, including quota, POC, demo, architecture, integration, security, access, and deployment issues. Determine affected account, opportunity, owner, urgency, and missing next step. Draft an escalation summary, owner ask, or customer-safe response for review. Do not send messages or update systems without approval.",
  "steps": [
    {
      "label": "Technical blocker escalation",
      "prompt": "Review recent Outlook, Teams, meeting, task, opportunity, and technical workstream context. Identify technical blockers that could stall a deal, including quota, POC, demo, architecture, integration, security, access, and deployment issues. Determine affected account, opportunity, owner, urgency, and missing next step. Draft an escalation summary, owner ask, or customer-safe response for review. Do not send messages or update systems without approval."
    }
  ],
  "condition": "A customer, seller, specialist, or technical stakeholder mentions a blocker such as quota, POC, demo, architecture, integration, security, access, or deployment.",
  "conditionCheckInterval": 15,
  "oneShot": true
}
```
