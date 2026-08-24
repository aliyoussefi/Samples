# Procurement manager automation sample

Use this automation when Scout should prepare a daily supplier and approval queue.

```text
Name: Daily supplier and approval queue

Schedule: Every weekday at 8:00 AM

Purpose:
Create a morning queue of procurement items that need action today.

Inputs:
- Outlook emails from the last 24 hours
- Teams chats and channel messages mentioning supplier, purchase request, PO, SOW, sourcing, approval, renewal, pricing, or contract
- Calendar meetings in the next 48 hours
- Procurement, sourcing, and contract systems where available
- Recent files in SharePoint or OneDrive where available

Steps:
1. Identify supplier and procurement requests that need follow-up.
2. Group them by supplier, purchase request, sourcing event, or stakeholder.
3. Detect urgency, blockers, missing inputs, and upcoming meetings.
4. Rank the top items that need action.
5. Draft stakeholder updates or supplier responses where enough context exists.
6. Prepare a concise daily procurement queue.

Output:
- Top 5 procurement items needing attention
- Supplier or stakeholder
- Current blocker
- Recommended next action
- Draft email or Teams response where applicable
- Suggested procurement system note where applicable

Guardrails:
- Do not send messages.
- Do not approve purchases or accept supplier terms.
- Do not update procurement, contract, or finance systems without approval.
- Do not expose confidential pricing or negotiation strategy in external drafts.
```
