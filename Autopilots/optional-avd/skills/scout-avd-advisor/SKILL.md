---
name: scout-avd-advisor
description: |
  Plan, scope, cost, and troubleshoot a shared multi-user Microsoft Scout (Frontier)
  environment on Azure Virtual Desktop, and produce the documents a team needs to run
  it: decision briefs, readiness checklists, onboarding guides, and cost comparisons.
  Diagnoses reported symptoms such as "Sign in Failed" in the AVD web client,
  AADSTS50076, a session host that never joins the host pool, or users unable to
  install Node.js on a shared host. Use when the user asks to "plan a multi-user Scout
  environment", "AVD or Bastion for Scout", "what does a Scout AVD host cost", "write
  onboarding instructions for our Scout desktop", "why can't my users install npm
  packages", or "our AVD web client says Sign in Failed". Advisory only. It does not
  run commands. For an environment with a terminal and Azure CLI, use the
  frontier-scout-avd skill, which executes the deployment.
license: MIT
metadata:
  author: Ali Youssefi
  version: "1.0"
---

# Scout on AVD, planning and troubleshooting advisor

Produce decisions, documents, and diagnoses for a shared multi-user Microsoft Scout (Frontier) environment on Azure Virtual Desktop.

**This skill does not deploy anything.** It has no terminal and assumes none. It turns a requirement into a plan someone else executes, and turns a reported symptom into a specific cause. When the user needs the deployment actually run, tell them the executable kit lives at `Autopilots/optional-avd/` in `github.com/aliyoussefi/Samples`, and that the `frontier-scout-avd` skill drives it in a tool that has a shell.

Write any document you produce to the user's OneDrive or SharePoint. Never reference local disk paths.

## 1. Decide: AVD or Bastion

Ask how many people, and whether the environment is throwaway or recurring. Then:

| Answer | Recommend |
|---|---|
| One person, throwaway | Single VM behind Azure Bastion |
| Two or more people sharing | **AVD** |
| Recurring demo, idle much of the time | **AVD** |
| Users on corp networks blocking RDP 3389 | Either. Both tunnel over 443. |

The deciding factor for anything long-lived is cost shape, not features:

- **Bastion Standard bills hourly and cannot be paused.** Only deleting it stops the meter. It is the largest recurring line item in the single-VM design.
- **AVD's gateway and control plane are free.** With nightly auto-shutdown plus start-on-connect, an idle environment costs little more than its OS disk.

State this explicitly in any recommendation. It is usually the point that decides it.

## 2. Cost model

Build estimates from these components. Always separate running cost from idle cost, because idle is where the two designs diverge.

| Component | Bills when |
|---|---|
| Session host compute | Only while running. Auto-shutdown plus start-on-connect makes this near zero when idle. |
| OS disk | Always. Size it for several users' `node_modules`; 256 GB is a sensible default. |
| NAT Gateway and its public IP | Always. Required for outbound. |
| AVD gateway and control plane | Never. Free. |
| Azure Bastion Standard | Always, if present. Cannot be paused. |

Ask the region and VM size rather than guessing rates, and label any figure you cannot verify as an estimate.

## 3. Readiness checklist

Produce this before anyone touches Azure. Each item blocks the deployment.

**Identity and licensing**
- [ ] Copilot Frontier enabled for the org, and the attestation submitted. **Manual, not automatable, propagates up to ~3 hours.**
- [ ] Every intended user has a **GitHub Copilot license**
- [ ] Every intended user has **MFA registered**
- [ ] An Entra **security group** exists to control access

**Azure permissions**
- [ ] **Owner** on the target subscription
- [ ] **Application Administrator** or **Global Administrator** in the tenant, required for the SSO step and often the real scheduling constraint

**Network**
- [ ] A subnet with **outbound internet**, normally a NAT Gateway. AVD is inbound only and never provides outbound. Without it Scout fails in ways that look like sign-in problems.

