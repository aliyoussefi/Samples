# Scout automation samples for role-based enablement

Scout automations are scheduled or condition-triggered tasks that run with a defined purpose. Use them when the work is recurring, bounded, and predictable. Use heartbeat when the assistant should continuously reason over changing context and decide whether to interrupt the user.

---

## Persona-centered layout

Automation markdown and JSON files now live inside each persona folder:

```text
docs/
  personas/
    <division>/
      README.md
      <persona>/
        heartbeat.md
        heartbeat.html
        automation.md
        automation.json
```

Director of IT has multiple automation samples:

```text
docs/personas/information-technology/director-of-it/
  automations.html
  automations/
    <automation>.md
    json/
      <automation>.json
```

---

## Available automation samples

| Persona | Automation |
|---|---|
| Commercial Contracts Counsel | [Daily contract risk and response queue](personas/legal-department/commercial-contracts-counsel/automation.md) · [JSON](personas/legal-department/commercial-contracts-counsel/automation.json) |
| Legal Operations Manager | [Weekly legal operations command brief](personas/legal-department/legal-operations-manager/automation.md) · [JSON](personas/legal-department/legal-operations-manager/automation.json) |
| Seller | [Seller automation visual](personas/sales/seller/automations.html) · [Automation folder](personas/sales/seller/automations/) · [JSON folder](personas/sales/seller/automations/json/) |
| FP&A Manager | [Weekly forecast and variance prep brief](personas/finance/fpa-manager/automation.md) · [JSON](personas/finance/fpa-manager/automation.json) |
| Procurement Manager | [Daily supplier and approval queue](personas/finance/procurement-manager/automation.md) · [JSON](personas/finance/procurement-manager/automation.json) |
| HR Business Partner | [Weekly HRBP follow-through brief](personas/human-resources/hr-business-partner/automation.md) · [JSON](personas/human-resources/hr-business-partner/automation.json) |
| Talent Acquisition Lead | [Daily hiring pipeline and interview coordination queue](personas/human-resources/talent-acquisition-lead/automation.md) · [JSON](personas/human-resources/talent-acquisition-lead/automation.json) |
| Director of IT | [Automation visual](personas/information-technology/director-of-it/automations.html) · [Automation folder](personas/information-technology/director-of-it/automations/) · [JSON folder](personas/information-technology/director-of-it/automations/json/) |

---

## Automation design rules

- **Use automation for recurring work.** Good examples are daily queues, weekly briefs, and recurring reporting packs.
- **Keep the scope bounded.** Define inputs, steps, output, and guardrails.
- **Provide JSON.** Each automation should include a copyable Scout automation JSON definition.
- **Do not make external changes by default.** Draft messages or updates, but require explicit approval before sending or writing.
- **Audit through source systems.** If the automation drafts emails, reviews documents, or suggests system updates, the system of record remains Outlook, Teams, SharePoint, CRM, HR, finance, legal, or line-of-business systems.
- **Protect confidential business context.** Do not expose privileged legal reasoning, financial data, employee information, candidate details, or sensitive deal context in broad summaries.
