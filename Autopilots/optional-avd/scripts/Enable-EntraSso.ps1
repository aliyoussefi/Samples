<#
.SYNOPSIS
    Enable Microsoft Entra single sign-on for the AVD web client.

.DESCRIPTION
    Without this, connecting to an Entra-joined session host from the AVD web client
    fails with a credential prompt and "Sign in Failed".

    Four things are required:
      1. The 'Windows Cloud Login' service principal must exist in the tenant.
         It is frequently absent in dev tenants and must be created.
      2. Remote Desktop Protocol must be enabled on that service principal.
      3. The session host's device must sit in an Entra group registered as a
         trusted target device group, which suppresses the per-connection consent
         prompt that standard users cannot approve.
      4. The host pool must advertise SSO through its custom RDP properties.

    This is a separate script from deploy.ps1 because it needs directory rights,
    not just Azure resource rights. It is NOT the OAuth admin-consent flow that
    tenants often block, so it usually succeeds where that would fail.

.NOTES
    Requires Application Administrator or Global Administrator.
    Safe to re-run.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $ResourceGroup,
    [Parameter(Mandatory)] [string] $HostPoolName,
    [Parameter(Mandatory)] [string] $SessionHost,

    [string] $DeviceGroupName = 'AVD-Scout-Hosts'
)

$ErrorActionPreference = 'Stop'

# Windows Cloud Login. This app ID is the same in every tenant.
$WindowsCloudLoginAppId = '270efc09-cd0d-444b-a71f-39af4910ec45'

function Step { param([string] $m) Write-Host "`n==> $m" -ForegroundColor Cyan }

# --------------------------------------------------------------------------
Step 'Ensuring the Windows Cloud Login service principal exists'

$sp = az ad sp list --filter "appId eq '$WindowsCloudLoginAppId'" --query '[0].id' -o tsv 2>$null
if (-not $sp) {
    Write-Host '    not present, creating it'
    az rest --method post `
            --url 'https://graph.microsoft.com/v1.0/servicePrincipals' `
            --headers 'Content-Type=application/json' `
            --body "{`"appId`":`"$WindowsCloudLoginAppId`"}" | Out-Null
    Start-Sleep -Seconds 5
    $sp = az ad sp list --filter "appId eq '$WindowsCloudLoginAppId'" --query '[0].id' -o tsv
}
if (-not $sp) { throw 'Could not create or find the Windows Cloud Login service principal.' }
Write-Host "    service principal: $sp"

# --------------------------------------------------------------------------
Step 'Enabling Entra authentication for RDP'

az rest --method patch `
        --url "https://graph.microsoft.com/beta/servicePrincipals/$sp/remoteDesktopSecurityConfiguration" `
        --headers 'Content-Type=application/json' `
        --body '{"isRemoteDesktopProtocolEnabled":true}' | Out-Null
Write-Host '    enabled'

# --------------------------------------------------------------------------
Step "Registering '$DeviceGroupName' as a trusted target device group"

# Note: this needs the Entra DEVICE object id of the session host,
# not the Azure VM resource id. They are different things.
$deviceId = az ad device list --filter "displayName eq '$SessionHost'" --query '[0].id' -o tsv 2>$null
if (-not $deviceId) {
    throw "No Entra device found named '$SessionHost'. The Entra join may still be in progress. Wait a few minutes and re-run."
}
Write-Host "    device object: $deviceId"

$groupId = az ad group list --filter "displayName eq '$DeviceGroupName'" --query '[0].id' -o tsv 2>$null
if (-not $groupId) {
    Write-Host "    creating group '$DeviceGroupName'"
    $groupId = az ad group create --display-name $DeviceGroupName `
                                  --mail-nickname ($DeviceGroupName -replace '[^a-zA-Z0-9]','') `
                                  --query id -o tsv
    Start-Sleep -Seconds 5
}
Write-Host "    group: $groupId"

$members = az ad group member list --group $groupId --query '[].id' -o tsv 2>$null
if ($members -notcontains $deviceId) {
    az ad group member add --group $groupId --member-id $deviceId 2>$null | Out-Null
    Write-Host '    device added to group'
} else {
    Write-Host '    device already in group'
}

az rest --method post `
        --url "https://graph.microsoft.com/beta/servicePrincipals/$sp/remoteDesktopSecurityConfiguration/targetDeviceGroups" `
        --headers 'Content-Type=application/json' `
        --body "{`"id`":`"$groupId`",`"displayName`":`"$DeviceGroupName`"}" 2>$null | Out-Null
Write-Host '    registered as trusted'

# --------------------------------------------------------------------------
Step 'Enabling SSO on the host pool'

$rdp = 'enablerdsaadauth:i:1;targetisaadjoined:i:1;redirectclipboard:i:1;audiocapturemode:i:1;drivestoredirect:s:;'
az desktopvirtualization hostpool update -n $HostPoolName -g $ResourceGroup `
    --custom-rdp-property $rdp | Out-Null
Write-Host '    done'

# --------------------------------------------------------------------------
Write-Host "`nSSO configured." -ForegroundColor Green
Write-Host @"

Important, and the single most common false alarm:

  If a user hits AADSTS50076 at the host even though the workspace loaded, that is
  Conditional Access requiring MFA. With SSO the web client token is passed through
  to the host, and it only carries an MFA claim if the user actually completed MFA
  in that browser session. A cached sign-in will fail.

  The fix is for the user to sign in again and complete a real MFA prompt.
  It is not a host misconfiguration. Do not redeploy.

"@ -ForegroundColor DarkGray
