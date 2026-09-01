# Scout automation samples for role-based enablement

Scout automations are scheduled or condition-triggered tasks that run with a defined purpose. Use them when the work is recurring, bounded, and predictable. Use heartbeat when the assistant should continuously reason over changing context and decide whether to interrupt the user.

---

## Recommended layout

Use this structure for role-based enablement content:

| Folder | Purpose |
|---|---|
| `docs/personas/` | Persona narratives, value propositions, and links to prompt assets |
| `docs/heartbeat-prompts/` | Always-on heartbeat prompts by persona |
| `docs/automation-samples/` | Scheduled or condition-triggered automation prompts by persona |

This keeps the persona story separate from the executable prompt samples, while making it easy to reuse a heartbeat or automation in multiple enablement decks.

---

## Available samples

| Role | Sample automation |
|---|---|
| Legal - Commercial Contracts Counsel | [Daily contract risk and response queue](automation-samples/legal-commercial-contracts-counsel.md) |
| Legal - Legal Operations Manager | [Weekly legal operations command brief](automation-samples/legal-operations-manager.md) |
| Human Resources - Talent Acquisition Lead | [Talent Acquisition Lead automation sample](automation-samples/hr-talent-acquisition-lead.md) |
| Human Resources - HR Business Partner | [HR Business Partner automation sample](automation-samples/hr-hr-business-partner.md) |
| Finance - Procurement Manager | [Procurement Manager automation sample](automation-samples/finance-procurement-manager.md) |
| Finance - FP&A Manager | [FP&A Manager automation sample](automation-samples/finance-fpa-manager.md) |
| Information Technology - Director of IT | [Daily IT command brief](automation-samples/it-director-daily-command-brief.md) |
| Information Technology - Director of IT | [Weekly SaaS, security, and endpoint review](automation-samples/it-director-weekly-saas-security-endpoint-review.md) |
| Information Technology - Director of IT | [Executive IT ask triage](automation-samples/it-director-executive-ask-triage.md) |
| Information Technology - Director of IT | [Incident recovery watch](automation-samples/it-director-incident-recovery-watch.md) |
| Information Technology - Director of IT | [Identity and access blocker watch](automation-samples/it-director-identity-access-blocker-watch.md) |
| Information Technology - Director of IT | [Threat hunting and security follow-through](automation-samples/it-director-threat-hunting-security-follow-through.md) |
| Information Technology - Director of IT | [SaaS renewal and license optimization watch](automation-samples/it-director-saas-renewal-license-optimization.md) |
| Information Technology - Director of IT | [IT project risk watch](automation-samples/it-director-project-risk-watch.md) |
| Information Technology - Director of IT | [Endpoint compliance drift watch](automation-samples/it-director-endpoint-compliance-drift.md) |
| Information Technology - Director of IT | [Onboarding and offboarding readiness watch](automation-samples/it-director-onboarding-offboarding-readiness.md) |
| Information Technology - Director of IT | [IT leadership meeting prep](automation-samples/it-director-leadership-meeting-prep.md) |
| Information Technology - Director of IT | [Repeat issue automation candidate finder](automation-samples/it-director-repeat-issue-automation-candidate.md) |

---

## Automation design rules

- **Use automation for recurring work.** Good examples are daily queues, weekly briefs, and recurring reporting packs.
- **Keep the scope bounded.** Define inputs, steps, output, and guardrails.
- **Do not make external changes by default.** Draft messages or updates, but require explicit approval before sending or writing.
- **Audit through source systems.** If the automation drafts emails, reviews documents, or suggests system updates, the system of record remains Outlook, Teams, SharePoint, CRM, HR, finance, legal, or line-of-business systems.
- **Protect confidential business context.** Do not expose privileged legal reasoning, financial data, employee information, candidate details, or sensitive deal context in broad summaries.