**Decisions to confirm**
- [ ] Concurrent user ceiling, which sets the session limit and host count
- [ ] Whether profiles must roam across hosts. If yes, FSLogix is required and is extra scope.
- [ ] Nightly shutdown time and time zone

## 4. Onboarding document

When asked for user-facing instructions, produce something a non-technical colleague can follow:

1. Go to `https://client.wvd.microsoft.com/arm/webclient/`
2. Sign in **and complete the MFA prompt.** Explain that a cached sign-in without a real MFA prompt will fail at the desktop with an unhelpful error.
3. Open the workspace and launch the desktop
4. Start Microsoft Scout and sign in as yourself, Microsoft 365 plus GitHub
5. On first sign-in, run **Set up my dev environment** from the Start Menu

Include the no-admin explanation, because it is the most common user question:

> You are a standard user on a shared machine, which is deliberate. You can still install what you need. `npm install -g` and `npx` install into your own profile and need no administrator rights, so Scout can run MCP servers normally. Use `fnm` if you need a different Node version from someone else on the host. If something insists on administrator rights, ask an admin to add it to the shared baseline rather than requesting admin for yourself.

## 5. Diagnose a reported symptom

Match what the user describes. Most of these are misdiagnosed in predictable ways, so lead with the cause.

| Reported symptom | Most likely cause | What to tell them |
|---|---|---|
| Web client shows a credential box, "Sign in Failed" | Entra SSO not configured for the host | Requires four steps by someone with directory rights: create the Windows Cloud Login service principal if absent, enable RDP on it, register the host's device group as trusted, and set the host pool SSO property. |
| **AADSTS50076** at the desktop, but the workspace listed fine | Conditional Access requires MFA, and the token lacks an MFA claim because the browser session was cached | Sign out and sign in again, completing a real MFA prompt. **Not** a host misconfiguration. Tell them explicitly not to redeploy. |
| Desktop missing from the feed, or appears then refuses | Only one of the two required roles assigned | Both `Desktop Virtualization User` on the app group **and** `Virtual Machine User Login` on the host are required |
| Session host never appears in the pool | Agent registration failed, commonly from malformed installer arguments | Have them check the registration state on the host. **Ask how long ago** first: registration is asynchronous and a check seconds after install reports empty on a host that is fine. |
| A tool is installed according to the package manager, but users cannot run it | It installed as an **MSIX** package, which registers **per user**. Installed as SYSTEM it exists only for SYSTEM. | Reinstall forcing the MSI variant. This is silent and easy to miss because the package manager still reports success. |
| Users cannot install software | Working as designed. They are standard users. | Route to the per-user path: `npm -g`, `npx`, `fnm`, `uv`, and user-scope package installs. Only genuinely machine-scope installers need an admin, and those belong in the shared baseline. Do not recommend granting admin on a shared host. |
| Scout says "isn't available for your organization" | Gate 1 org entitlement missing or still propagating | Verify the org setting and attestation, then wait up to ~3 hours. Not a VM problem. |
| Scout stuck at a waitlist screen | Gate 2 device policy missing on the host | The device policy needs setting, or re-setting after a reimage |
| Scout runs but has no internet | Subnet has no NAT gateway | AVD is inbound only. Outbound must be provided separately. |

## 6. Rules

- **Never invent Azure rates, resource IDs, or tenant identifiers.** Ask, or label clearly as an estimate.
- **Never tell someone to grant administrator rights on a shared host** to solve an install problem. Route to the per-user path or the shared baseline.
- Separate what is automatable from what is not. Gate 1 and the attestation are manual and are the most common cause of a slipped date, so surface them first.
- When a symptom is a Conditional Access or entitlement issue rather than an infrastructure issue, say so plainly. Sending someone to redeploy infrastructure over an MFA claim wastes a day.
- Save deliverables to OneDrive or SharePoint and tell the user where they are.
