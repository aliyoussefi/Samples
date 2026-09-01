# Director of IT endpoint compliance drift automation sample

Use this automation when Scout should watch for endpoint compliance, device health, and policy drift.

```text
Name: Endpoint compliance drift watch

Trigger type: Schedule

Schedule: Every weekday at 2:00 PM

Purpose:
Detect endpoint compliance and device health signals that may affect security posture or employee productivity.

Inputs:
- Intune compliance reports where available
- Defender for Endpoint device health signals where available
- Jamf, Kandji, or endpoint management data where available
- Outlook and Teams reports about device issues
- Prior unresolved endpoint remediation items

Steps:
1. Identify noncompliant devices, missing agents, outdated OS versions, failed policies, or repeated device issues.
2. Group findings by owner, user segment, device type, or policy.
3. Detect whether remediation ownership or user communication is missing.
4. Draft an endpoint remediation summary.

Output:
- Endpoint drift summary
- Affected device group or policy
- Security or productivity impact
- Recommended remediation owner
- Draft IT team update or user-safe message

Guardrails:
- Do not change device policies, quarantine devices, or modify endpoint settings without approval.
- Do not expose device or user details beyond the intended remediation audience.
```

## Scout automation JSON

```json
{
  "name": "Endpoint compliance drift watch",
  "description": "Watch for endpoint compliance drift, device health issues, missing agents, outdated OS versions, and failed policies.",
  "triggerType": "schedule",
  "schedule": "every Monday, Tuesday, Wednesday, Thursday and Friday at 2pm",
  "enabled": true,
  "teamsNotify": "always",
  "prompt": "Review Intune compliance reports, Defender for Endpoint device health signals, Jamf, Kandji, endpoint management data, Outlook and Teams device issue reports, and prior unresolved endpoint remediation items where available. Identify noncompliant devices, missing agents, outdated OS versions, failed policies, repeated device issues, affected groups, policy names, security or productivity impact, missing remediation owner, and user communication gaps. Draft an endpoint remediation summary. Do not change endpoint policies or device settings without approval.",
  "steps": [
    {
      "label": "Check endpoint compliance drift",
      "prompt": "Review Intune compliance reports, Defender for Endpoint device health signals, Jamf, Kandji, endpoint management data, Outlook and Teams device issue reports, and prior unresolved endpoint remediation items where available. Identify noncompliant devices, missing agents, outdated OS versions, failed policies, repeated device issues, affected groups, policy names, security or productivity impact, missing remediation owner, and user communication gaps. Draft an endpoint remediation summary. Do not change endpoint policies or device settings without approval."
    }
  ]
}
```
