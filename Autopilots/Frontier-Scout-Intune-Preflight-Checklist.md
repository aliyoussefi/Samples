# Microsoft Scout (Frontier) — Intune Enablement Pre-Flight Checklist

A one-page readiness checklist for enabling **Microsoft Scout (Frontier)** on **Intune-managed devices** in a tenant. Complete the items **in order**; several have propagation delays, so start early.

> **Key principle:** Scout uses a **two-gate** access model. Installing the app always succeeds — **sign-in** is where access is enforced. If any gate is incomplete, sign-in is **silently blocked** ("Microsoft Scout isn't available for your organization") with no clear in-product reason. Always verify the admin gates before troubleshooting the client.

Docs: [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) · [Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup) · [Policy templates](https://github.com/microsoft/scout-resources/tree/main/admins)

---

## Do this 1–2 days ahead (propagation stacks)

| # | Item | Owner | Lead time | Done |
|---|------|-------|-----------|:---:|
| 1 | **Enroll the org in the Frontier preview program** and accept terms. | Global / M365 admin | Same day | ☐ |
| 2 | **Turn on Copilot Frontier** — M365 admin center → Copilot → Settings → View all → search *Frontier* → **Copilot Frontier** → set **All users** or **Specific users** → Save. | M365 / Copilot admin | **Up to ~3 hrs to propagate** | ☐ |
| 3 | **Submit the attestation / opt-in form** (required — Scout can route data to third-party inference such as GitHub). | Org admin / decision maker | Same day | ☐ |
| 4 | **Confirm GitHub Copilot licensing** — each user has a GitHub account **and** a GitHub Copilot (Business/Enterprise) license. Set up GitHub org + SSO + license assignment if needed. | GitHub org admin | Hours–days (often the long pole) | ☐ |
| 5 | **Confirm devices are Intune-managed** — Entra-joined alone is **not** enough. For auto-enrollment of Entra-joined Windows: Entra → Mobility (MDM) → Microsoft Intune → set **MDM user scope**. | Intune admin | Varies | ☐ |

---

## Configure the Intune device policy (Gate 2)

| # | Item | Owner | Notes | Done |
|---|------|-------|-------|:---:|
| 6 | **Download policy templates** from the official repo: `microsoft-scout.admx`, `microsoft-scout.adml` (Windows) and `microsoft-scout.mobileconfig` (macOS). Use the **current** version. | Intune admin | Pre-release templates may still show the internal name **"Clawpilot"** | ☐ |
| 7 | **Import ADMX** — Intune → Devices → Configuration → **Import ADMX** → upload **both** the `.admx` and `.adml`. Wait for status **Available**. | Intune admin | Both files required | ☐ |
| 8 | **Create the Windows policy** — New policy → **Windows 10 and later** → **Templates** → **Imported Administrative Templates** (not "Settings catalog", not the built-in "Administrative Templates"). | Intune admin | Correct profile type matters | ☐ |
| 9 | Under **Microsoft Scout → Capabilities**, set **Allow Microsoft Scout Frontier access = Enabled**. | Intune admin | *Disabled* or *Not configured* → users hit a waitlist / blocked sign-in | ☐ |
| 10 | *(Optional, macOS)* Create a **custom configuration profile** from `microsoft-scout.mobileconfig`. | Intune admin | Only if Mac users are in scope | ☐ |
| 11 | *(Optional, security)* Review the policy's lockdown settings (disabled servers/permissions/models/providers, browser egress origins, restrict-to-workspace) with the security team. | Security + Intune admin | Set per customer policy | ☐ |
| 12 | **Assign** the policy to the target device/user group. | Intune admin | Not instant — Intune sync ~8 hrs default; use **Sync** to speed up | ☐ |

---

## Validate (on a managed test device)

| # | Item | Expected result | Done |
|---|------|-----------------|:---:|
| 13 | Force an Intune sync, then confirm the setting landed: registry `HKLM\SOFTWARE\Policies\Scout` → `AllowScoutFrontierAccess = 1`. | Value present = policy delivered | ☐ |
| 14 | Install Microsoft Scout (https://aka.ms/scout) and sign in: **GitHub** identity (carries the Copilot license) + **Microsoft 365** with the user's **own tenant** account. | Signs in; no "not available" / waitlist message | ☐ |
| 15 | If blocked, re-verify gates **admin-side first** (Frontier ON + propagated, attestation submitted, policy Enabled + assigned + synced, Copilot license present) before touching the client. | Root cause is almost always a gate, not the device | ☐ |

---

## Prerequisites & roles

- **Accounts:** work/school accounts only (no personal Microsoft accounts).
- **Windows prereq:** latest Microsoft Visual C++ Redistributable.
- **Roles needed** (often different people — line them up in advance):
  - M365 / Copilot admin → Copilot Frontier setting
  - Intune admin → ADMX import + policy
  - Org decision maker → attestation form
  - GitHub org admin → Copilot licensing

---

## Quick troubleshooting

| Symptom | Most likely cause | Action |
|---|---|---|
| "Microsoft Scout isn't available for your organization" | Gate 1 (Copilot Frontier) not on / not propagated | Verify + Save the setting; wait up to ~3 hrs |
| Blocked sign-in / waitlist screen | Gate 2 policy not Enabled / not delivered | Confirm **Enabled**, assigned, and synced; check the registry value on the device |
| Policy not landing on the device | Device not Intune-managed, or not synced | Confirm enrollment + MDM scope; force **Sync** |
| Sign-in works but no Copilot | Missing GitHub account / Copilot license | Assign GitHub Copilot; confirm the GitHub identity |
| Intune ADMX import error 131329 | Hand-edited ADMX with a duplicated `valueName` | Use the unmodified template from the repo |

---

*Note: This checklist covers Intune-managed endpoints. For a throwaway demo/test VM that isn't Intune-managed, the accompanying Bicep kit can set the equivalent device policy locally instead — see the kit README.*
