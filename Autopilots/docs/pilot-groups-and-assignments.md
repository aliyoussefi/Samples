# Target Microsoft Scout rollout with pilot groups

Use Microsoft Entra security groups to select the people and managed devices in a Scout pilot. Keep **user eligibility**, **device policy**, and **app deployment** aligned. None of these settings replaces the others.

This guide complements [Intune setup](intune-setup.md) and [Frontier access](enable-frontier.md). It covers group creation and targeting, not template import or tenant enrollment.

> Scout Frontier is a preview. Confirm current requirements in Microsoft's [admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview) before rollout.

## Recommended group structure

For a small pilot, start with separate security groups using **Assigned** membership. Add approved members explicitly rather than introducing dynamic rules immediately.

| Example group | Members | Purpose |
|---|---|---|
| `Scout Pilot Users` | Approved employees | Maintain the approved user population and align Frontier access, licensing and any user-targeted app assignment. |
| `Scout Pilot Windows Devices` | Approved, Intune-managed Windows devices | Receive the Windows Scout Frontier device policy. |
| `Scout Pilot Mac Devices` | Approved, Intune-managed Macs, if needed | Receive the separate macOS Scout configuration profile. |

Creating a group grants no access by itself. Each service must be configured to use the intended population. Adding a user does not automatically add that person's devices to a separate device group.

## Before you begin

- Confirm you are in the intended tenant in both Entra and Intune.
- Use an account authorized to create and manage groups, such as a Groups Administrator, and an appropriate Intune role for profile assignments. These are separate permissions.
- Identify each pilot employee and the exact device records to include. Confirm enrollment in Intune. Entra registration or join alone does not prove that Intune manages the device.
- Complete the Scout organization enrollment and attestation requirements described in [Frontier access](enable-frontier.md).

## Step 1 - Create the user group

