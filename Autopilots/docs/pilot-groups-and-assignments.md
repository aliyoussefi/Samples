# Target Microsoft Scout with ring-based groups and assignments

Use Microsoft Entra security groups to move people and managed devices through controlled Scout rollout rings. Keep **Frontier user eligibility**, **device policy**, **GitHub Copilot access**, and **app deployment** aligned. None of these settings replaces the others.

This guide complements [Intune setup](intune-setup.md) and [Frontier access](enable-frontier.md). It covers group creation and targeting, not template import or tenant enrollment.

> Scout Frontier is a preview. Confirm current requirements in Microsoft's [admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) before rollout.

## Recommended ring structure

Start with separate security groups using **Assigned** membership. Add approved members explicitly rather than introducing dynamic rules immediately. Use distinct user and device groups because a user can be approved while only some of that person's devices are in scope.

| Ring | User group | Windows device group | Typical population and exit criteria |
|---|---|---|---|
| Ring 0 | `Scout R0 Users` | `Scout R0 Windows Devices` | IT owners and administrators. Confirm gates, policy reporting, sign-in, support process, and rollback. |
| Ring 1 | `Scout R1 Users` | `Scout R1 Windows Devices` | Champions and representative business users. Confirm common workflows and support readiness. |
| Ring 2 | `Scout R2 Users` | `Scout R2 Windows Devices` | A department or broader early-adopter cohort. Confirm scale, communications, and operational impact. |
| Ring 3 | `Scout R3 Users` | `Scout R3 Windows Devices` | Broad production population after earlier rings meet their exit criteria. |

Create `Scout R0 Mac Devices`, `Scout R1 Mac Devices`, and equivalent groups only for rings that include macOS. Keep ring groups separate rather than nesting them. Assign every currently active ring to the relevant control; for example, when Ring 1 opens, the policy includes both the Ring 0 and Ring 1 device groups.

Creating a group grants no access by itself. Each service must be configured to use the intended population. Adding a user does not automatically add that person's devices to a separate device group, assign a GitHub Copilot seat, or enable Frontier.

## Assignment map

Use this matrix as the rollout record for each ring:

| Control | User ring | Device ring | Owner |
|---|---:|---:|---|
| Copilot Frontier **Specific users** | Required | No | M365 / Copilot admin |
| GitHub Copilot Business or Enterprise seat | Required | No | GitHub org admin |
| GitHub Copilot app policy | Required | No | GitHub enterprise / org admin |
| Windows Scout Intune policy | No | Required | Intune admin |
| macOS Scout configuration profile | No | Required when applicable | Intune admin |
| Scout managed-app assignment | Depends on app type | Depends on app type | Intune app admin |
| Ring communications and support | Required | Referenced | Rollout owner |

For each promotion, record the groups added, assignment owners, change time, expected propagation window, validation results, and rollback decision.

## Before you begin

- Confirm you are in the intended tenant in both Entra and Intune.
- Use an account authorized to create and manage groups, such as a Groups Administrator, and an appropriate Intune role for profile assignments. These are separate permissions.
- Identify each ring member and the exact device records to include. Confirm enrollment in Intune. Entra registration or join alone does not prove that Intune manages the device.
- Complete the Scout organization enrollment and attestation requirements described in [Frontier access](enable-frontier.md).

## Step 1 - Create the user ring groups

