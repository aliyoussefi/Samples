# Optional — Windows 11 test VM for Microsoft Scout (Frontier)

> **You do not need this to enable Scout Frontier.** For a real tenant, follow the documentation-first path in the parent folder — [`../docs/enable-frontier.md`](../docs/enable-frontier.md) (Gate 1) and [`../docs/intune-setup.md`](../docs/intune-setup.md) (Gate 2). This folder is **entirely optional** and exists only to spin up an **isolated Windows 11 sandbox** for demoing or testing Frontier when you don't have an Intune-managed device handy.

This kit deploys a Windows 11 Azure VM that can run Microsoft Scout (Frontier), reachable via **Azure Bastion** (works from corporate networks that block raw RDP), with **outbound internet** (NAT Gateway), **Microsoft Entra ID login**, and the **Frontier device policy** pre-set locally.

## Contents

| File | Purpose |
|---|---|
| `win11-frontier-scout.bicep` | Infrastructure-as-code: VNet, Bastion, NAT Gateway, Win 11 VM (Trusted Launch), Entra login, and the local Frontier device policy + self-heal task |
| `win11-frontier-scout.json` | ARM JSON build of the same template (for `az deployment` without Bicep) |
| `deploy.ps1` | Helper that registers prerequisites, runs what-if, deploys, and prints connect info |

## How it maps to the two gates

| Gate | On this VM |
|---|---|
| **Gate 1 — org access** | **Still manual.** The template **cannot** do this — you must turn on Copilot Frontier, submit the attestation form, and confirm GitHub Copilot licensing yourself. See [`../docs/enable-frontier.md`](../docs/enable-frontier.md). |
| **Gate 2 — device policy** | Set **locally** by the template (`AllowScoutFrontierAccess=1` in `HKLM\SOFTWARE\Policies\Scout`, plus a startup scheduled task that re-asserts it). This is the **unmanaged-device stand-in** for the Intune policy — it does **not** bypass Gate 1. |

## Prerequisites

- **Azure CLI** (`az`). Bicep auto-installs on first use.
- **Owner** (or Contributor + User Access Administrator) on the target subscription.
- Tenant admin rights for the manual **Gate 1** steps, and a **GitHub Copilot** license per user.

## Deploy

```powershell
cd optional-test-vm
.\deploy.ps1 -SubscriptionId "<your-sub-guid>" `
             -ResourceGroup "rg-win11-scout" `
             -Location "eastus" `
             -EntraLoginUpn "admin@<tenant>.onmicrosoft.com"
```

The script sets the subscription, registers the public-IP feature if needed (one-time), creates the resource group, resolves the Entra user, shows a **what-if** preview, deploys, and prints how to connect.

> **`SkuNotAvailable`?** The chosen `vmSize` has no capacity in that region for your subscription. Re-run with a different `-VmSize` (e.g. `Standard_D2s_v5`, `Standard_B2ms`) or `-Location`.

## Connect

Azure Portal → your VM → **Connect → Bastion**. Use the local `azureuser` + password, or the **Microsoft Entra ID** option with the account you granted in `-EntraLoginUpn`.

> Raw RDP (port 3389) to a public IP is often reset by corporate IPS. Bastion tunnels RDP inside HTTPS/443, which is why this kit uses it.

## Then enable Scout

1. On the VM, install Scout from **https://aka.ms/scout**.
2. Complete **Gate 1** (see [`../docs/enable-frontier.md`](../docs/enable-frontier.md)) — the template does not and cannot do this for you.
3. Sign in: **GitHub** identity (Copilot license) + **Microsoft 365** with your **tenant** account.
4. Still "not available for your organization"? It's almost always **Gate 1 propagation** — wait up to ~3 hours and retry. See [`../docs/troubleshooting.md`](../docs/troubleshooting.md).

## Policy durability & cost

- The local device policy **survives reboots** and **self-heals at startup** via the `EnsureScoutFrontierPolicy` task. A **reimage/reprovision** (OS disk rebuild) loses it — redeploy the template to restore it.
- For **managed** endpoints, don't use this local value — deliver the policy through **Intune** ([`../docs/intune-setup.md`](../docs/intune-setup.md)). To skip the local policy at deploy time, pass `setFrontierDevicePolicy=false`.
- While running, this bills for **VM compute**, **Azure Bastion (Standard, hourly, cannot be paused)**, **NAT Gateway**, **public IPs**, and the **OS disk**. Stop compute with `az vm deallocate`; delete the resource group for true $0.

## Parameters (`win11-frontier-scout.bicep`)

| Parameter | Default | Notes |
|---|---|---|
| `location` | resource group location | Change if SKU capacity is constrained |
| `vmName` | `win11-vm01` | Prefix for all resource names |
| `adminUsername` | `azureuser` | Local admin |
| `adminPassword` | — (secure) | Min 12 chars, 3 of 4 complexity classes |
| `vmSize` | `Standard_DC2s_v3` | Safe on constrained subs; use `Standard_D2s_v5` where available |
| `windows11Sku` | `win11-24h2-pro` | Any standard Win 11 Marketplace SKU |
| `entraLoginPrincipalId` | `''` | Entra user object ID; empty skips role assignment |
| `entraLoginRole` | `Administrator` | `Administrator` or `User` |
| `setFrontierDevicePolicy` | `true` | Set `false` for Intune-managed devices |
