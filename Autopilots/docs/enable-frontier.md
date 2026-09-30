# Gate 1 — Enable Microsoft Scout (Frontier) organization access

**Gate 1** is the **Frontier access** side of Microsoft Scout's two-gate access model. A tenant admin enables Copilot Frontier for all users or a selected user population in the Microsoft 365 admin center. The setting is enforced **server-side at sign-in**. Until Gate 1 is complete and propagated for a user, that user cannot sign in no matter what's configured on their device.

> Installing the Scout app always succeeds. **Sign-in** is where access is enforced. Complete Gate 1 and all Gate 2 requirements -- [device policy](intune-setup.md), organization attestation, and GitHub Copilot access -- before troubleshooting the client.

Reference: [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) · [Set up with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)

---

## Who you need

The end-to-end rollout usually spans **several different admins**. Line them up in advance -- the propagation and licensing steps are the long poles.

| Task | Role |
|---|---|
| Enroll the org in the Frontier program | Global / M365 admin |
| Turn on Copilot Frontier | M365 / Copilot admin |
| Create and maintain rollout groups | Groups administrator |
| Assign Scout device policy and managed app | Intune administrator |
| Submit the attestation / opt-in form | Org decision maker |
| Assign GitHub Copilot licenses | GitHub org admin |

**Account requirements:** work/school accounts only (no personal Microsoft accounts).

---

## Step 1 — Enroll the tenant in the Frontier program

Enroll your tenant in the **[Copilot Frontier preview program](https://adoption.microsoft.com/en-us/copilot/frontier-program/)** and accept the terms. Frontier features (including Scout) are only offered to enrolled tenants.

## Step 2 — Plan the rollout population

For a ring-based deployment, create separate Microsoft Entra security groups for users and managed devices before enabling access. A group is a cohort definition; it grants nothing until an admin assigns a service or policy to it.

| Ring | Example user group | Example device group | Purpose |
|---|---|---|---|
| Ring 0 | `Scout R0 Users` | `Scout R0 Windows Devices` | IT owners and administrators validating access, policy delivery, support, and rollback. |
| Ring 1 | `Scout R1 Users` | `Scout R1 Windows Devices` | A small set of champions and representative business users. |
| Ring 2 | `Scout R2 Users` | `Scout R2 Windows Devices` | A department or broader early-adopter cohort. |
| Ring 3 | `Scout R3 Users` | `Scout R3 Windows Devices` | Broad production deployment after prior rings meet exit criteria. |

Create equivalent Mac device groups only when macOS is in scope. Start with **Assigned** membership so rollout owners explicitly approve each user and device. Keep rings separate instead of nesting groups; this makes assignments, reporting, and rollback easier to reason about.

Use [Ring-based groups and assignments](pilot-groups-and-assignments.md) for group creation, assignment mapping, validation, and ring promotion guidance.

## Step 3 — Turn on Copilot Frontier

1. Go to the **[Microsoft 365 admin center](https://admin.microsoft.com)** → **Copilot** → **Settings**.
2. Choose **View all**, then search for **Frontier**.
3. Open **Copilot Frontier**.
4. For a ring-based rollout, choose **Specific users** and select the users approved for the currently enabled rings. If the picker in your tenant supports the intended Entra groups, select those groups. Otherwise, select the approved users individually and reconcile the selection against the ring groups.
5. Use **All users** only when the rollout owner has approved broad deployment and the device-policy, attestation, licensing, app-policy, and support prerequisites are ready at that scale.
6. **Save.**
7. **Wait up to ~3 hours** for the setting to propagate. This is the most common cause of a sign-in that's still blocked after everything "looks right."

Do not enable the next ring only in the Microsoft 365 admin center. The same cohort must be ready across every required control:

| Control | Ring assignment |
|---|---|
| Copilot Frontier | Enable the users in the active ring through **Specific users**. |
| Scout Intune policy | Assign the corresponding Windows and macOS device groups. |
| GitHub Copilot | Assign Business or Enterprise seats and allow the GitHub Copilot app for ring users. |
| Scout app deployment | Assign the managed app to the intended user or device ring, if Intune deploys it. |
| Support and communications | Notify the ring, identify support owners, and record entry and exit criteria. |

An Entra group does not synchronize these systems automatically. Each service owner must apply the approved ring population to their own control.

## Step 4 — Complete the attestation / opt-in

Because Scout can route data to **third-party inference** (for example, GitHub), an organization decision maker must submit the **Frontier organization sign-up / attestation form** accepting the associated terms. This is a separate Gate 2 requirement and applies even after Frontier access is enabled.

Use the current form linked from the [Admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview).

## Step 5 — Confirm GitHub Copilot licensing and policy

Scout uses a **GitHub identity** for token billing, so **each user needs a GitHub account and a GitHub Copilot Business or Enterprise license.** The organization or enterprise policy must also allow the **GitHub Copilot app** for that user.

- If your org doesn't already run GitHub Copilot, this is frequently the **long pole**: setting up the GitHub org, SSO, license assignment, and app policy can take hours to days.
- The **Microsoft 365** sign-in uses the user's **own tenant** account; the **GitHub** sign-in carries the **Copilot entitlement**. They are two separate identities in Scout.
- Assign seats to each active user ring before promoting it. Entra group membership alone does not provision a GitHub Copilot seat.

---

## Verify the active ring

Before releasing an active ring, confirm **all** of the following:

- ☐ Tenant enrolled in the Frontier program (terms accepted).
- ☐ Ring user and device memberships are approved and recorded.
- ☐ **Copilot Frontier** = On for the ring users, **and** up to ~3 hours have passed since Save.
- ☐ Attestation / opt-in form submitted.
- ☐ Scout Intune policy is assigned and successfully applied to the ring devices.
- ☐ Every ring user has a GitHub account, a GitHub Copilot Business or Enterprise seat, and an allowed GitHub Copilot app policy.
- ☐ Scout app deployment is assigned to the intended ring, if centrally managed.
- ☐ In-scope users can sign in and an out-of-scope user or device does not receive unintended access.

Promote the next ring only after the current ring meets the rollout owner's success, support, security, and rollback criteria.

---

## What Gate 1 does *not* do

Gate 1 makes Frontier available to the selected users. It does **not** complete the Scout admin enablement requirements: the organization must submit the attestation, users need GitHub Copilot access, and target devices need the [Gate 2 Intune policy](intune-setup.md) with `AllowScoutFrontierAccess` enabled. See [troubleshooting](troubleshooting.md) to distinguish these failures.
