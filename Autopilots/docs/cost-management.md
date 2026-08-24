# Cost management — tracking Microsoft Scout (Frontier) usage

Microsoft Scout bills model/token usage against the **GitHub identity** each user signs into it with — Scout uses your **GitHub Copilot** entitlement for inference. So "Scout cost/credit consumption" is really your **GitHub Copilot premium-request usage**. This guide shows where to see it and how to keep it under control.

> Two identities, two bills: the **Microsoft 365** sign-in governs Scout Frontier *access* (Gate 1) and has no per-token cost; the **GitHub** sign-in carries the **Copilot license and token consumption**. Cost management happens on the **GitHub** side.

---

## Where to see consumption

Sign in with the **same GitHub account you use inside Scout** — usage is tied to that identity, so each user checks their own page.

| What | Direct link |
|---|---|
| **Billing & licensing overview** (Metered usage → click **Copilot** to filter) | https://github.com/settings/billing |
| **Usage page** (newer view) | https://github.com/settings/billing/usage |
| **Premium request analytics** (detailed: filter, Group by, Timeframe, export) | Left sidebar → **Premium request analytics** from https://github.com/settings/billing |
| **Your Copilot plan & features** | https://github.com/settings/copilot |

**Steps for the detailed view:**
1. Open **https://github.com/settings/billing**.
2. In the sidebar, click **Premium request analytics**.
3. Use **Filter**, **Group by**, and **Timeframe** to shape the chart/table.
4. Use the chart **⋯ (options)** menu to download/export the data.

You can also view usage live inside an IDE (VS Code, Visual Studio → *Copilot Consumptions*, JetBrains, Eclipse), but the billing page above is the authoritative record.

---

## If Copilot is provided by an organization or enterprise

With a **Copilot Business/Enterprise** license, personal billing may be hidden (the org pays), and an admin views usage at the org/enterprise level:

- Organization: `https://github.com/organizations/<ORG>/settings/billing`
- Enterprise: `https://github.com/enterprises/<ENTERPRISE>/settings/billing`

Replace `<ORG>` / `<ENTERPRISE>` with your slug.

---

## Keeping cost under control

- **Premium request counters reset on the 1st of each month at 00:00 UTC.** Plan/allowance windows are monthly.
- **Set a budget with alerts.** Configure a spending budget so you're notified at **75%, 90%, and 100%** of the limit, and to cap overages. See [Setting up budgets to control spending on metered products](https://docs.github.com/en/billing/how-tos/set-up-budgets).
- **Choose the right model for the task.** Heavier models draw more premium requests; match the model to the job. See [AI model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison).
- **Download usage reports** for chargeback/tracking. See [Viewing your usage of metered products and licenses](https://docs.github.com/en/billing/how-tos/products/view-productlicense-use#downloading-usage-reports).

---

## Quick reference

| Question | Answer |
|---|---|
| Where does Scout usage get billed? | Your **GitHub Copilot** account (premium requests), not Microsoft 365 |
| Which identity's usage am I seeing? | The **GitHub account signed into Scout** |
| Fastest link to my numbers | https://github.com/settings/billing → **Premium request analytics** |
| When does the counter reset? | 1st of each month, **00:00 UTC** |
| How do I avoid surprises? | Set a **budget** with 75/90/100% alerts |

---

## Reference documentation

- [Monitor premium requests](https://docs.github.com/en/copilot/reference/copilot-billing/request-based-billing-legacy/monitor-premium-requests)
- [Set up budgets to control spending](https://docs.github.com/en/billing/how-tos/set-up-budgets)
- [View usage of metered products and licenses](https://docs.github.com/en/billing/how-tos/products/view-productlicense-use)
- [AI model comparison](https://docs.github.com/en/copilot/reference/ai-models/model-comparison)
