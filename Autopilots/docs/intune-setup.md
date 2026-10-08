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

### Step 4a - Review restrictions before assignment

**Enabling Scout does not mean enabling every model, tool or background action.** Before assigning the profile, agree with your security team which additional restrictions the pilot needs. The public Microsoft policy templates expose the controls below under **Microsoft Scout > Capabilities**, **AI Models**, and **Security**.

These are optional controls to configure according to organizational requirements, not a mandatory recommendation to block every capability.

| Area | Intune setting / policy key | Documented behavior |
|---|---|---|
| Individual models | **Disabled AI models** / `DisabledModels` | Blocks a comma-separated list of model IDs. The models are hidden from the picker and cannot be selected for new sessions. If the default is blocked, Scout falls back to the first allowed model. |
| Model providers | **Disabled AI model providers** / `DisabledProviders` | Blocks a comma-separated list of inference provider names. All models from those providers are hidden and cannot be used. |
| Tool/server access | **Disabled MCP servers** / `DisabledServers` | Blocks all tools from each listed MCP server config key. The template documents `filesystem`, `playwright`, and user-configured custom server keys. |
| Action permissions | **Disabled permission kinds** / `DisabledPermissions` | Unconditionally denies calls requiring a listed permission kind, without asking the user. Documented values are `shell`, `write`, `mcp`, `url`, and `custom-tool`. |
| Human approval | **Force human approval for all non-read actions** / `ForcePrompt` | Requires explicit approval for every tool call not classified as read-only, overriding global and per-server auto-approve preferences. This is an approval requirement, not an action block. |
| Periodic check-ins | **Disable Heartbeat** / `DisableHeartbeat` | Disables the periodic automated check-in feature, hides its toggle, and prevents users from re-enabling it. |
| Automations | **Disable Automations** / `DisableWorkflows` | Disables automation creation and scheduled execution. Existing automations do not run, and the Automations panel is hidden. |
| Local file/shell scope | **Restrict filesystem access to workspace** / `RestrictToWorkspace` | Restricts filesystem and shell access to the current workspace directory. The template warns that the MCP filesystem server loses access to skill directories, automation resources and other paths outside it. |
| Browser destinations | **Blocked browser egress origins** / `BrowserEgressBlockedOrigins` | Blocks navigation and requests to listed origins from the Playwright browser context before they leave the device. |

Source for the setting names and behaviors: Microsoft's [English policy help (ADML)](https://github.com/microsoft/scout-resources/blob/main/admins/en-US/microsoft-scout.adml). The [Windows ADMX](https://github.com/microsoft/scout-resources/blob/main/admins/microsoft-scout.admx) defines their categories, types and machine-level scope. Reviewed October 8, 2026. Preview templates and application behavior can change.

### Configure the controls safely

1. In the imported Scout profile's **Configuration settings**, open the appropriate category and setting.
2. For list settings, enable the policy and enter the comma-separated values in its text field. Use the exact current model IDs, inference provider names or MCP server config keys. Product display names are not interchangeable with these identifiers. Examples in the template may refer to older models.
3. For boolean restrictions, select **Enabled** to enforce the named restriction. In particular, enabling **Disable Automations** turns automations **off**. Enabling `ForcePrompt` instead leaves non-read actions available subject to approval.
4. Keep at least one permitted model/provider combination available and validate it in the pilot. Do not rely on an undocumented fallback when every model is blocked.
5. Save the profile, assign it to a limited pilot group, sync a device and perform the behavior checks below before broader rollout.

For example, a security-reviewed pilot could enable `ForcePrompt`, deny `shell` through `DisabledPermissions`, and enable `DisableWorkflows` until unattended workflows have been reviewed. This is an illustrative configuration, not a Microsoft-prescribed baseline. Disabling automations prevents scheduled agent scenarios such as Dawn, Alfred and Dusk from running.

### Important boundaries