1. Open the [Microsoft Entra admin center](https://entra.microsoft.com).
2. Go to **Entra ID > Groups > All groups > New group**.
3. Set **Group type** to **Security**.
4. Enter **Scout Pilot Users** as the group name and a description of the pilot's purpose.
5. Leave **Microsoft Entra roles can be assigned to the group** set to **No**. This group targets a rollout, not administrator roles.
6. Set **Membership type** to **Assigned**.
7. Add an appropriate rollout administrator as an **Owner**.
8. Under **Members**, select the intended employees. Verify their work account identifiers rather than relying on display names alone.
9. Select **Create**.

To add or remove people later, open the group and use **Members**. Group ownership does not automatically make someone a pilot member.

**For one person:** create the group with just that employee as a member. Groups let you expand the pilot without rebuilding its assignments.

## Step 2 - Create the device group

1. Create another **Security** group with **Assigned** membership.
2. Name it **Scout Pilot Windows Devices**.
3. Add a responsible **Owner**.
4. Add the approved Windows **device objects**, not the employees' user objects.
5. Confirm device identifiers against the Intune inventory, especially if duplicate or stale device names exist.
6. Select **Create**.

If Macs are included, repeat for **Scout Pilot Mac Devices**. Use that group for the macOS custom configuration profile described in [Intune setup](intune-setup.md#step-6-optional--macos).

**Example:** an employee uses a managed laptop and a managed desktop, but only the laptop is approved for the pilot. Add the employee to `Scout Pilot Users` and only the laptop to `Scout Pilot Windows Devices`.

## Step 3 - Assign the Scout policy in Intune

For an existing Windows profile:

1. Open the [Microsoft Intune admin center](https://intune.microsoft.com).
2. Go to **Devices > Configuration** and open your Microsoft Scout profile.
3. Confirm **Allow Microsoft Scout Frontier access** is **Enabled** in the profile's configuration settings.
4. Open **Properties > Assignments > Edit**.
5. Under **Included groups**, select **Add groups**.
6. Select **Scout Pilot Windows Devices**.
7. Review the entire assignment list. If this profile must be pilot-only, remove any **All devices**, **All users**, or broader group assignment after confirming the impact with the policy owner.
8. Select **Review + Save**, then **Save**.

For a new profile, select the same group on its **Assignments** page before creating it. For Macs, assign the macOS profile to the Mac device group separately.

Also check for other Scout profiles with broader assignments. Narrowing one profile does not cancel another profile's assignment.

### Assignments, scope tags and exclusions

| Setting | What it controls |
|---|---|
| **Assignments** | Which user or device groups receive a profile. |
| **Scope tags** | Administrative visibility and management scope through Intune RBAC. They do not select rollout recipients. |
| **Excluded groups** | Exceptions to that profile's assignment. They do not block delivery from a different profile. |

For this device-targeted pattern, use device groups for both inclusion and any exclusions. Do not assume that excluding a user group removes that user's devices from a device-group assignment.

Intune can also target user groups for supported profiles and settings. This guide recommends device groups for a clearly bounded Scout device-policy pilot. Assigning a device-scoped setting through a user group does not turn it into a per-person sign-in permission.

## Step 4 - Align Frontier user access and licensing

Device enablement does not restrict Scout to only the people in your user group. Scope user eligibility separately:

1. Open **Microsoft 365 admin center > Copilot > Settings > View all**.
2. Find **Copilot Frontier**.
3. Choose **Specific users**, rather than **All users**, for a restricted pilot.
4. Select the approved population using the picker available in your tenant. If it supports the intended group, select it. Otherwise, select the approved users individually and maintain that list alongside `Scout Pilot Users`.
5. Save and allow propagation before testing.

Do not assume that an Intune assignment synchronizes Frontier eligibility. The Scout documentation specifies **Specific users** but does not establish that every tenant's picker supports the same group-selection experience.

Ensure each intended user also has the required GitHub Copilot Business or Enterprise seat and is allowed by the applicable GitHub Copilot app policy. An Entra pilot-group membership alone does not provision a GitHub seat. See the [current Scout access requirements](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview).

## Step 5 - Align app deployment, if you manage it through Intune

The Scout installer and the Scout configuration profile have **separate assignments**.

If your organization packages Scout as an Intune app, open that app's **Properties > Assignments** and target the intended pilot population. Use user or device groups according to the supported app type and installation context. Choose **Required** for managed installation or **Available** for user-initiated installation only where the app type supports it.

Do not leave the installer broadly assigned while assuming the pilot profile narrows app distribution. Conversely, installing Scout does not satisfy its access gates.

## Validate before expanding

1. Confirm the intended employee is in the user group and the correct managed device is in the device group.
2. Sync a pilot device with Intune.
3. Check the Scout profile's device assignment status and per-setting results. Investigate errors, conflicts and unexpected recipients.
4. Confirm the approved user can sign in after Frontier access, attestation, policy and licensing requirements are complete.
5. Confirm an out-of-scope device is not receiving the pilot profile through another group or broader assignment.
6. Confirm the Frontier eligibility list still matches the approved user population.

For sign-in failures, use [Troubleshooting](troubleshooting.md). Keep membership and assignment changes auditable before extending the pilot to more people.

## Expand or remove pilot membership

- **Add a person:** update the user group, Frontier eligibility and licensing as needed. Add only their approved devices to the appropriate device group.
- **Replace a device:** add the new managed device and remove the retired device from the pilot group. Verify policy delivery on the new device.
- **Remove a person:** review their Frontier eligibility, relevant group memberships and app assignments. Do not remove a license used for other approved work without the license owner's review.
- **Remove a device:** remove it from the pilot group and inspect the resulting policy state. Unassignment does not guarantee immediate removal of every device setting or uninstall the app. Follow the setting's documented removal behavior and verify the endpoint.

## References

- [Create and manage Microsoft Entra groups](https://learn.microsoft.com/en-us/entra/fundamentals/how-to-manage-groups)
- [Assign device profiles in Microsoft Intune](https://learn.microsoft.com/en-us/intune/device-configuration/assign-device-profile)
- [Set up Microsoft Scout with Intune](https://learn.microsoft.com/en-us/microsoft-scout/admin-intune-setup)
- [Microsoft Scout admin access overview](https://learn.microsoft.com/en-us/microsoft-scout/admin-access-overview)

Guidance reviewed September 30, 2026. Portal labels and preview requirements can change.
