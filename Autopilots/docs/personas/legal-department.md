# Legal department persona pack

This persona pack shows how Microsoft Scout can act as an always-on legal chief of staff. The goal is to make legal personas more productive by watching the communication layer, legal work systems, calendar, files, and unresolved commitments, then turning scattered work into prioritized, approval-ready follow-through.

---

## Value proposition

Legal teams spend significant time coordinating work rather than doing legal work. Requests arrive through Outlook, Teams, meetings, contract systems, matter systems, document repositories, and informal stakeholder channels. Scout helps by acting as a user-facing chief of staff that:

- watches for unanswered legal asks in Outlook and Teams
- prepares users for negotiation, review, and operations meetings
- tracks promised follow-ups and stale requests
- drafts stakeholder updates and Outlook responses
- recommends updates for systems of record
- identifies repeat work that should become a template, playbook, workflow, or automation
- keeps the human in control before anything is sent, approved, uploaded, or written

Scout is not a legal advice engine. It is productivity support for legal professionals who need help staying responsive, organized, and prepared.

---

## Common enterprise legal systems

These samples are designed to fit legal departments that use tools such as:

- CLM and contract systems: DocuSign CLM, Ironclad, Icertis, Sirion, Agiloft
- Document management: iManage, NetDocuments, SharePoint, OneDrive
- Matter and legal operations: ServiceNow Legal, Onit, SimpleLegal, TeamConnect
- E-billing and outside counsel: Brightflag, Legal Tracker, CounselLink
- Communications and work management: Outlook, Teams, OneNote, Planner, Power BI

The prompt should only use systems the user is authorized to access.

---

## Persona 1: Commercial Contracts Counsel

**Job to be done:** Keep contract negotiations, redlines, approvals, and stakeholder follow-ups moving.

**Scout value:** Scout watches Outlook, Teams, calendar, contract threads, document repositories, and legal systems for stalled contracts, unanswered stakeholder asks, upcoming negotiation calls, and recurring legal risk themes. It drafts concise updates and response language, while requiring counsel approval before anything is sent or recorded.

| Sample | Link |
|---|---|
| Heartbeat | [Commercial contracts counsel heartbeat visual](../visuals/legal-commercial-contracts-counsel-heartbeat.html) |
| Prompt | [Commercial contracts counsel markdown prompt](../heartbeat-prompts/legal-commercial-contracts-counsel.md) |
| Automation | [Daily contract risk and response queue](../automation-samples/legal-commercial-contracts-counsel.md) |

---

## Persona 2: Legal Operations Manager

**Job to be done:** Keep the legal department operating smoothly across intake, matter management, reporting, vendors, billing, and process improvements.

**Scout value:** Scout monitors operational signals across Outlook, Teams, intake queues, matter systems, e-billing tools, dashboards, files, and unresolved commitments. It highlights blockers, stale requests, unclear ownership, reporting needs, and repeat questions that should become a process improvement.

| Sample | Link |
|---|---|
| Heartbeat | [Legal operations manager heartbeat](../heartbeat-prompts/legal-operations-manager.md) |
| Automation | [Weekly legal operations command brief](../automation-samples/legal-operations-manager.md) |

---

## Recommended content layout

Use this folder structure for persona packs:

```text
docs/
  personas/
    legal-department.md
  heartbeat-prompts/
    legal-commercial-contracts-counsel.md
    legal-operations-manager.md
  automation-samples/
    legal-commercial-contracts-counsel.md
    legal-operations-manager.md
```

This keeps the narrative, heartbeat prompts, and automation samples easy to find and easy to reuse in enablement material.
