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

