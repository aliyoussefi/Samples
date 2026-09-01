# Gate 1 — Enable Microsoft Scout (Frontier) organization access

**Gate 1** is the **organization** side of Microsoft Scout Frontier's two-gate access model. It's completed entirely by **tenant admins** and enforced **server-side at sign-in**. Until Gate 1 is complete and propagated, users see *"Microsoft Scout isn't available for your organization"* no matter what's configured on their device.

> Installing the Scout app always succeeds. **Sign-in** is where access is enforced. Complete Gate 1 **and** [Gate 2 (device policy)](intune-setup.md) before troubleshooting the client.

Reference: [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) · [Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)

---

## Who you need

Gate 1 usually spans **several different admins**. Line them up in advance — the propagation and licensing steps are the long poles.

| Task | Role |
|---|---|
| Enroll the org in the Frontier program | Global / M365 admin |
| Turn on Copilot Frontier | M365 / Copilot admin |
| Submit the attestation / opt-in form | Org decision maker |
| Assign GitHub Copilot licenses | GitHub org admin |

**Account requirements:** work/school accounts only (no personal Microsoft accounts).

---

## Step 1 — Enroll the tenant in the Frontier program

Enroll your tenant in the **[Copilot Frontier preview program](https://adoption.microsoft.com/en-us/copilot/frontier-program/)** and accept the terms. Frontier features (including Scout) are only offered to enrolled tenants.

## Step 2 — Turn on Copilot Frontier

1. Go to the **[Microsoft 365 admin center](https://admin.microsoft.com)** → **Copilot** → **Settings**.
2. Choose **View all**, then search for **Frontier**.
3. Open **Copilot Frontier** and set access to **All users** — or **Specific users** and include your Scout testers.
4. **Save.**
5. **Wait up to ~3 hours** for the setting to propagate. This is the most common cause of a sign-in that's still blocked after everything "looks right."

## Step 3 — Submit the attestation / opt-in form

Because Scout can route data to **third-party inference** (e.g. GitHub), an org decision maker must submit the **Frontier organization sign-up / attestation form** accepting the associated terms. This is a required, separate step from turning on the setting.

> The exact form link is surfaced during Frontier program enrollment and in the [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview). Use the current link from those sources rather than a cached one.

## Step 4 — Confirm GitHub Copilot licensing

Scout uses a **GitHub identity** for token billing, so **each user needs a GitHub account and a GitHub Copilot license (Business or Enterprise).**

- If your org doesn't already run GitHub Copilot, this is frequently the **long pole**: setting up the GitHub org, SSO, and license assignment can take hours to days.
- The **Microsoft 365** sign-in uses the user's **own tenant** account; the **GitHub** sign-in carries the **Copilot entitlement**. They are two separate identities in Scout.

---

## Verify Gate 1

Gate 1 is done when **all** of the following are true:

- ☐ Tenant enrolled in the Frontier program (terms accepted).
- ☐ **Copilot Frontier** = On for the intended users, **and** at least ~3 hours have passed since Save.
- ☐ Attestation / opt-in form submitted.
- ☐ Every target user has a GitHub account **and** a GitHub Copilot license.

Once Gate 1 is verified, move to **[Gate 2 — Intune device policy](intune-setup.md)**.

---

## What Gate 1 does *not* do

Gate 1 grants the **organization** entitlement. It does **not** enable Scout Frontier on a specific device — that's [Gate 2](intune-setup.md), the `AllowScoutFrontierAccess` policy. A user who has passed Gate 1 but whose device lacks the policy will hit a **waitlist / blocked sign-in** screen rather than the "not available for your organization" message. See [troubleshooting](troubleshooting.md) to tell the two apart.
