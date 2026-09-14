---
name: frontier-scout-avd
description: |
  Deploy Microsoft Scout (Frontier) on Azure Virtual Desktop as a shared multi-user
  environment instead of a single-user VM behind Azure Bastion. Covers host pool,
  workspace, app group, session host, RDAgent registration, Entra SSO for the web
  client, group-based access, a no-admin developer toolchain, and cost control.
  Use when the user asks to "deploy Scout on AVD", "set up a multi-user Scout demo",
  "share a Scout environment with my team", "run Scout without Bastion", "build an
  AVD session host for Frontier", or "let users install Node.js on the shared host".
  Requires a shell with Azure CLI. For an environment with no terminal, such as
  Copilot Cowork, use the scout-avd-advisor skill instead.
license: MIT
metadata:
  author: Ali Youssefi
  version: "1.1"
---

# Microsoft Scout (Frontier) on Azure Virtual Desktop

Stand up a **shared, multi-user** Scout Frontier environment on AVD. Users connect through the AVD web client over 443, so there is no Bastion, no public IP on the host, and no RDP port exposure.

> **This skill executes infrastructure changes.** It needs a shell with Azure CLI signed in, plus Owner on the subscription and Application Administrator in the tenant. If you have no terminal, use `scout-avd-advisor`, which produces the same plan as guidance without running anything.

Every environment-specific value is a `<PLACEHOLDER>`. This skill contains no tenant IDs, object IDs, or credentials.

## Use the ready-made kit first

A validated kit already exists at **`Autopilots/optional-avd/`** in `github.com/aliyoussefi/Samples`:

| File | Purpose |
|---|---|
| `deploy.ps1` | Control plane, session host, agent registration, RBAC, baseline. Idempotent, supports `-WhatIf` |
| `scripts/Enable-EntraSso.ps1` | Entra SSO for the web client |
| `scripts/Install-Baseline.ps1` | Machine-wide tools, Gate 2 policy, self-heal task |
| `scripts/Setup-MyDevEnv.ps1` | Per-user, no-admin toolchain |

Prefer running that kit over hand-issuing commands. Always run `-WhatIf` first. Only fall back to the manual sequence below if the kit is unavailable.

## Choose AVD or Bastion first

| Need | Use |
|---|---|
| One person, throwaway sandbox | The `frontier-scout-vm` skill, or `Autopilots/optional-test-vm`. Simpler. |
| Two or more people sharing one environment | **This skill** |
| Recurring demo that must be cheap when idle | **This skill.** Auto-shutdown plus start-on-connect drops compute to near zero. AVD's gateway is free; Bastion Standard bills hourly and cannot be paused. |

## Prerequisites

- Azure CLI, plus `az extension add -n desktopvirtualization` and `az provider register -n Microsoft.DesktopVirtualization --wait`
- **Owner** on the subscription, and **Application Administrator** or **Global Admin** in the tenant for the SSO step
- A subnet with **outbound internet**, normally a NAT Gateway. AVD is inbound only and never provides outbound. Scout will not work without it.
- Per user: a **GitHub Copilot license**, **MFA registered**, and org-level Frontier access

> **Gate 1 is not automatable.** Enabling Copilot Frontier for the org and submitting the attestation is manual and propagates for up to ~3 hours. If Scout says "isn't available for your organization", that is Gate 1, not a config error.

## Architecture

```
AVD web client (443)
   -> Workspace -> App group (Desktop) -> Host pool (Pooled, BreadthFirst, max N)
                                             -> Session host (Entra-joined, no public IP)
                                                   -> NAT Gateway -> internet
```

Access is one Entra group holding **both** required roles. Adding a colleague is then one command.

## Sequence

1. **Control plane.** Host pool with `--start-vm-on-connect true`, a Desktop app group bound to it, and a workspace referencing the app group.
2. **RBAC.** Assign the access group **both** `Desktop Virtualization User` on the app group **and** `Virtual Machine User Login` on the resource group. One without the other produces a confusing half-failure.
3. **Session host.** Image must be `MicrosoftWindowsDesktop:windows-11:win11-24h2-avd:latest`. Trusted Launch, no public IP, no NSG, system-assigned identity. Confirm with `EditionID = ServerRdsh`.
4. **Entra join.** Install `AADLoginForWindows` **plain**, with no `mdmId`.
5. **Agent.** Rotate the registration token, install RDAgent then BootLoader, then poll for registration.
6. **Baseline.** Machine-wide tools plus the Gate 2 device policy.
7. **SSO.** See below. Not optional.
8. **Auto-shutdown.** Pairs with start-on-connect.

## Entra SSO, the hard part

Without this the web client fails with a credential box and "Sign in Failed". Requires directory rights. This is **not** the OAuth admin-consent flow that tenants often block, so it usually succeeds where the Bastion Entra button does not.

