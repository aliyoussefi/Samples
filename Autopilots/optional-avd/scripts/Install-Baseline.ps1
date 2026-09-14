<#
.SYNOPSIS
    Machine-wide developer baseline for a Microsoft Scout (Frontier) AVD session host.

.DESCRIPTION
    Runs ONCE, as SYSTEM, at deploy time. Installs the tools that cannot be installed
    per-user, sets the Frontier device policy with a self-heal task, and stages the
    per-user helper plus an all-users Start Menu shortcut.

    Everything installed here is shared by every user on the host. Anything a user can
    install into their own profile belongs in Setup-MyDevEnv.ps1 instead, so that one
    user's tooling choices do not affect everyone else.

.NOTES
    Invoked by deploy.ps1 via 'az vm run-command'. Safe to re-run.
#>
[CmdletBinding()]
param(
    # Machine-wide packages. These are MSI/wix/inno installers that cannot go per-user.
    [string[]] $Packages = @(
        'OpenJS.NodeJS.LTS',              # wix MSI, machine only. Gives every user npm and npx.
        'Git.Git',                        # inno, machine only
        'Microsoft.PowerShell',           # MSI
        'Microsoft.VisualStudioCode'      # installed --scope machine, one shared copy
    ),

    [switch] $SkipFrontierPolicy
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$stateDir = 'C:\ProgramData\ScoutAVD'
$log      = Join-Path $stateDir 'install-baseline.log'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

function Write-Log {
    param([string] $Message)
    $line = "[{0:yyyy-MM-dd HH:mm:ss}] {1}" -f (Get-Date), $Message
    Write-Output $line
    Add-Content -Path $log -Value $line
}

Write-Log "=== Baseline start ==="

# --------------------------------------------------------------------------
# winget. On a fresh multi-session image App Installer may not be registered
# for the SYSTEM context yet, so resolve the binary by path rather than PATH.
# --------------------------------------------------------------------------
function Get-WingetPath {
    $cmd = Get-Command winget.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }

    $candidate = Get-ChildItem 'C:\Program Files\WindowsApps' -Filter 'winget.exe' -Recurse -ErrorAction SilentlyContinue |
                 Where-Object FullName -like '*Microsoft.DesktopAppInstaller*' |
                 Sort-Object FullName -Descending |
                 Select-Object -First 1
    if ($candidate) { return $candidate.FullName }
    return $null
}

$winget = Get-WingetPath
if (-not $winget) {
    Write-Log 'winget not found. Registering App Installer for all users.'
    try {
        Add-AppxProvisionedPackage -Online -SkipLicense `
            -PackagePath (Get-ChildItem 'C:\Program Files\WindowsApps' -Filter '*DesktopAppInstaller*.appx' -Recurse -ErrorAction SilentlyContinue |
                          Select-Object -First 1 -ExpandProperty FullName) -ErrorAction Stop | Out-Null
    } catch {
        Write-Log "Could not provision App Installer: $($_.Exception.Message)"
    }
    $winget = Get-WingetPath
}

if ($winget) {
    Write-Log "winget: $winget"
    & $winget source update --disable-interactivity 2>&1 | Out-Null
} else {
    Write-Log 'WARNING: winget unavailable. Falling back to direct downloads where possible.'
}

# --------------------------------------------------------------------------
# Machine-wide packages
# --------------------------------------------------------------------------
foreach ($pkg in $Packages) {
    Write-Log "Installing $pkg (machine scope)"
    if (-not $winget) { Write-Log "  skipped, no winget"; continue }

    $args = @(
        'install', '--id', $pkg, '--exact',
        '--scope', 'machine',
        '--silent',
        '--accept-package-agreements',
        '--accept-source-agreements',
        '--disable-interactivity'
    )
    & $winget @args 2>&1 | ForEach-Object { Write-Log "  $_" }

    # 0 = installed, -1978335189 = already installed / no upgrade needed
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        Write-Log "  WARNING: $pkg exited $LASTEXITCODE"
    }
}

# --------------------------------------------------------------------------
# Make npm's per-user global prefix work for everyone.
#
# npm already defaults to %APPDATA%\npm on Windows, which is per-user and needs
# no admin. The directory is created on first use, but it is NOT on PATH for a
# brand new profile. Adding it to the machine PATH makes globally installed npm
# binaries resolve for every user, while the packages themselves still install
# into each user's own profile.
# --------------------------------------------------------------------------
$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$npmUserBin  = '%APPDATA%\npm'
if ($machinePath -notlike "*$npmUserBin*") {
    Write-Log "Adding $npmUserBin to machine PATH"
    [Environment]::SetEnvironmentVariable('Path', "$machinePath;$npmUserBin", 'Machine')
}

# --------------------------------------------------------------------------
# Gate 2: Frontier device policy, with a startup task that re-asserts it.
# Survives reboots. Only a reimage loses it.
# --------------------------------------------------------------------------
if (-not $SkipFrontierPolicy) {
    Write-Log 'Setting Frontier device policy'

    $policyKey = 'HKLM:\SOFTWARE\Policies\Scout'
    New-Item -Path $policyKey -Force | Out-Null
    New-ItemProperty -Path $policyKey -Name 'AllowScoutFrontierAccess' `
                     -Value '1' -PropertyType String -Force | Out-Null

    $ensure = Join-Path $stateDir 'ensure-policy.ps1'
    @'
$key = "HKLM:\SOFTWARE\Policies\Scout"
New-Item -Path $key -Force | Out-Null
New-ItemProperty -Path $key -Name "AllowScoutFrontierAccess" -Value "1" -PropertyType String -Force | Out-Null
'@ | Set-Content -Path $ensure -Encoding UTF8

    $taskName = 'EnsureScoutFrontierPolicy'
    if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
        $action    = New-ScheduledTaskAction -Execute 'powershell.exe' `
                        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ensure`""
        $trigger   = New-ScheduledTaskTrigger -AtStartup
        $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
        Register-ScheduledTask -TaskName $taskName -Action $action `
                               -Trigger $trigger -Principal $principal | Out-Null
        Write-Log "  registered task $taskName"
    }
}

# --------------------------------------------------------------------------
# Stage the per-user helper and surface it in the all-users Start Menu.
# --------------------------------------------------------------------------
$userScript = Join-Path $stateDir 'Setup-MyDevEnv.ps1'
if (Test-Path $userScript) {
    $startMenu = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs'
    $lnk       = Join-Path $startMenu 'Set up my dev environment.lnk'

    $shell = New-Object -ComObject WScript.Shell
    $s = $shell.CreateShortcut($lnk)
    $s.TargetPath       = 'powershell.exe'
    $s.Arguments        = "-NoProfile -ExecutionPolicy Bypass -File `"$userScript`""
    $s.IconLocation     = 'powershell.exe,0'
    $s.Description      = 'Install Node version manager, Python tooling, and per-user PATH. No admin needed.'
    $s.WorkingDirectory = $stateDir
    $s.Save()
    Write-Log "  Start Menu shortcut created"
} else {
    Write-Log "  NOTE: $userScript not staged yet, shortcut skipped"
}

Write-Log '=== Baseline complete ==='
Write-Log "node: $((& node --version 2>&1) -join '')"
Write-Log "npm:  $((& npm --version 2>&1) -join '')"
Write-Log "git:  $((& git --version 2>&1) -join '')"
