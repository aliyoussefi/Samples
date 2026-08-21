<#
.SYNOPSIS
  Deploys a Windows 11 VM with Azure Bastion + NAT Gateway + Entra login,
  pre-configured for Microsoft Scout (Frontier) demos.

.DESCRIPTION
  Wraps the win11-frontier-scout.bicep template with the operational steps
  that can't live in the template itself:
    * ensures the correct subscription is active
    * registers the public-IP feature (needed for Bastion on some subs,
      e.g. M365 developer subscriptions where public IPs are gated)
    * creates the resource group
    * runs a what-if preview (unless -SkipWhatIf)
    * deploys the template
    * prints how to connect

  This handles the automatable pieces only. You STILL must complete the two
  Microsoft Scout Frontier admin gates by hand - see README.md.

.EXAMPLE
  .\deploy.ps1 -SubscriptionId "<sub-guid>" -EntraLoginUpn "admin@contoso.onmicrosoft.com"

.NOTES
  Requires: Azure CLI (az). Bicep is auto-installed by az on first use.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $SubscriptionId,
  [string] $ResourceGroup = 'rg-win11-scout',
  [string] $Location      = 'eastus',
  [string] $VmName        = 'win11-vm01',
  [string] $VmSize        = 'Standard_DC2s_v3',
  [string] $AdminUsername = 'azureuser',
  # Entra user to grant VM login (UPN). Optional - leave empty to skip.
  [string] $EntraLoginUpn = '',
  [ValidateSet('Administrator','User')] [string] $EntraLoginRole = 'Administrator',
  [switch] $SkipWhatIf
)

$ErrorActionPreference = 'Stop'
$templateFile = Join-Path $PSScriptRoot 'win11-frontier-scout.bicep'

Write-Host "==> Setting subscription $SubscriptionId" -ForegroundColor Cyan
az account set --subscription $SubscriptionId | Out-Null
$acct = az account show --query "{name:name, id:id}" -o json | ConvertFrom-Json
Write-Host "    Active: $($acct.name) ($($acct.id))"

Write-Host "==> Ensuring the public-IP feature is registered (Bastion/NAT need public IPs)" -ForegroundColor Cyan
$feat = az feature show --namespace Microsoft.Network --name AllowBringYourOwnPublicIpAddress --query "properties.state" -o tsv 2>$null
if ($feat -ne 'Registered') {
  Write-Host "    Registering AllowBringYourOwnPublicIpAddress (one-time; can take a few minutes)..."
  az feature register --namespace Microsoft.Network --name AllowBringYourOwnPublicIpAddress | Out-Null
  az provider register -n Microsoft.Network | Out-Null
  do {
    Start-Sleep -Seconds 20
    $feat = az feature show --namespace Microsoft.Network --name AllowBringYourOwnPublicIpAddress --query "properties.state" -o tsv
    Write-Host "    Feature state: $feat"
  } while ($feat -ne 'Registered')
} else {
  Write-Host "    Already registered."
}

Write-Host "==> Creating resource group $ResourceGroup in $Location" -ForegroundColor Cyan
az group create --name $ResourceGroup --location $Location -o none

# Resolve the Entra user object id (if provided)
$entraPrincipalId = ''
if (-not [string]::IsNullOrWhiteSpace($EntraLoginUpn)) {
  Write-Host "==> Resolving Entra user $EntraLoginUpn" -ForegroundColor Cyan
  $entraPrincipalId = az ad user show --id $EntraLoginUpn --query id -o tsv
  Write-Host "    Object ID: $entraPrincipalId"
}

# Prompt for the VM admin password (kept out of history)
$sec = Read-Host -AsSecureString "Enter a strong local admin password for the VM (min 12 chars, 3 of 4 complexity classes)"
$plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
  [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))

$params = @(
  "vmName=$VmName",
  "location=$Location",
  "adminUsername=$AdminUsername",
  "adminPassword=$plain",
  "vmSize=$VmSize",
  "entraLoginRole=$EntraLoginRole"
)
if ($entraPrincipalId) { $params += "entraLoginPrincipalId=$entraPrincipalId" }

if (-not $SkipWhatIf) {
  Write-Host "==> what-if preview" -ForegroundColor Cyan
  az deployment group what-if --resource-group $ResourceGroup --template-file $templateFile --parameters $params
  $go = Read-Host "Proceed with deployment? (y/N)"
  if ($go -ne 'y') { Write-Host "Aborted."; return }
}

Write-Host "==> Deploying (this can take ~10-15 min, mostly Bastion)" -ForegroundColor Cyan
$out = az deployment group create --resource-group $ResourceGroup --name win11-scout --template-file $templateFile --parameters $params --query "properties.outputs" -o json | ConvertFrom-Json

Write-Host ""
Write-Host "==================== DEPLOYMENT COMPLETE ====================" -ForegroundColor Green
Write-Host "VM:            $($out.vmName.value)"
Write-Host "Private IP:    $($out.privateIP.value)"
Write-Host "Outbound IP:   $($out.natGatewayOutboundIP.value)"
Write-Host "Connect:       $($out.connectHint.value)"
Write-Host ""
Write-Host "NEXT (manual, tenant admin - see README.md):" -ForegroundColor Yellow
Write-Host "  Gate 1: Turn on Copilot Frontier in the M365 admin center + submit the attestation form."
Write-Host "  Gate 2: Device policy AllowScoutFrontierAccess=1 is already set by the template."
Write-Host "  Then sign in to the VM with your Entra account and launch Microsoft Scout."
