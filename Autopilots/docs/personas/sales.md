# Sales team persona pack

This persona pack shows how Microsoft Scout can act as an always-on sales chief of staff. The goal is to make sales personas more productive by watching customer signals, Outlook, Teams, calendar, opportunity context, files, and unresolved commitments, then turning scattered work into prioritized, approval-ready follow-through.

---

## Value proposition

Sales teams lose time and momentum when customer asks, internal commitments, meeting prep, and deal signals are spread across Outlook, Teams, CRM, calendars, decks, notes, and account-team conversations. Scout helps by acting as a user-facing chief of staff that:

- surfaces the few accounts, deals, or customer moments that need attention now
- prepares users for upcoming customer and internal meetings
- tracks promised follow-ups and stale next steps
- drafts customer responses, seller updates, CRM notes, and meeting prep briefs
- spots technical blockers, stakeholder gaps, and forecast risk signals
- identifies opportunities for Power Platform, Copilot Studio, Dynamics 365, Cowork, or Scout where customer needs align
- keeps the human in control before anything is sent, created, uploaded, or updated

Scout is not a replacement for the seller, manager, or account executive. It is productivity support for staying prepared, responsive, and focused on the work that moves the number.

---

## Common sales systems and work surfaces

These samples are designed to fit sales teams that use tools such as:

- Communications: Outlook, Teams, calendar, meeting transcripts
- CRM and opportunity management: Dynamics 365 Sales, Salesforce, MSX, Dataverse
- Planning and notes: OneNote, Planner, Loop, SharePoint, OneDrive
- Sales and technical artifacts: PowerPoint decks, workshop agendas, architecture diagrams, demo plans, customer follow-up notes
- AI and business application motions: Power Platform, Copilot Studio, Dynamics 365, Cowork, Scout

The prompt should only use systems the user is authorized to access.

---

## Persona 1: Seller

**Job to be done:** Keep active opportunities moving by responding to customers, tracking commitments, and closing follow-through gaps.

**Scout value:** Scout watches recent customer activity, Outlook, Teams, meetings, tasks, and opportunity context for stalled threads, promised follow-ups, risk signals, and next-step gaps. It drafts concise customer responses, internal updates, and CRM activity notes for review.

| Sample | Link |
|---|---|
| Heartbeat | [Seller heartbeat visual](../visuals/seller-heartbeat.html) |
| Prompt | [Seller markdown prompt](../heartbeat-prompts/seller.md) |

---

## Persona 2: Sales Manager

**Job to be done:** Coach the team, protect forecast quality, and keep pipeline execution moving.

**Scout value:** Scout monitors team and deal signals for stalled opportunities, overdue follow-ups, coaching moments, escalation needs, and forecast risk. It prepares pipeline review notes, 1:1 talking points, and manager-ready updates.

| Sample | Link |
|---|---|
| Heartbeat | [Sales manager heartbeat visual](../visuals/sales-manager-heartbeat.html) |
| Prompt | [Sales manager markdown prompt](../heartbeat-prompts/sales-manager.md) |

---

## Persona 3: Account Executive

**Job to be done:** Own the customer relationship, maintain account momentum, and prevent stakeholder or deal follow-through from slipping.

**Scout value:** Scout keeps account and opportunity context current by watching meetings, Outlook, Teams, stakeholder changes, open opportunities, account plans, and prior commitments. It drafts customer follow-ups, internal alignment notes, meeting prep briefs, and CRM updates for approval.

| Sample | Link |
|---|---|
| Heartbeat | [Account executive heartbeat visual](../visuals/account-executive-heartbeat.html) |
| Prompt | [Account executive markdown prompt](../heartbeat-prompts/account-executive.md) |

## Recommended content layout

Use this folder structure for sales persona packs:

```text
docs/
  personas/
    sales.md
  heartbeat-prompts/
    seller.md
    sales-manager.md
    account-executive.md
```

Add `automation-samples/` entries later when a persona needs a bounded scheduled workflow, such as a weekly pipeline prep brief, a daily customer response queue, or a monthly account-plan refresh.
