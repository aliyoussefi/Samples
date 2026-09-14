<#
.SYNOPSIS
    Deploy a multi-user Microsoft Scout (Frontier) environment on Azure Virtual Desktop.

.DESCRIPTION
    Creates the AVD control plane, a Windows 11 multi-session host, registers it with
    the host pool, grants access to an Entra group, and installs a machine-wide
    developer baseline so every user has Node.js, Git and VS Code without needing
    administrator rights.

    Users connect through the AVD web client over 443. No Bastion and no public IP.

    Run scripts/Enable-EntraSso.ps1 afterwards. That step needs directory rights.

.EXAMPLE
    .\deploy.ps1 -SubscriptionId "<guid>" -ResourceGroup "rg-avd-scout" `
                 -Location "eastus" -SubnetId "/subscriptions/.../subnets/default" `
                 -AccessGroupId "<entra-group-object-id>" `
                 -AdminPassword (Read-Host -AsSecureString "Local admin password")

.NOTES
    Idempotent. Re-running skips resources that already exist.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [string] $SubscriptionId,
    [Parameter(Mandatory)] [string] $ResourceGroup,
    [Parameter(Mandatory)] [string] $Location,

    # Existing subnet WITH outbound internet, normally via NAT Gateway.
    [Parameter(Mandatory)] [string] $SubnetId,

    # Entra security group whose members get access.
    [Parameter(Mandatory)] [string] $AccessGroupId,

    [Parameter(Mandatory)] [securestring] $AdminPassword,

    [string] $HostPoolName   = 'hp-scout-avd',
    [string] $WorkspaceName  = 'ws-scout-avd',
    [string] $AppGroupName   = 'dag-scout-avd',
    [string] $SessionHost    = 'avdscout01',
    [string] $AdminUsername  = 'azureuser',

    # 8 vCPU / 64 GB. v5 families are often capacity constrained, this one is reliable.
    [string] $VmSize         = 'Standard_DC8s_v3',
    [int]    $MaxSessions    = 5,
    [int]    $OsDiskSizeGb   = 256,

    # Local time for nightly auto-shutdown. Pairs with start-VM-on-connect.
    [string] $AutoShutdownTime     = '1900',
    [string] $AutoShutdownTimeZone = 'Central Standard Time',

    [switch] $SkipBaseline
)

$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Step { param([string] $m) Write-Host "`n==> $m" -ForegroundColor Cyan }
function Info { param([string] $m) Write-Host "    $m" -ForegroundColor DarkGray }

# Read a value from az, returning $null instead of noisy stderr when the resource
# does not exist yet. Under -WhatIf the parent resources are never created, so
# these lookups legitimately miss and must not look like failures.
function Get-AzValue {
    param([Parameter(Mandatory)] [scriptblock] $Command)
    try {
        $prev = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $out = & $Command 2>$null
        $ErrorActionPreference = $prev
        if ($LASTEXITCODE -ne 0) { return $null }
        if ([string]::IsNullOrWhiteSpace($out)) { return $null }
        return ($out | Select-Object -First 1).Trim()
    } catch { return $null }
}

# --------------------------------------------------------------------------
Step 'Checking prerequisites'

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw 'Azure CLI not found. Install it from https://aka.ms/installazurecli'
}

# The az context can silently revert between calls, so set it explicitly.
az account set --subscription $SubscriptionId
$acct = az account show --query 'name' -o tsv
Info "subscription: $acct"

if (-not (az extension show -n desktopvirtualization 2>$null)) {
    Info 'installing desktopvirtualization extension'
    az extension add -n desktopvirtualization --only-show-errors | Out-Null
}
az provider register -n Microsoft.DesktopVirtualization --wait | Out-Null

if ((Get-AzValue { az group exists -n $ResourceGroup }) -eq 'true') {
    Info "resource group $ResourceGroup already exists"
} elseif ($PSCmdlet.ShouldProcess($ResourceGroup, 'Create resource group')) {
    az group create -n $ResourceGroup -l $Location --only-show-errors | Out-Null
}

# --------------------------------------------------------------------------
Step 'Creating the AVD control plane'

if (-not (az desktopvirtualization hostpool show -n $HostPoolName -g $ResourceGroup 2>$null)) {
    if ($PSCmdlet.ShouldProcess($HostPoolName, 'Create host pool')) {
        az desktopvirtualization hostpool create -n $HostPoolName -g $ResourceGroup -l $Location `
            --host-pool-type Pooled --load-balancer-type BreadthFirst `
            --max-session-limit $MaxSessions --preferred-app-group-type Desktop `
            --start-vm-on-connect true --only-show-errors | Out-Null
        Info "host pool $HostPoolName created"
    }
} else { Info "host pool $HostPoolName already exists" }

$hpId = Get-AzValue { az desktopvirtualization hostpool show -n $HostPoolName -g $ResourceGroup --query id -o tsv }

if (-not (az desktopvirtualization applicationgroup show -n $AppGroupName -g $ResourceGroup 2>$null)) {
    if ($PSCmdlet.ShouldProcess($AppGroupName, 'Create application group')) {
        az desktopvirtualization applicationgroup create -n $AppGroupName -g $ResourceGroup -l $Location `
            --host-pool-arm-path $hpId --application-group-type Desktop --only-show-errors | Out-Null
        Info "app group $AppGroupName created"
    }
} else { Info "app group $AppGroupName already exists" }

