# Optional — Multi-user Microsoft Scout (Frontier) on Azure Virtual Desktop

> **You do not need this to enable Scout Frontier.** For a real tenant, follow the documentation-first path in the parent folder: [`../docs/enable-frontier.md`](../docs/enable-frontier.md) (Gate 1) and [`../docs/intune-setup.md`](../docs/intune-setup.md) (Gate 2).

This kit deploys a **shared, multi-user** Windows 11 multi-session host on **Azure Virtual Desktop** so a small team can use Microsoft Scout (Frontier) from a browser. Users connect through the AVD web client over 443. There is **no Bastion, no public IP on the host, and no exposed RDP port**.

Every user gets a real development environment. They can install Node.js toolchains, npm packages, Python, and VS Code extensions **without being a local administrator**. See [Developer dependencies](#developer-dependencies).

## Which kit do I want?

| Your situation | Use |
|---|---|
| One person, throwaway sandbox | [`../optional-test-vm`](../optional-test-vm) — single VM behind Azure Bastion |
| Two or more people sharing one environment | **This kit** |
| Recurring demo that should cost near nothing when idle | **This kit** |

The cost difference is the deciding factor for anything long-lived. Azure Bastion Standard bills hourly, cannot be paused, and only deleting it stops the meter. AVD's gateway and control plane are free, so with auto-shutdown plus start-on-connect an idle environment costs little more than its OS disk.

## Validation status

The deploy path has been run end to end against a real subscription, verified on the host, then torn down.

| Component | Status |
|---|---|
| `deploy.ps1` control plane, session host, agent registration, RBAC | **Verified.** Session host reached `Available` |
| `Install-Baseline.ps1` | **Verified.** `node`, `npm`, `git`, `pwsh`, `code` all resolve |
| Per-user, no-admin toolchain | **Verified with a real standard user** |
| `-WhatIf` dry run | **Verified.** Every write is gated, including registration-token rotation |
| Idempotency | **Verified.** Re-running detects existing resources and skips them |
| `Enable-EntraSso.ps1` | **Not verified.** Runbook-derived. Confirming it needs an interactive browser sign-in as a licensed user |

The no-admin claim was proven rather than assumed. A local account in `Users` only, not an administrator:

```
whoami        : <host>\<testuser>
isAdmin       : False
npm prefix    : C:\Users\<testuser>\AppData\Roaming\npm
npm i -g exit : 0
installed at  : left-pad
npx run       : (executed)
```

## Contents

| File | Purpose |
|---|---|
| `deploy.ps1` | End-to-end deploy: control plane, session host, agent registration, RBAC, baseline tools |
| `scripts/Enable-EntraSso.ps1` | Entra SSO for the web client. Needs directory rights, so it is a separate run |
| `scripts/Install-Baseline.ps1` | Machine-wide developer baseline, runs once as SYSTEM |
| `scripts/Setup-MyDevEnv.ps1` | Per-user, no-admin toolchain setup that each user runs at first sign-in |
| `skills/` | Importable AI agent skills for Microsoft Scout and Copilot Cowork. See [`skills/README.md`](skills/README.md) |

## How it maps to the two gates

| Gate | On this host |
|---|---|
| **Gate 1 — org access** | **Still manual.** Turn on Copilot Frontier, submit the attestation, confirm GitHub Copilot licensing. See [`../docs/enable-frontier.md`](../docs/enable-frontier.md). Propagation takes up to ~3 hours. |
| **Gate 2 — device policy** | Set **locally** by `Install-Baseline.ps1` (`AllowScoutFrontierAccess=1` in `HKLM\SOFTWARE\Policies\Scout`, plus a startup task that re-asserts it). This is the unmanaged-device stand-in. It does **not** bypass Gate 1. |

## Architecture

```
       AVD web client (HTTPS 443)
                 |
            Workspace
                 |
        App group (Desktop)
                 |
   Host pool (Pooled, BreadthFirst, max N sessions)
                 |
   Session host  (Win 11 multi-session, Entra-joined, no public IP)
                 |
          NAT Gateway  ->  internet
```

Access is a single Entra group holding both required roles. Onboarding a colleague is then one command.

## Prerequisites

- **Azure CLI**, plus the AVD extension and provider:
  ```powershell
  az extension add -n desktopvirtualization
  az provider register -n Microsoft.DesktopVirtualization --wait
  ```
- **Owner** on the subscription.
- **Application Administrator** or **Global Administrator** in the tenant, for the SSO step only.
- A VNet with a subnet that has **outbound internet**, normally through a **NAT Gateway**. Scout will not work without outbound access.
- An Entra **security group** for access, and per user: a **GitHub Copilot license** and **MFA registered**.

> **Outbound is not optional and AVD does not provide it.** The AVD gateway handles inbound session traffic only. A subnet with `defaultOutboundAccess=false` and no NAT leaves the host with no internet, and Scout fails in ways that look like sign-in problems.

## Deploy

```powershell
cd optional-avd
.\deploy.ps1 -SubscriptionId "<your-sub-guid>" `
             -ResourceGroup  "rg-avd-scout" `
             -Location       "eastus" `
             -SubnetId       "/subscriptions/.../subnets/default" `
             -AccessGroupId  "<entra-group-object-id>" `
             -AdminPassword  (Read-Host -AsSecureString "Local admin password")
```

The script creates the host pool, application group, and workspace, assigns both roles to your access group, creates the session host, registers it with the pool, installs the developer baseline, and prints what to do next.

It is **idempotent**. Re-running skips anything that already exists. Use `-WhatIf` for a dry run first: every write is gated, so a dry run makes no changes at all, including no registration-token rotation.

```powershell
.\deploy.ps1 -WhatIf -SubscriptionId ... # prints the plan, changes nothing
```

Then run the SSO step, which needs directory rights:

```powershell
.\scripts\Enable-EntraSso.ps1 -ResourceGroup "rg-avd-scout" `
                              -HostPoolName  "hp-scout-avd" `
                              -SessionHost   "avdscout01"
```

> **`SkuNotAvailable`?** The size has no capacity in that region for your subscription. Re-run with a different `-VmSize`. Eight-vCPU v5 families are frequently constrained. `Standard_DC8s_v3` is a reliable fallback.

## Connect

1. Go to **<https://client.wvd.microsoft.com/arm/webclient/>**
2. Sign in **and complete the MFA prompt**. See the MFA note in [Troubleshooting](#troubleshooting).
3. Open the workspace and launch **SessionDesktop**
4. Start **Microsoft Scout** and sign in as yourself: Microsoft 365 plus GitHub

## Developer dependencies

Users signed in through AVD hold **Virtual Machine User Login**, which makes them **standard users**, not local administrators. That is deliberate. On a shared host, one user installing machine-wide software affects everyone.

So the kit splits the toolchain in two.

### Installed machine-wide, once, by `Install-Baseline.ps1`

Shared by all users, installed as SYSTEM at deploy time:

| Tool | Why it must be machine-wide |
|---|---|
| **Node.js LTS** | The official installer is an MSI and cannot install per-user |
| **Git** | The installer is per-machine only |
| **PowerShell 7** | Installed as MSI. See the MSIX warning below |
| **VS Code (System setup)** | One shared copy instead of one per user profile |
| **App Installer / winget** | Required for per-user installs later |

> ### ⚠️ MSIX packages do not work machine-wide
>
> This is the single biggest trap when adding a package to the baseline, and it fails **silently**.
>
> **MSIX packages are registered per user.** Installing one as SYSTEM registers it for the SYSTEM account only, so no real user on the host ever gets the command. `winget list` still reports the package as installed, which is what makes it so easy to miss.
>
> `Microsoft.PowerShell` is a live example. Its default winget installer is now an `msixbundle`:
>
> ```
> winget list                    ->  Microsoft.PowerShell 7.6.6.0   (claims installed)
> C:\Program Files\PowerShell    ->  does not exist
> C:\Program Files\WindowsApps\Microsoft.PowerShell_.../pwsh.exe   (SYSTEM only)
> ```
>
> The fix is to force the MSI with an `InstallerType` override in the `$Packages` table:
>
> ```powershell
> @{ Id = 'Microsoft.PowerShell'; InstallerType = 'wix'; Force = $true }
> ```
>
> `Force` is also required. Once an MSIX build is known to winget's tracking catalog, it skips the MSI with *"No available upgrade found"* **even after the MSIX is uninstalled**.
>
> When adding any package, check its installer type first and prefer `wix`, `msi`, `inno`, or `burn` over `msix`:
>
> ```powershell
> winget show --id <Package.Id> --exact | Select-String 'Installer Type:'
> ```
>
> `Install-Baseline.ps1` verifies every tool after install and reports `OK` or `MISSING` per tool, so a package that lands the wrong way is visible in the log rather than discovered weeks later by a user.

### Available to every user with no admin rights

Once Node is on the machine, the per-user story works out of the box, because npm's Windows defaults are already per-user:

| What | Location | Admin needed |
|---|---|---|
| `npm install -g <pkg>` | `%APPDATA%\npm` | **No** |
| `npx <pkg>` cache | `%LOCALAPPDATA%\npm-cache` | **No** |
| VS Code extensions | `%USERPROFILE%\.vscode\extensions` | **No** |
| `pip install --user` | `%APPDATA%\Python` | **No** |

This matters for Scout specifically: **MCP servers launched through `npx` need no administrator rights**. A user can add an MCP server to their own Scout configuration and it will install and run under their profile.

For anything else, users run the helper once at first sign-in:

```powershell
powershell -ExecutionPolicy Bypass -File C:\ProgramData\ScoutAVD\Setup-MyDevEnv.ps1
```

`Install-Baseline.ps1` puts a **Set up my dev environment** shortcut in the all-users Start Menu pointing at it, so nobody needs to remember the path.

It installs, entirely inside the user's profile:

| Tool | winget ID | Installer type | Purpose |
|---|---|---|---|
| **fnm** | `Schniz.fnm` | portable zip | Install and switch Node versions per user |
| **uv** | `astral-sh.uv` | portable zip | Python versions and virtualenvs per user |

and then configures `%APPDATA%\npm` on the user's `PATH`, which needs no admin because user PATH is user-writable.

Anything else installable without admin follows the same pattern:

```powershell
winget install --id <Package.Id> --scope user --accept-package-agreements --accept-source-agreements
```

> **Not every package supports `--scope user`.** Portable and zip installers always do. Inno and burn installers often do. **MSI and wix packages generally do not**, which is exactly why Node.js itself is in the machine-wide baseline. If winget reports *"No applicable installer found"*, that package needs an administrator and belongs in `Install-Baseline.ps1` instead.

### A different Node version per user

```powershell
fnm install 22
fnm use 22
fnm default 22
node -v
```

`fnm` keeps each version under `%LOCALAPPDATA%\fnm`, so two users on the same host can run different Node versions at the same time without conflict.

### Profile persistence

By default this kit uses **local profiles**, which is fine for a single host used by a stable group. Understand the consequences:

- Per-user installs live on the **host's OS disk**. Several users with large `node_modules` trees add up, so size the OS disk accordingly. The default here is 256 GB.
- Profiles do **not** roam. Add a second session host and a user landing on it starts empty.
- A **reimage** destroys all per-user state.

If you add hosts, or need profiles to survive a reimage, add **FSLogix** with an Azure Files share. That is out of scope here and is the documented next step once you outgrow one host.

## Adding users

```powershell
az ad group member add --group "<access-group>" --member-id <user-object-id>
```

Each user also needs a **GitHub Copilot license**, **MFA registered**, and org-level Frontier access from Gate 1.

Concurrency is set by `--max-session-limit`, default 5. For more, add session hosts to the same pool.

## Cost

While running, this bills for **VM compute**, the **OS disk**, and the **NAT Gateway** and its public IP. The **AVD control plane and gateway are free**.

`deploy.ps1` sets auto-shutdown and the host pool uses **start-VM-on-connect**, so the host powers down nightly and wakes on the next connection. Idle cost is the OS disk plus NAT.

```powershell
az vm deallocate -g <rg> -n <host>     # stop compute now, keep state
az group delete  -n <rg>               # true $0
```

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `SkuNotAvailable` | Regional capacity limit for that size | Try another `-VmSize` or region. Enumerate with `az vm list-skus`. |
| `AADLoginForWindows` fails with "no MDM URLs" and rolls back | Extension asked to Entra-join **and** Intune-enroll, but MDM auto-enrollment scope is unset | Install it plain, with no `mdmId`. Delete and re-add if it stuck. |
| Host never appears in the pool, `IsRegistered` empty | msiexec arguments passed as a single string | Pass them as a PowerShell **array**. `deploy.ps1` already does. **Check the time first:** registration is asynchronous and takes a minute or two. `deploy.ps1` polls for 5 minutes. An empty value read seconds after install is normal and not a failure. |
| A tool reports `MISSING` in the baseline log, but `winget list` says it is installed | The package installed as **MSIX**, which registers per user, so SYSTEM has it and nobody else does | Force the MSI with `InstallerType = 'wix'` and `Force = $true`. See the MSIX warning in [Developer dependencies](#developer-dependencies). |
| Web client shows a credential box and "Sign in Failed" | Entra SSO not configured | Run `scripts/Enable-EntraSso.ps1` |
| **AADSTS50076** at host sign-in, although the feed loaded | A Conditional Access policy requires MFA. With SSO the feed token is passed to the host and carries an MFA claim only if MFA actually happened in that session. A cached browser session fails. | Sign in again and complete a real MFA prompt. This is not a host misconfiguration, so do not redeploy. |
| Desktop appears in the feed but the connection is refused | Only one of the two roles was assigned | Both **Desktop Virtualization User** on the app group and **Virtual Machine User Login** on the host are required |
| Scout says "isn't available for your organization" | Gate 1 incomplete or still propagating | Verify Gate 1 and the attestation, then wait up to ~3 hours |
| Scout stuck at a waitlist screen | Gate 2 device policy missing | Confirm `AllowScoutFrontierAccess=1` |
| Scout has no internet | Subnet has no NAT and `defaultOutboundAccess=false` | Attach a NAT Gateway. AVD is inbound only. |
| `winget` says "No applicable installer found" for `--scope user` | That package is MSI or wix and requires admin | Add it to `Install-Baseline.ps1` instead |
| Downloaded Scout installer is about 138 KB | `aka.ms/scout` is an HTML landing page, not the binary | Resolve the real `download.microsoft.com` URL from that page |

More in [`../docs/troubleshooting.md`](../docs/troubleshooting.md).

## Security notes

- Users are **standard users** by design. Do not grant **Virtual Machine Administrator Login** to get software installed. Use the per-user paths above, or add the package to the machine baseline.
- The session host has **no public IP** and no inbound NSG rules. All session traffic arrives through the AVD gateway.
- Keep tenant IDs, device object IDs, and the local administrator password out of source control. Every value here is a parameter for that reason.
