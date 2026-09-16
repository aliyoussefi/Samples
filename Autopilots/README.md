# Autopilots

Enablement kits for **agentic desktop assistants** ("autopilots") that run on Microsoft 365 — starting with **Microsoft Scout (Frontier)**.

This category is **documentation-first**. The goal is to help admins and Solution Engineers **enable and troubleshoot** these tools in a real tenant, not to stand up lab infrastructure. Everything here is drawn from public Microsoft Learn documentation and public Microsoft GitHub repos.

---

## What's here

### Microsoft Scout (Frontier) enablement

Microsoft Scout Frontier is gated behind a **two-gate access model**. Installing the app always succeeds — **sign-in** is where access is enforced. If either gate is incomplete, sign-in is silently blocked with *"Microsoft Scout isn't available for your organization."* These docs walk each gate end to end.

| Doc | What it covers |
|---|---|
| [`docs/enable-frontier.md`](docs/enable-frontier.md) | **Gate 1** — organization access: Frontier program enrollment, turning on Copilot Frontier in the M365 admin center, attestation/opt-in, and GitHub Copilot licensing. |
| [`docs/intune-setup.md`](docs/intune-setup.md) | **Gate 2** — device policy: importing the Scout ADMX into Intune and enabling `AllowScoutFrontierAccess` on managed Windows (and macOS) devices. |
| [`docs/troubleshooting.md`](docs/troubleshooting.md) | Failure signatures and fixes — "not available for your organization", waitlist/blocked sign-in, policy not landing, ADMX import errors, missing Copilot. |
| [`docs/cost-management.md`](docs/cost-management.md) | Track Scout usage/cost — where to see **GitHub Copilot premium-request** consumption, direct links, budgets and alerts. |
| [`docs/personas.md`](docs/personas.md) | Persona sample library — value propositions plus links to role-specific heartbeat and automation samples. |
| [`docs/heartbeat-prompts.md`](docs/heartbeat-prompts.md) | Role-based heartbeat prompt samples for always-on Scout chief-of-staff scenarios. |
| [`docs/automation-samples.md`](docs/automation-samples.md) | Role-based automation samples for scheduled and recurring Scout work. |
| [`docs/personas/legal-department.md`](docs/personas/legal-department.md) | Legal department persona pack with value prop, heartbeat samples, and automation samples. |
| [`Frontier-Scout-Intune-Preflight-Checklist.md`](Frontier-Scout-Intune-Preflight-Checklist.md) | One-page, customer-shareable readiness checklist for an **Intune-managed** rollout, ordered by propagation lead time. |

---

## The two-gate model at a glance

```
                      Microsoft Scout (Frontier) sign-in
                                    │
        ┌───────────────────────────┴───────────────────────────┐
        ▼                                                         ▼
  GATE 1 — Organization access                        GATE 2 — Device policy
  (tenant admin, server-side)                         (Intune / managed device)
  • Frontier program enrollment                       • Import Scout ADMX
  • Copilot Frontier = On (M365 admin center)         • Allow Microsoft Scout
  • Attestation / opt-in form                           Frontier access = Enabled
  • GitHub Copilot license per user                   • Assign + sync to devices
        │                                                         │
        └───────────────────────────┬───────────────────────────┘
                                     ▼
                     Both complete → sign-in succeeds
              Either missing → "not available for your organization"
                              or a waitlist / blocked screen
```

> **Rule of thumb:** if sign-in is blocked, verify the **admin gates first** (Frontier on + propagated, attestation submitted, policy Enabled + assigned + synced, Copilot license present) before touching the client. The root cause is almost always a gate, not the device.

---

## Quick start

1. **Read** [`docs/enable-frontier.md`](docs/enable-frontier.md) and complete Gate 1. Start early — the Copilot Frontier setting can take **up to ~3 hours** to propagate, and GitHub Copilot licensing is often the long pole.
2. **Configure** Gate 2 for your managed fleet using [`docs/intune-setup.md`](docs/intune-setup.md).
3. **Validate** on a managed test device, then use [`docs/troubleshooting.md`](docs/troubleshooting.md) if sign-in is blocked.
4. Running a rollout for a team? Hand out [`Frontier-Scout-Intune-Preflight-Checklist.md`](Frontier-Scout-Intune-Preflight-Checklist.md) to line up the (often different) admins in advance.

---

## Optional: throwaway test environments

You do **not** need a VM or any Azure infrastructure to enable Scout Frontier — the docs above are all you need for a real tenant. Two optional kits exist as a convenience for demoing or testing Frontier without an Intune-managed endpoint. Both are entirely optional and neither is part of the supported enablement path.

| Kit | Use it for | Access |
|---|---|---|
| [`optional-test-vm/`](optional-test-vm/) | **One person.** Isolated Windows 11 sandbox: Azure Bastion + NAT Gateway + Entra login + local device policy. | Azure Bastion |
| [`optional-avd/`](optional-avd/) | **Two or more people** sharing one environment, or a recurring demo that should cost near nothing when idle. Windows 11 multi-session on Azure Virtual Desktop, with a developer baseline so users can install Node.js toolchains and npm packages without admin rights. | AVD web client |

Azure Bastion Standard bills hourly and cannot be paused, so for anything long-lived the AVD kit is materially cheaper. See [`optional-test-vm/README.md`](optional-test-vm/README.md) and [`optional-avd/README.md`](optional-avd/README.md).

---

## Portable Scout agent team

The [Alfred, Dawn and Dusk kit](tools/agent-team/SETUP.txt) packages six self-contained skills and six disabled automation definitions for a user's own Windows or AVD profile:

- **Alfred:** review internal direct Teams messages, track explicit sender opt-in and prepare replies for owner approval.
- **Dawn:** morning preparation, hourly meeting intelligence and an optional read-only demo readiness check.
- **Dusk:** daily work/artifact summaries and a confirm-first weekly filing proposal.

The installer does not copy credentials, overwrite differing skills, register schedules or enable outgoing messages. Configure the owner and artifact root locally, then register and review the disabled definitions in Scout. These are portable community workflow samples, not independently hosted agents. Scout must be running; its schedules do not start the AVD.

---

## Reference documentation

- [Microsoft Scout — Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview)
- [Microsoft Scout — Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)
- [Microsoft Scout policy templates (ADMX/ADML/mobileconfig)](https://github.com/microsoft/scout-resources/tree/main/admins)
- [Copilot Frontier program](https://adoption.microsoft.com/en-us/copilot/frontier-program/)
- [Download Microsoft Scout](https://aka.ms/scout)