$agId = Get-AzValue { az desktopvirtualization applicationgroup show -n $AppGroupName -g $ResourceGroup --query id -o tsv }

if (-not (az desktopvirtualization workspace show -n $WorkspaceName -g $ResourceGroup 2>$null)) {
    if ($PSCmdlet.ShouldProcess($WorkspaceName, 'Create workspace')) {
        az desktopvirtualization workspace create -n $WorkspaceName -g $ResourceGroup -l $Location `
            --application-group-references $agId --only-show-errors | Out-Null
        Info "workspace $WorkspaceName created"
    }
} else { Info "workspace $WorkspaceName already exists" }

# --------------------------------------------------------------------------
Step 'Granting access to the Entra group'

# BOTH roles are required. With only one, the desktop either does not appear in
# the feed or appears and then refuses the connection.
$rgId = Get-AzValue { az group show -n $ResourceGroup --query id -o tsv }

if ($PSCmdlet.ShouldProcess($AccessGroupId, 'Assign AVD roles')) {
    if (-not $agId -or -not $rgId) {
        throw 'Could not resolve the application group or resource group id. Refusing to assign roles at an unknown scope.'
    }
    az role assignment create --assignee-object-id $AccessGroupId --assignee-principal-type Group `
        --role 'Desktop Virtualization User' --scope $agId --only-show-errors 2>$null | Out-Null
    az role assignment create --assignee-object-id $AccessGroupId --assignee-principal-type Group `
        --role 'Virtual Machine User Login' --scope $rgId --only-show-errors 2>$null | Out-Null
    Info 'Desktop Virtualization User + Virtual Machine User Login assigned'
}

# --------------------------------------------------------------------------
Step 'Creating the session host'

if (-not (az vm show -g $ResourceGroup -n $SessionHost 2>$null)) {
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                 [Runtime.InteropServices.Marshal]::SecureStringToBSTR($AdminPassword))

    if ($PSCmdlet.ShouldProcess($SessionHost, "Create VM ($VmSize)")) {
        # win11-*-avd is the MULTI-SESSION image. The plain 'pro' image will not
        # multiplex users and silently gives you a one-person host.
        az vm create -g $ResourceGroup -n $SessionHost `
            --image 'MicrosoftWindowsDesktop:windows-11:win11-24h2-avd:latest' `
            --size $VmSize --admin-username $AdminUsername --admin-password $plain `
            --subnet $SubnetId --public-ip-address '""' --nsg '""' `
            --security-type TrustedLaunch --enable-secure-boot true --enable-vtpm true `
            --license-type Windows_Client --assign-identity `
            --os-disk-size-gb $OsDiskSizeGb `
            --os-disk-delete-option Delete --nic-delete-option Delete `
            --only-show-errors | Out-Null
        Info "$SessionHost created"
    }
    $plain = $null
} else { Info "$SessionHost already exists" }

# Entra join. Install PLAIN, with no mdmId. Passing mdmId fails with "no MDM URLs"
# and rolls back unless the tenant's Intune auto-enrollment scope is configured.
if ($PSCmdlet.ShouldProcess($SessionHost, 'Entra join')) {
    az vm extension set -g $ResourceGroup --vm-name $SessionHost -n AADLoginForWindows `
        --publisher Microsoft.Azure.ActiveDirectory --only-show-errors 2>$null | Out-Null
    Info 'AADLoginForWindows installed'
}

# --------------------------------------------------------------------------
Step 'Registering the session host with the host pool'

if ($PSCmdlet.ShouldProcess($HostPoolName, 'Rotate registration token')) {
    $exp = (Get-Date).ToUniversalTime().AddHours(8).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ')
    az desktopvirtualization hostpool update -n $HostPoolName -g $ResourceGroup `
        --registration-info expiration-time=$exp registration-token-operation=Update `
        --only-show-errors | Out-Null

    $token = az desktopvirtualization hostpool retrieve-registration-token `
                 -n $HostPoolName -g $ResourceGroup --query token -o tsv
} else {
    $token = '<registration-token>'
}

if ($PSCmdlet.ShouldProcess($SessionHost, 'Install AVD agent')) {
    # msiexec arguments MUST be passed as an array. The single-string form
    # silently no-ops and the host never registers.
    $agentScript = @"
`$ErrorActionPreference = 'Stop'
`$tmp = 'C:\Windows\Temp\avdagent'
New-Item -ItemType Directory -Force -Path `$tmp | Out-Null

`$agent = Join-Path `$tmp 'RDAgent.msi'
`$boot  = Join-Path `$tmp 'BootLoader.msi'
Invoke-WebRequest 'https://go.microsoft.com/fwlink/?linkid=2310011' -OutFile `$agent -UseBasicParsing
Invoke-WebRequest 'https://go.microsoft.com/fwlink/?linkid=2311028' -OutFile `$boot  -UseBasicParsing

Start-Process msiexec -Wait -ArgumentList @('/i',`$agent,'/qn','/norestart','/l*v','C:\Windows\Temp\rdagent.log',"REGISTRATIONTOKEN=$token")
Start-Process msiexec -Wait -ArgumentList @('/i',`$boot,'/qn','/norestart','/l*v','C:\Windows\Temp\bootloader.log')

Start-Sleep -Seconds 10
`$reg = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\RDInfraAgent' -ErrorAction SilentlyContinue
"IsRegistered=`$(`$reg.IsRegistered) BootLoader=`$((Get-Service RDAgentBootLoader -ErrorAction SilentlyContinue).Status)"
"@
    $f = New-TemporaryFile
    Set-Content -Path $f -Value $agentScript -Encoding UTF8
    az vm run-command invoke -g $ResourceGroup -n $SessionHost `
        --command-id RunPowerShellScript --scripts "@$f" `
        --query 'value[0].message' -o tsv
    Remove-Item $f -Force
}

# --------------------------------------------------------------------------
if (-not $SkipBaseline) {
    Step 'Installing the machine-wide developer baseline'

    $baseline = Join-Path $scriptRoot 'scripts\Install-Baseline.ps1'
    $userEnv  = Join-Path $scriptRoot 'scripts\Setup-MyDevEnv.ps1'

    if ($PSCmdlet.ShouldProcess($SessionHost, 'Stage per-user helper')) {
        # Stage Setup-MyDevEnv.ps1 first so Install-Baseline can create its shortcut.
        $stage = @"
New-Item -ItemType Directory -Force -Path 'C:\ProgramData\ScoutAVD' | Out-Null
@'
$(Get-Content $userEnv -Raw)
'@ | Set-Content -Path 'C:\ProgramData\ScoutAVD\Setup-MyDevEnv.ps1' -Encoding UTF8
'staged'
"@
        $f = New-TemporaryFile
        Set-Content -Path $f -Value $stage -Encoding UTF8
        az vm run-command invoke -g $ResourceGroup -n $SessionHost `
            --command-id RunPowerShellScript --scripts "@$f" --query 'value[0].message' -o tsv | Out-Null
        Remove-Item $f -Force
        Info 'per-user helper staged to C:\ProgramData\ScoutAVD'
    }

    if ($PSCmdlet.ShouldProcess($SessionHost, 'Run baseline install')) {
        Info 'this takes several minutes'
        az vm run-command invoke -g $ResourceGroup -n $SessionHost `
            --command-id RunPowerShellScript --scripts "@$baseline" `
            --query 'value[0].message' -o tsv
    }
}

# --------------------------------------------------------------------------
Step 'Configuring auto-shutdown'

if ($PSCmdlet.ShouldProcess($SessionHost, 'Auto-shutdown')) {
    az vm auto-shutdown -g $ResourceGroup -n $SessionHost --time $AutoShutdownTime --only-show-errors | Out-Null
    az resource update -g $ResourceGroup -n "shutdown-computevm-$SessionHost" `
        --resource-type 'Microsoft.DevTestLab/schedules' `
        --set properties.timeZoneId="$AutoShutdownTimeZone" `
              properties.dailyRecurrence.time="$AutoShutdownTime" `
        --only-show-errors | Out-Null
    Info "shuts down at $AutoShutdownTime $AutoShutdownTimeZone, wakes on connect"
}

# --------------------------------------------------------------------------
Step 'Verifying'

if ($hpId) {
    az rest --method get --url "https://management.azure.com$hpId/sessionHosts?api-version=2023-09-05" `
        --query 'value[].{host:name,status:properties.status}' -o table
} else {
    Info 'host pool does not exist yet, nothing to verify'
}

Write-Host @"

Next steps

  1. Enable Entra SSO. Required, or the web client shows a credential prompt:

       .\scripts\Enable-EntraSso.ps1 -ResourceGroup "$ResourceGroup" ``
                                     -HostPoolName "$HostPoolName" ``
                                     -SessionHost "$SessionHost"

  2. Complete Gate 1 if you have not. See ../docs/enable-frontier.md
     It is manual and propagates for up to 3 hours.

  3. Add users to the access group:

       az ad group member add --group <name> --member-id <user-object-id>

     Each user also needs a GitHub Copilot license and MFA registered.

  4. Tell users to connect at https://client.wvd.microsoft.com/arm/webclient/
     and to run 'Set up my dev environment' from the Start Menu on first sign-in.

"@ -ForegroundColor White