- **Device policy, not a prompt.** All settings in the published Windows ADMX are machine-level under `HKLM\SOFTWARE\Policies\Scout`. A skill instruction such as "ask before sending" is not equivalent to centrally enforced policy.
- **Block versus approve.** `DisabledPermissions` denies the selected categories. `ForcePrompt` requires approval for non-read calls but does not itself disable those calls. Do not describe either as a documented per-business-action allowlist such as "allow CRM reads but deny only email sends."
- **Permission categories are broad.** The public template does not enumerate every tool's permission mapping. Validate the actual mail, CRM, file and browser actions your scenario uses. Do not assume `write` alone guarantees a universal read-only assistant.
- **Browser scope is limited.** `BrowserEgressBlockedOrigins` is a blocklist for the Playwright browser context, not a device-wide firewall or universal control on shell, MCP or model-provider traffic. Use approved network and data-protection controls for broader requirements.
- **Origins are not URLs with paths.** Use values such as `https://blocked.example.com` or `https://blocked.example.com:8443`. The template accepts only HTTP/HTTPS scheme, host and optional port. Entries containing paths, queries or fragments are silently ignored. Do not assume wildcard support.
- **Workspace restrictions can affect skills.** Test required skill and automation resources when enabling `RestrictToWorkspace`. Do not promise that existing workflows will continue unchanged.
- **Model lists are not a complete data-governance policy.** Blocking a model or inference provider does not replace tenant permissions, GitHub policies, licensing, sensitivity protections, or controls on other outbound data paths.
- **Do not infer active-session behavior.** The model help explicitly describes selection for new sessions. Validate new sessions and any already-running work after policy changes rather than assuming retroactive termination.
- **Avoid conflicting profiles.** Keep restriction values consistent across assigned profiles. Do not assume overlapping lists merge or that the most restrictive profile automatically wins. Investigate Intune conflicts.

## Step 5 — Assign the policy

For a targeted pilot, follow [Create pilot groups and configure assignments](pilot-groups-and-assignments.md). It covers separate user and device groups, profile targeting, and alignment with Frontier user eligibility.

Assign the profile to your target **device or user group**. Assignment is **not instant** — the default Intune sync is up to ~8 hours. Use **Sync** on a test device to speed up validation.

## Step 6 (optional) — macOS

If Mac users are in scope, create a **custom configuration profile** from `microsoft-scout.mobileconfig` and assign it to the target Mac group.

The [public macOS profile](https://github.com/microsoft/scout-resources/blob/main/admins/microsoft-scout.mobileconfig) also includes the restriction keys above as commented examples. Review and configure the needed entries **before upload**. They are not enforced while inside the XML comment. Follow the template's customization guidance, preserve its plist structure, and use its **Device channel** and `com.microsoft.clawpilot` domain.

macOS uses **booleans** for toggles and **arrays of strings** for lists, not Windows registry strings or comma-separated list text. Omitted keys are not enforced by this profile. The sample's brief comments differ from the detailed Windows help in places, including the descriptions of Heartbeat and approval scope. Validate the intended behavior on the deployed Mac build rather than assuming exact platform parity.

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

### Validate restrictions, not just successful sign-in

Use harmless test data and a standard pilot account. Record the Scout build, template revision or commit, assigned profile and test result.

| Configured control | Pilot check |
|---|---|
| Models/providers | Start a new session. Confirm blocked choices are unavailable and an approved model works. Test the default-model case if it was changed. |
| MCP servers/permissions | Attempt a benign action in a blocked category or from a blocked server. It should be denied, not offered for user approval. Confirm required permitted tools still work. |
| `ForcePrompt` | Attempt a harmless non-read action, such as creating a disposable test file in an approved location. Confirm approval is required despite auto-approve preferences, and decline to ensure it does not execute. |
| Heartbeat/automations | Confirm the disabled feature is unavailable and existing scheduled work cannot execute. Do not use real outgoing messages as a test. |
| Workspace scope | Verify access inside the intended workspace and denial of a harmless test file outside it. Check required skill resources separately. |
| Browser origins | Navigate to a harmless blocked test origin and an approved origin. Check the deny result and browser network evidence, including relevant redirects/subrequests. |

Successful registry delivery alone does not prove that every scenario is restricted as intended. If behavior differs, inspect policy assignment/conflicts and app/template compatibility before expanding the rollout. Changing an assignment to **Not configured** or removing it is not proof of immediate rollback; verify effective settings and behavior after sync.

If sign-in is still blocked, re-verify the gates **admin-side first** — see [troubleshooting](troubleshooting.md).

---

## Managed vs. unmanaged devices

| Scenario | How to deliver Gate 2 |
|---|---|
| **Intune-managed endpoints** (production) | **Import the ADMX and enable the policy** (this doc). Managed, auditable, self-healing across the fleet. |
| **Throwaway demo/test VM, not Intune-managed** | The optional Bicep kit can set the equivalent local registry value + a self-heal task instead — see [`../optional-test-vm/README.md`](../optional-test-vm/README.md). |

> Don't hand-set registry keys on **managed** devices — use the Intune policy so it's governed and re-applied automatically. The local registry value is only a legitimate stand-in on an **unmanaged** device, and it never bypasses Gate 1 (org entitlement and attestation are enforced server-side).
