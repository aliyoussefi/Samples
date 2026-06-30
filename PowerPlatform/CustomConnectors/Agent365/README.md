# Agent 365 Connector — Custom Power Platform Connector

This README explains what `Agent-365-Connector.swagger.json` contains and walks you through
building a **custom connector** from it in Power Automate / Power Apps so you can call the
Microsoft Graph **Copilot / Agent 365 (beta)** endpoints from flows and apps.

It follows the official Microsoft Graph + Power Automate custom-connector pattern:
<https://learn.microsoft.com/en-us/graph/tutorials/power-automate>

> ⚠️ **Beta APIs.** Every operation in this definition targets the Microsoft Graph **`/beta`**
> endpoint. Beta APIs are subject to change and are not supported for production workloads.

---

## 1. What's in the swagger file

The OpenAPI (Swagger 2.0) definition targets host `graph.microsoft.com` over HTTPS and exposes
the following operations:

| Operation ID | Method | Path | Description |
|---|---|---|---|
| `GetPackages` | GET | `/beta/copilot/admin/catalog/packages` | List agent packages (supports `$filter`). |
| `GetPackageDetails` | GET | `/beta/copilot/admin/catalog/packages/{id}` | Get details for a specific agent/app by ID. |
| `UpdatePackageDetails` | PATCH | `/beta/copilot/admin/catalog/packages/{id}` | Update a package's `allowedUsersAndGroups` / `acquireUsersAndGroups`. |
| `GetAgentRegistration` | GET | `/beta/copilot/agentRegistrations/{id}` | Retrieve an `agentRegistration` object (supports `$select`). |
| `GetWeeklyCopilotUserCountSummary` | GET | `/beta/copilot/reports/getMicrosoft365CopilotUserCountSummary(period='D7')` | Aggregated active/enabled M365 Copilot user counts for the last 7 days. |

**Authentication:** OAuth 2.0 (Microsoft Entra ID). The definition declares an `accessCode`
(authorization code) flow plus application/certificate flows. For the steps below we use the
standard **OAuth 2.0 → Microsoft Entra ID** delegated flow.

---

## 2. Prerequisites

- Administrator access to a Microsoft 365 tenant.
- Power Automate (or Power Apps) access with a **Premium** license (90-day trial works).
- Permission to register an app in **Microsoft Entra ID**.

---

## 3. Register an app in Microsoft Entra ID

1. Go to the [Microsoft Entra admin center](https://entra.microsoft.com) and sign in as a Global administrator.
2. **Identity → Applications → App registrations → New registration**.
3. Name it e.g. `Agent 365 Connector App`, choose **Accounts in any organizational directory**,
   leave **Redirect URI** blank, and select **Register**.
4. Copy the **Application (client) ID** — you'll need it for the connector.
5. **API permissions → Add a permission → Microsoft Graph → Delegated permissions**, then add the
   scopes required by these APIs. Suitable candidates include:
   - `CopilotSettings-LimitedMode.ReadWrite.All` / appropriate Copilot admin scopes for the catalog/package operations
   - `Reports.Read.All` for the user-count summary report
   - `AgentApplication.Read.All` (or the relevant agent registration scope)

   > These are beta endpoints; confirm exact scopes in the Microsoft Graph permissions reference for
   > each operation and grant **admin consent** afterward.
6. **Certificates & secrets → New client secret**. Add a description and duration, then **copy the
   secret value immediately** (it's only shown once).

---

## 4. Create the custom connector from the swagger file

1. Open [Power Automate](https://make.powerautomate.com/) and sign in as the tenant administrator.
2. In the left menu choose **More → Discover all → Custom connectors** (under Data).
3. Top right: **New custom connector → Import an OpenAPI file**.
4. Give it a name (e.g. `Agent 365 Connector`), browse to
   `Agent-365-Connector.swagger.json`, and select **Continue**.

   > Alternatively use **Create from blank** and set **Scheme** = HTTPS, **Host** = `graph.microsoft.com`,
   > **Base URL** = `/`, then define the actions manually — but importing the swagger does this for you.

5. **General** tab — confirm:
   - **Scheme**: HTTPS
   - **Host**: `graph.microsoft.com`
   - **Base URL**: `/`

6. **Security** tab — configure OAuth 2.0:
   - **Authentication type**: `OAuth 2.0`
   - **Identity Provider**: `Microsoft Entra ID`
   - **Client id**: the Application (client) ID from step 3
   - **Client secret**: the client secret from step 3
   - **Login url**: `https://login.microsoftonline.com`
   - **Tenant ID**: `common`
   - **Resource URL**: `https://graph.microsoft.com` (no trailing `/`)
   - **Scope**: leave blank (or list the delegated scopes you granted)

7. **Definition** tab — verify the five imported actions (`GetPackages`, `GetPackageDetails`,
   `UpdatePackageDetails`, `GetAgentRegistration`, `GetWeeklyCopilotUserCountSummary`) and their
   parameters look correct.

8. Select **Create connector** (top right).

9. After creation, open the **Security** tab and copy the generated **Redirect URL**.

10. Back in the Entra admin center → your app → **Authentication → Add a platform → Web**, paste the
    **Redirect URL**, and select **Configure**.

---

## 5. Authorize the connector (create a connection)

1. In Power Automate choose **More → Connections → New connection**.
2. Find your **Agent 365 Connector** and select **Create**.
3. Sign in with your tenant administrator account.
4. When prompted, check **Consent on behalf of your organization** and **Accept**.

A cached connection is now created and the connector is ready to use. Permission propagation can
take a few minutes.

---

## 6. Use the connector in a flow

1. **My flows → New flow → Instant cloud flow** (e.g. `List Agent Packages`), trigger **Manually
   trigger a flow**, then **Create**.
2. Add a step → **Custom** → select your **Agent 365 Connector**, then pick an action, e.g.
   **GetPackages**.
3. Optionally set `$filter` (for `GetPackages`) or the `id` path parameter (for
   `GetPackageDetails` / `GetAgentRegistration`).
4. For **UpdatePackageDetails (PATCH)**, supply the `id` and a body such as:

   ```json
   {
     "allowedUsersAndGroups": [
       { "resourceType": "group", "resourceId": "<group-object-id>" }
     ],
     "acquireUsersAndGroups": [
       { "resourceType": "group", "resourceId": "<group-object-id>" }
     ]
   }
   ```

5. **Save**, then **Test** to run the flow and inspect the response.

---

## 7. Troubleshooting

- **401 / consent errors**: Re-check the delegated scopes and that admin consent was granted; recreate
  the connection.
- **Redirect URL mismatch**: Ensure the connector's Redirect URL is registered exactly under the app's
  **Web** platform in Entra.
- **403 on Copilot/agent endpoints**: The signed-in account may lack the required Copilot admin role or
  the tenant may not be enabled for Agent 365 features.
- **Beta endpoint changes**: If a call fails unexpectedly, verify the path against the current Microsoft
  Graph beta reference — beta surfaces change without notice.

---

## References

- Tutorial: <https://learn.microsoft.com/en-us/graph/tutorials/power-automate>
- Custom connectors overview: <https://learn.microsoft.com/en-us/connectors/custom-connectors/>
- Microsoft Graph beta reference: <https://learn.microsoft.com/en-us/graph/api/overview?view=graph-rest-beta>
