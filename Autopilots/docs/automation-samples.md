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

---

## Automation design rules

- **Use automation for recurring work.** Good examples are daily queues, weekly briefs, and recurring reporting packs.
- **Keep the scope bounded.** Define inputs, steps, output, and guardrails.
- **Do not make external changes by default.** Draft messages or updates, but require explicit approval before sending or writing.
- **Audit through source systems.** If the automation drafts emails, reviews documents, or suggests matter updates, the system of record remains Outlook, Teams, SharePoint, the CLM platform, the DMS, or the matter-management system.
- **Protect confidential legal context.** Do not expose privileged legal reasoning, fallback positions, or sensitive matter details in broad summaries.