1. Ensure the **Windows Cloud Login** service principal exists. App ID `270efc09-cd0d-444b-a71f-39af4910ec45`, identical in every tenant. It is frequently absent in dev tenants and must be created.
2. PATCH `remoteDesktopSecurityConfiguration` with `isRemoteDesktopProtocolEnabled: true`.
3. Register an Entra group containing the host's **device object** as a trusted `targetDeviceGroups` entry. This suppresses the consent prompt standard users cannot approve. Use the device object ID, not the VM resource ID.
4. Set the host pool custom RDP property `enablerdsaadauth:i:1;targetisaadjoined:i:1;...`

## Developer dependencies without admin rights

AVD users hold `Virtual Machine User Login`, which makes them **standard users**. Machine-scope installers fail for them. Do **not** grant `Virtual Machine Administrator Login` to work around this. On a shared host, one user's install affects everyone.

Split the toolchain:

| Scope | Tools | Why |
|---|---|---|
| Machine-wide, as SYSTEM | Node.js LTS, Git, PowerShell 7, VS Code | MSI, wix, and inno installers cannot go per-user |
| Per-user, no admin | `fnm`, `uv`, `%APPDATA%\npm` on PATH | Portable installers |

The payoff, verified on a real non-admin account: `npm install -g` writes to `%APPDATA%\npm` and `npx` caches to `%LOCALAPPDATA%\npm-cache`. Both are per-user and need no admin, so **every user can install and run MCP servers under their own profile**, which is what Scout needs. `fnm` then lets two users run different Node versions on the same host at once.

Check installer type before adding any package:

```
winget show --id <Package.Id> --exact | Select-String 'Installer Type:'
```

Portable and zip always support `--scope user`. Inno and burn usually do. **MSI and wix do not**, so those belong in the machine baseline.

## Gotchas

These cost real debugging time. The first three were found by an actual end-to-end deploy, not by reading docs.

| Symptom | Cause | Fix |
|---|---|---|
| Tool reports MISSING but `winget list` says installed | Package installed as **MSIX**, which registers **per user**. Installed as SYSTEM it exists for SYSTEM only. `Microsoft.PowerShell` defaults to an msixbundle. | Force the MSI: `InstallerType='wix'` plus `Force=$true`. Force is required because once an MSIX is in winget's tracking catalog it skips the MSI with "No available upgrade found", even after the MSIX is uninstalled. |
| `IsRegistered` empty right after agent install | Registration is **asynchronous** | Poll for up to 5 minutes. An empty read after 10 seconds is normal and looks exactly like the msiexec failure below. Do not start debugging a working host. |
| Baseline verification prints nothing, log ends early | The process inherited PATH **before** the installers ran, so bare `node` or `git` did not resolve and the assignments never happened | Rebuild PATH from the registry before verifying, then report per tool |
| Host never joins the pool, `IsRegistered` still empty after minutes | msiexec args passed as one string | Pass them as a PowerShell **array** |
| `AADLoginForWindows` fails, "no MDM URLs", rolls back | Extension asked to Entra-join **and** Intune-enroll, but MDM auto-enrollment scope is unset | Install plain, no `mdmId`. Delete and re-add if it stuck. |
| Desktop in the feed but connection refused, or missing entirely | Only one of the two roles assigned | Both roles are required |
| Web client shows a credential box | SSO not configured | Do the SSO steps above |
| **AADSTS50076** at the host, though the feed loaded | Conditional Access requires MFA. With SSO the feed token passes to the host and carries an MFA claim only if MFA actually happened in that browser session. A cached sign-in fails. | Sign in again and complete a real MFA prompt. **Not** a host misconfiguration, so do not redeploy. |
| Scout has no internet | Subnet has no NAT and `defaultOutboundAccess=false` | Attach a NAT Gateway |
| Scout installer is about 138 KB | `aka.ms/scout` is an HTML landing page | Resolve the real `download.microsoft.com` URL |
| winget floods the log with thousands of lines | `--disable-interactivity` does not suppress the progress bar | Filter spinner frames, box-drawing glyphs, and byte counters. Glyphs get transcoded to `?` by some codepages, so match the size counter unanchored. |

## Operating principles

- Re-assert `az account set` between steps. The CLI context can silently revert to a corp default.
- Always `-WhatIf` before a real run, and confirm **every** write is gated. Registration-token rotation is easy to leave ungated and will mutate a live host pool during a dry run.
- Verify each stage before the next: session host `Available`, then SSO, then Scout. Debugging a Scout sign-in when the real problem is agent registration wastes hours.
- When sending scripts to `az vm run-command`, write to a temp `.ps1` and pass `@file` so local PowerShell does not interpolate `$` variables first.
- Never commit tenant IDs, device object IDs, or host passwords. Keep those in a local internal runbook.
- Always offer teardown. Deleting the resource group is the only true $0.
