<#
.SYNOPSIS
    Per-user developer environment setup. Requires NO administrator rights.

.DESCRIPTION
    Run this once after your first sign-in to the Scout AVD desktop. It installs
    developer tooling entirely inside your own user profile, so it does not affect
    anyone else on the shared session host.

    You do not need to be a local administrator. Everything here uses installers
    that support per-user scope.

    What you already have without running anything:
      - node, npm and npx, from the machine-wide baseline
      - 'npm install -g <pkg>' installs to %APPDATA%\npm  (per-user, no admin)
      - 'npx <pkg>' caches to %LOCALAPPDATA%\npm-cache    (per-user, no admin)
      - VS Code extensions install to %USERPROFILE%\.vscode\extensions

    What this script adds:
      - fnm, to install and switch Node.js versions independently of other users
      - uv, to manage Python versions and virtual environments
      - %APPDATA%\npm on your user PATH, so globally installed npm binaries resolve

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File C:\ProgramData\ScoutAVD\Setup-MyDevEnv.ps1

.NOTES
    Safe to re-run. Sign out and back in afterwards so PATH changes take effect.
#>
[CmdletBinding()]
param(
    # Node.js version for fnm to install and set as your default. Empty skips it.
    [string] $NodeVersion = 'lts-latest',

    # Extra winget package IDs to install into your profile.
    # Portable and zip installers always work. MSI and wix ones will not.
    [string[]] $ExtraPackages = @()
)

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

function Say {
    param([string] $Message, [string] $Colour = 'Cyan')
    Write-Host "  $Message" -ForegroundColor $Colour
}

Write-Host ''
Write-Host 'Setting up your personal dev environment' -ForegroundColor White
Write-Host 'No administrator rights are required.' -ForegroundColor DarkGray
Write-Host ''

if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
    Write-Warning 'winget is not available in this session.'
    Write-Warning 'Open the Microsoft Store once to let App Installer register, then re-run.'
    return
}

# --------------------------------------------------------------------------
# Per-user packages. All of these are portable or user-scoped installers.
# --------------------------------------------------------------------------
$packages = @(
    @{ Id = 'Schniz.fnm';  Name = 'fnm (Node.js version manager)' }
    @{ Id = 'astral-sh.uv'; Name = 'uv (Python toolchain)' }
) + ($ExtraPackages | ForEach-Object { @{ Id = $_; Name = $_ } })

foreach ($p in $packages) {
    Say "Installing $($p.Name)..."
    $out = & winget install --id $p.Id --exact --scope user `
                 --silent --accept-package-agreements --accept-source-agreements `
                 --disable-interactivity 2>&1

    switch ($LASTEXITCODE) {
        0           { Say "  done" 'Green' }
        -1978335189 { Say "  already installed" 'DarkGray' }
        default {
            if ($out -match 'No applicable installer') {
                Say "  SKIPPED: $($p.Id) has no per-user installer and needs an administrator." 'Yellow'
                Say "  Ask your admin to add it to Install-Baseline.ps1." 'Yellow'
            } else {
                Say "  WARNING: exited $LASTEXITCODE" 'Yellow'
            }
        }
    }
}

# --------------------------------------------------------------------------
# Put %APPDATA%\npm on the user PATH.
#
# npm installs global packages there by default on Windows. It needs no admin,
# but a fresh profile does not have it on PATH, so 'npm i -g something' appears
# to succeed and then the command is not found.
# --------------------------------------------------------------------------
$npmBin = Join-Path $env:APPDATA 'npm'
New-Item -ItemType Directory -Force -Path $npmBin | Out-Null

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notlike "*$npmBin*") {
    Say "Adding $npmBin to your PATH..."
    $newPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $npmBin } else { "$userPath;$npmBin" }
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Say '  done' 'Green'
} else {
    Say 'npm global bin already on PATH' 'DarkGray'
}

# --------------------------------------------------------------------------
# Node version via fnm, if it landed on PATH this session.
# --------------------------------------------------------------------------
if ($NodeVersion) {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path', 'User')

    if (Get-Command fnm.exe -ErrorAction SilentlyContinue) {
        Say "Installing Node $NodeVersion via fnm..."
        & fnm install $NodeVersion 2>&1 | Out-Null
        & fnm default $NodeVersion 2>&1 | Out-Null
        Say '  done' 'Green'

        $profileDir = Split-Path $PROFILE -Parent
        New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
        $hook = 'fnm env --use-on-cd | Out-String | Invoke-Expression'
        if (-not (Test-Path $PROFILE) -or -not (Select-String -Path $PROFILE -Pattern 'fnm env' -Quiet)) {
            Add-Content -Path $PROFILE -Value "`n# Scout AVD: activate fnm`n$hook"
            Say '  added fnm hook to your PowerShell profile' 'Green'
        }
    } else {
        Say 'fnm not on PATH yet. Sign out and back in, then re-run to set a Node version.' 'Yellow'
    }
}

Write-Host ''
Write-Host 'Done. Sign out and back in so PATH changes take effect.' -ForegroundColor Green
Write-Host ''
Write-Host 'Quick reference:' -ForegroundColor White
Write-Host '  npm install -g <pkg>            install a global npm package  (no admin)' -ForegroundColor DarkGray
Write-Host '  npx <pkg>                       run a package without installing (no admin)' -ForegroundColor DarkGray
Write-Host '  fnm install 22 ; fnm use 22     switch your Node version' -ForegroundColor DarkGray
Write-Host '  uv python install 3.12          install Python into your profile' -ForegroundColor DarkGray
Write-Host '  winget install --id <Id> --scope user   anything else that supports it' -ForegroundColor DarkGray
Write-Host ''
