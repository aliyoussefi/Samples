# Director of IT executive ask triage automation sample

Use this automation when Scout should watch for executive or cross-functional IT asks that need ownership.

```text
Name: Executive IT ask triage

Trigger type: Condition

Condition:
Run when a new Outlook or Teams message from an executive, department leader, or cross-functional stakeholder appears to request IT action and lacks a clear owner, due date, or response.

Purpose:
Prevent executive or cross-functional IT asks from getting buried in Outlook and Teams.

Inputs:
- Outlook emails from executives and department leaders
- Teams chats and channel messages from Engineering, Security, Product, HR, Finance, Legal, Sales, and Operations
- Calendar context for related meetings
- Open tasks and unresolved heartbeat items

Steps:
1. Identify the ask, stakeholder, urgency, and business impact.
2. Determine whether the ask needs IT, Security, Finance, Legal, HR, Engineering, or an app owner.
3. Check whether an owner, due date, or next step is already visible.
4. Draft a concise owner assignment or status response.

Output:
- Stakeholder and request summary
- Business impact
- Missing owner or missing next step
- Recommended owner or workstream
- Draft Outlook or Teams response for review

Guardrails:
- Do not send messages.
- Do not assign work in systems of record without approval.
- Do not expose sensitive executive or business context in broad summaries.
```

