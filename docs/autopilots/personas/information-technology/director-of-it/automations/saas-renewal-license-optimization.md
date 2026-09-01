# Director of IT SaaS renewal and license optimization automation sample

Use this automation when Scout should watch for SaaS renewals, vendor follow-up, unused licenses, and app consolidation opportunities.

```text
Name: SaaS renewal and license optimization watch

Trigger type: Schedule

Schedule: Every Tuesday at 8:00 AM

Purpose:
Help the Director of IT stay ahead of SaaS renewals, vendor decisions, unused licenses, and budget-impacting app choices.

Inputs:
- Vendor and procurement emails
- Finance and budget messages
- SaaS renewal trackers where available
- License usage reports where available
- App inventory, SSO, and endpoint software data where available
- Upcoming vendor or budget meetings

Steps:
1. Identify renewals, contract dates, vendor asks, and pricing deadlines in the next 30-60 days.
2. Detect unused licenses, duplicate applications, low adoption, or missing usage data.
3. Match each renewal to an owner, decision maker, and budget impact.
4. Draft a renewal brief or owner request.

Output:
- Renewal or SaaS item
- Usage or spend signal
- Missing decision, owner, or data
- Recommended next action
- Draft vendor-safe or internal stakeholder update

Guardrails:
- Do not contact vendors, change licenses, or update procurement systems without approval.
- Do not expose pricing, negotiation strategy, or contract terms broadly.
```

## Scout automation JSON

```json
{
  "name": "SaaS renewal and license optimization watch",
  "description": "Watch for SaaS renewals, vendor follow-up, unused licenses, duplicate applications, and app consolidation opportunities.",
  "triggerType": "schedule",
  "schedule": "every Tuesday at 8am",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review vendor and procurement emails, Finance and budget messages, SaaS renewal trackers, license usage reports, app inventory, SSO, endpoint software data, and upcoming vendor or budget meetings where available. Identify renewals, contract dates, vendor asks, pricing deadlines in the next 30 to 60 days, unused licenses, duplicate applications, low adoption, missing usage data, owners, decision makers, and budget impact. Draft a renewal brief or owner request. Do not contact vendors, change licenses, or update procurement systems without approval.",
  "steps": [
    {
      "label": "Review SaaS renewals and license optimization",
      "prompt": "Review vendor and procurement emails, Finance and budget messages, SaaS renewal trackers, license usage reports, app inventory, SSO, endpoint software data, and upcoming vendor or budget meetings where available. Identify renewals, contract dates, vendor asks, pricing deadlines in the next 30 to 60 days, unused licenses, duplicate applications, low adoption, missing usage data, owners, decision makers, and budget impact. Draft a renewal brief or owner request. Do not contact vendors, change licenses, or update procurement systems without approval."
    }
  ]
}
```