1. Open the [Microsoft Entra admin center](https://entra.microsoft.com).
2. Go to **Entra ID > Groups > All groups > New group**.
3. Set **Group type** to **Security**.
4. Enter **Scout R0 Users** as the first group name and describe the ring's population, owner, and entry criteria.
5. Leave **Microsoft Entra roles can be assigned to the group** set to **No**. This group targets a rollout, not administrator roles.
6. Set **Membership type** to **Assigned**.
7. Add an appropriate rollout administrator as an **Owner**.
8. Under **Members**, select the approved Ring 0 employees. Verify their work account identifiers rather than relying on display names alone.
9. Select **Create**.

Repeat for each planned user ring. To add or remove people later, open the appropriate group and use **Members**. Group ownership does not automatically make someone a ring member.

**For one person:** create Ring 0 with just that employee as a member. Groups let you expand the rollout without rebuilding its assignments.

## Step 2 - Create the device ring groups

1. Create another **Security** group with **Assigned** membership.
2. Name it **Scout R0 Windows Devices**.
3. Add a responsible **Owner**.
4. Add the approved Windows **device objects**, not the employees' user objects.
5. Confirm device identifiers against the Intune inventory, especially if duplicate or stale device names exist.
6. Select **Create**.

Repeat for each planned Windows ring. If Macs are included, create the corresponding Mac ring groups and use them for the macOS custom configuration profile described in [Intune setup](intune-setup.md#step-6-optional--macos).

**Example:** an employee uses a managed laptop and a managed desktop, but only the laptop is approved for Ring 1. Add the employee to `Scout R1 Users` and only the laptop to `Scout R1 Windows Devices`.

## Step 3 - Assign the Scout policy in Intune

For an existing Windows profile:

1. Open the [Microsoft Intune admin center](https://intune.microsoft.com).
2. Go to **Devices > Configuration** and open your Microsoft Scout profile.
3. Confirm **Allow Microsoft Scout Frontier access** is **Enabled** in the profile's configuration settings.
4. Open **Properties > Assignments > Edit**.
5. Under **Included groups**, select **Add groups**.
6. Select the device groups for every active ring, beginning with **Scout R0 Windows Devices**.
7. Review the entire assignment list. For a ringed rollout, remove any **All devices**, **All users**, or broader group assignment after confirming the impact with the policy owner.
8. Select **Review + Save**, then **Save**.

For a new profile, select the active ring groups on its **Assignments** page before creating it. For Macs, assign the macOS profile to the active Mac ring groups separately.

Also check for other Scout profiles with broader assignments. Narrowing one profile does not cancel another profile's assignment.

### Assignments, scope tags and exclusions

| Setting | What it controls |
|---|---|
| **Assignments** | Which user or device groups receive a profile. |
| **Scope tags** | Administrative visibility and management scope through Intune RBAC. They do not select rollout recipients. |
| **Excluded groups** | Exceptions to that profile's assignment. They do not block delivery from a different profile. |

For this device-targeted pattern, use device groups for both inclusion and any exclusions. Do not assume that excluding a user group removes that user's devices from a device-group assignment.

Intune can also target user groups for supported profiles and settings. This guide recommends device groups for clearly bounded Scout device-policy rings. Assigning a device-scoped setting through a user group does not turn it into a per-person sign-in permission.

## Step 4 - Align Frontier user access and licensing

Device enablement does not restrict Scout to only the people in your user group. Scope user eligibility separately:

1. Open **Microsoft 365 admin center > Copilot > Settings > View all**.
2. Find **Copilot Frontier**.
3. Choose **Specific users**, rather than **All users**, for a ringed rollout.
4. Select the users in every active ring using the picker available in your tenant. If it supports the intended groups, select them. Otherwise, select the approved users individually and reconcile that list against the user ring groups.
5. Save and allow propagation before testing.

Do not assume that an Intune assignment synchronizes Frontier eligibility. The Scout documentation specifies **Specific users** but does not establish that every tenant's picker supports the same group-selection experience.

Ensure each intended user also has the required GitHub Copilot Business or Enterprise seat and is allowed by the applicable GitHub Copilot app policy. Entra ring-group membership alone does not provision a GitHub seat. See the [current Scout access requirements](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview).

## Step 5 - Align app deployment, if you manage it through Intune

The Scout installer and the Scout configuration profile have **separate assignments**.

If your organization packages Scout as an Intune app, open that app's **Properties > Assignments** and target the active rollout rings. Use user or device groups according to the supported app type and installation context. Choose **Required** for managed installation or **Available** for user-initiated installation only where the app type supports it.

Do not leave the installer broadly assigned while assuming ring-scoped policy assignments narrow app distribution. Conversely, installing Scout does not satisfy its access gates.

## Validate and promote a ring

1. Confirm the intended employees are in the user ring and the correct managed devices are in the matching device ring.
2. Sync a device in the active ring with Intune.
3. Check the Scout profile's device assignment status and per-setting results. Investigate errors, conflicts and unexpected recipients.
4. Confirm the approved user can sign in after Frontier access, attestation, policy and licensing requirements are complete.
5. Confirm an out-of-scope user and device aren't receiving access through another group or broader assignment.
6. Confirm the Frontier eligibility list, GitHub Copilot seats and app policy still match the active user rings.
7. Record support issues, policy failures, security findings, user feedback, and the rollback decision.

For sign-in failures, use [Troubleshooting](troubleshooting.md). When the ring meets its exit criteria, add the next ring's groups to each required assignment. Do not move users between groups merely to preserve access; keep earlier rings assigned while later rings open so cohort history remains clear.

## Change or roll back membership

- **Add a person:** add the user to the appropriate ring, then update Frontier eligibility and GitHub access as needed. Add only approved devices to the matching device ring.
- **Promote a ring:** add that ring's user and device groups to every required control, allow for propagation, and validate before announcing availability.
- **Pause a ring:** stop adding members and investigate without changing earlier stable rings.
- **Roll back a ring:** remove that ring from Frontier eligibility, device-policy assignments, and managed-app assignments as required. Review GitHub licensing separately before removing seats used for other work.
- **Replace a device:** add the new managed device and remove the retired device from the ring group. Verify policy delivery on the new device.
- **Remove a person:** review their Frontier eligibility, relevant group memberships and app assignments. Do not remove a license used for other approved work without the license owner's review.
- **Remove a device:** remove it from the ring group and inspect the resulting policy state. Unassignment does not guarantee immediate removal of every device setting or uninstall the app. Follow the setting's documented removal behavior and verify the endpoint.

## References

- [Create and manage Microsoft Entra groups](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-groups)
- [Assign device profiles in Microsoft Intune](https://learn.microsoft.com/en-us/intune/device-configuration/assign-device-profile)
- [Set up Microsoft Scout with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)
- [Microsoft Scout admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview)

Guidance reviewed September 30, 2026. Portal labels and preview requirements can change.
