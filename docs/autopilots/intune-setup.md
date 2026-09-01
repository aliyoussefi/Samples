# Gate 2 — Configure the Microsoft Scout (Frontier) device policy with Intune

**Gate 2** is the **device** side of the two-gate model. It delivers the policy **`AllowScoutFrontierAccess`** to managed endpoints. Without it, a user who has already cleared [Gate 1](enable-frontier.md) still hits a **waitlist / blocked sign-in** screen.

The **supported path for managed devices is Intune** — import the Scout ADMX and enable the setting. This gives you a managed, auditable policy that Intune re-applies on its sync cycle across the fleet.

Reference: [Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup) · [Policy templates](https://github.com/microsoft/scout-resources/tree/main/admins)

---

## Prerequisites

- **Devices must be Intune-managed.** Entra-joined **alone is not enough**. For auto-enrollment of Entra-joined Windows devices: **Entra admin center → Mobility (MDM) → Microsoft Intune → set the MDM user scope**.
- **Intune administrator** rights.
- [Gate 1](enable-frontier.md) complete (org access, attestation, Copilot licensing).
- Windows client prerequisite: the latest **Microsoft Visual C++ Redistributable**.

---

## Step 1 — Download the policy templates

Get the **current** templates from the official repo: **[microsoft/scout-resources/admins](https://github.com/microsoft/scout-resources/tree/main/admins)**.

| File | Platform |
|---|---|
| `microsoft-scout.admx` + `microsoft-scout.adml` | Windows (Intune Imported Administrative Templates) |
| `microsoft-scout.mobileconfig` | macOS (custom configuration profile) |

> Use the **unmodified** template. Pre-release versions may still show the internal name **"Clawpilot"** in the UI — that's expected. Do **not** hand-edit the ADMX (a duplicated `valueName` causes import error **131329**).

## Step 2 — Import the ADMX into Intune

1. **Intune admin center → Devices → Configuration → Import ADMX.**
2. Upload **both** the `.admx` and the `.adml` file.
3. Wait for the import **Status** to show **Available** before continuing.

## Step 3 — Create the Windows policy

1. **Devices → Configuration → New policy.**
2. Platform: **Windows 10 and later.**
3. Profile type: **Templates → Imported Administrative Templates.**

   > This is **not** "Settings catalog" and **not** the built-in "Administrative Templates." Selecting the wrong profile type means the Scout setting won't be available.

## Step 4 — Enable the setting

Under **Microsoft Scout → Capabilities**, set:

**Allow Microsoft Scout Frontier access = Enabled**

> *Disabled* or *Not configured* → users hit a waitlist / blocked sign-in screen.

*(Optional, security)* Review the policy's lockdown settings — disabled servers/permissions/models/providers, browser egress origins, restrict-to-workspace — with your security team and set them per your organization's policy.

## Step 5 — Assign the policy

Assign the profile to your target **device or user group**. Assignment is **not instant** — the default Intune sync is up to ~8 hours. Use **Sync** on a test device to speed up validation.

## Step 6 (optional) — macOS

If Mac users are in scope, create a **custom configuration profile** from `microsoft-scout.mobileconfig` and assign it to the target Mac group.

---

## Validate on a managed device

1. Force an **Intune sync** on a target device.
2. Confirm the policy landed — registry:
   ```
   HKLM\SOFTWARE\Policies\Scout
     AllowScoutFrontierAccess = 1   (REG_SZ)
   ```
   The value being present means the policy was delivered.
3. Install Microsoft Scout from **https://aka.ms/scout** (per-user; no admin needed) and sign in:
   - **GitHub** identity (carries the Copilot license), **and**
   - **Microsoft 365** with the user's **own tenant** account.
4. Expected: signs in with **no** "not available" or waitlist message.

If sign-in is still blocked, re-verify the gates **admin-side first** — see [troubleshooting](troubleshooting.md).

---

## Managed vs. unmanaged devices

| Scenario | How to deliver Gate 2 |
|---|---|
| **Intune-managed endpoints** (production) | **Import the ADMX and enable the policy** (this doc). Managed, auditable, self-healing across the fleet. |
| **Throwaway demo/test VM, not Intune-managed** | The optional Bicep kit can set the equivalent local registry value + a self-heal task instead — see [`https://github.com/aliyoussefi/Samples/tree/main/Autopilots/optional-test-vm`](https://github.com/aliyoussefi/Samples/tree/main/Autopilots/optional-test-vm). |

> Don't hand-set registry keys on **managed** devices — use the Intune policy so it's governed and re-applied automatically. The local registry value is only a legitimate stand-in on an **unmanaged** device, and it never bypasses Gate 1 (org entitlement and attestation are enforced server-side).

