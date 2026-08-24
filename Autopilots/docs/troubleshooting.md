# Troubleshooting Microsoft Scout (Frontier) sign-in

Almost every Scout Frontier access problem traces back to **one of the two gates** being incomplete or not yet propagated — not to the client. Installing the app always succeeds; **sign-in** is where access is enforced. Work the **admin gates first**, then the device.

Reference: [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) · [Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)

---

## Decision flow

```
Sign-in blocked?
        │
        ▼
"isn't available for your organization"? ──► GATE 1 problem
        │  (org access / propagation)         • Copilot Frontier On + Saved?
        │                                      • ~3 h propagation elapsed?
        │                                      • Attestation form submitted?
        ▼
Waitlist / blocked sign-in screen? ─────────► GATE 2 problem
        │  (device policy)                     • Policy = Enabled?
        │                                      • Assigned + synced to the device?
        │                                      • Registry value present?
        ▼
Signs in but no Copilot? ───────────────────► GitHub Copilot license / identity
```

---

## Symptom → cause → fix

| Symptom | Most likely cause | Action |
|---|---|---|
| **"Microsoft Scout isn't available for your organization"** | Gate 1: Copilot Frontier not on, or not yet propagated | Confirm the setting is **On** and **Saved** for the user in the M365 admin center; **wait up to ~3 hours**; confirm the tenant is enrolled in the Frontier program and the attestation form was submitted. |
| **Waitlist / blocked sign-in screen** | Gate 2: device policy not Enabled or not delivered | Confirm the Intune policy is **Enabled**, **assigned**, and **synced**; check the registry value on the device (below). |
| **Policy not landing on the device** | Device not Intune-managed, or not synced | Confirm the device is **Intune-enrolled** (Entra-joined alone is not enough) and MDM scope is set; force **Sync**. |
| **Signs in, but no Copilot** | Missing GitHub account or Copilot license | Assign a **GitHub Copilot** (Business/Enterprise) license and confirm the user's **GitHub identity** in Scout. |
| **Intune ADMX import error 131329** | Hand-edited ADMX with a duplicated `valueName` | Re-import the **unmodified** template from [scout-resources/admins](https://github.com/microsoft/scout-resources/tree/main/admins). |
| **Scout setting missing when building the policy** | Wrong Intune profile type selected | Use **Templates → Imported Administrative Templates** (not "Settings catalog", not built-in "Administrative Templates"). |
| **GitHub Copilot usage higher than expected** | Background model calls from the **heartbeat** and/or **automations** | Tune the heartbeat interval/schedule or disable it, and review automations — see [cost-management.md](cost-management.md#background-consumption--heartbeat-and-automations). |

---

## Confirm the device policy landed (Gate 2)

On a Windows device, after an Intune sync:

```powershell
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Scout' -Name 'AllowScoutFrontierAccess'
# Expected: AllowScoutFrontierAccess : 1
```

- **Value present (`1`)** → the policy was delivered; if sign-in is still blocked, the issue is **Gate 1**.
- **Key/value missing** → the policy hasn't reached the device. Re-check enrollment, assignment, and force **Sync**. See [intune-setup.md](intune-setup.md).

---

## Re-verify checklist (admin-side first)

Before touching the client, confirm every gate:

- ☐ Tenant **enrolled** in the Frontier program.
- ☐ **Copilot Frontier = On** for the user **and** ~3 h propagation elapsed since Save.
- ☐ **Attestation / opt-in** form submitted.
- ☐ **GitHub Copilot** license assigned to the user.
- ☐ Device is **Intune-managed** and **synced**.
- ☐ Intune policy **Allow Microsoft Scout Frontier access = Enabled**, **assigned** to the device/user.
- ☐ Registry `HKLM\SOFTWARE\Policies\Scout\AllowScoutFrontierAccess = 1` present on the device.

If all boxes are checked and sign-in still fails, the most common remaining cause is **Gate 1 propagation** — wait and retry within the ~3-hour window, and re-confirm the Copilot Frontier setting actually saved.

---

## Common gotchas

- **Two identities, not one.** The **Microsoft 365** sign-in uses the user's **own tenant** account; the **GitHub** sign-in carries the **Copilot license**. Signing into M365 with a *different* org's account will look "unavailable."
- **Propagation stacks.** Frontier On (~3 h) and Intune assignment (~8 h default sync) both take time. Start Gate 1 a day or two ahead of a rollout.
- **Pre-release naming.** The Intune ADMX may display the internal name **"Clawpilot"** — this is expected and not an error.
- **Managed devices:** don't hand-edit the registry to "fix" a blocked device — deliver the policy through **Intune** so it stays governed and self-heals.
- **Cost creep from idle usage.** The **heartbeat** and **automations** make background model calls that consume GitHub Copilot premium requests even when you're not chatting. See [cost-management.md](cost-management.md).
