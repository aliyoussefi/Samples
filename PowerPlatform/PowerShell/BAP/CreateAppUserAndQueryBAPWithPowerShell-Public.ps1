#https://docs.microsoft.com/en-us/power-platform/admin/powershell-create-service-principal

$tenantId = ""
$appId = ""
$secret = ""

#Run this first time only...
#=====================================================================================================
# Login interactively with a tenant administrator for Power Platform
Add-PowerAppsAccount -Endpoint prod -TenantID $tenantId 

# Register a new application, this gives the SPN / client application same permissions as a tenant admin
New-PowerAppManagementApp -ApplicationId $appId
#=====================================================================================================

#Query for Environments
Add-PowerAppsAccount -Endpoint prod -TenantID $tenantId -ApplicationId $appId -ClientSecret $secret -Verbose
$environmentsWithCapacity = InvokeApi -Method GET -Route 'https://api.bap.microsoft.com/providers/Microsoft.BusinessAppPlatform/scopes/admin/environments?$expand=properties.capacity,properties.addons&api-version=2020-10-01'