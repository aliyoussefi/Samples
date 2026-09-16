#requires -Version 5.1
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$OwnerName,
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')]
    [string]$OwnerEmail,
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9.-]*\.[a-zA-Z]{2,}$')]
    [string]$InternalDomain,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ArtifactRoot,
    [ValidateNotNullOrEmpty()]
    [string]$TimeZone = 'America/Chicago',
    [string]$DemoUrl,
    [string]$ScoutHome = (Join-Path $env:USERPROFILE '.scout')
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Write-Utf8File {
    param([string]$Path, [string]$Content)
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

foreach ($value in @($OwnerName, $OwnerEmail, $InternalDomain, $ArtifactRoot, $TimeZone, $DemoUrl)) {
    if ($value -match '[\r\n]' -or $value -match '\{\{|\}\}') {
        throw 'Configuration values must be single-line text without template delimiters.'
    }
}
if (-not [IO.Path]::IsPathRooted($ScoutHome) -or -not [IO.Path]::IsPathRooted($ArtifactRoot)) {
    throw 'ScoutHome and ArtifactRoot must be absolute paths.'
}
if (-not (Test-Path -LiteralPath $ArtifactRoot -PathType Container)) {
    throw 'ArtifactRoot must be an existing directory accessible by this Windows user.'
}
if ((Get-Item -LiteralPath $ArtifactRoot).Attributes -band [IO.FileAttributes]::ReparsePoint) {
    throw 'Choose a real artifact directory, not a symlink or junction.'
}
if ($TimeZone -notmatch '^[A-Za-z_]+/[A-Za-z_]+(?:/[A-Za-z_]+)?$') {
    throw 'Use an IANA timezone such as America/Chicago. Confirm the same timezone in Scout settings.'
}
if ($DemoUrl) {
    $uri = $null
    if (-not [Uri]::TryCreate($DemoUrl, [UriKind]::Absolute, [ref]$uri) -or
        $uri.Scheme -ne 'https' -or $uri.UserInfo -or $uri.Query -or $uri.Fragment) {
        throw 'DemoUrl must be an HTTPS URL without credentials, query strings, or fragments.'
    }
} else {
    $DemoUrl = 'NOT_CONFIGURED'
}

$skillSource = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'skills.json') -Raw | ConvertFrom-Json
$automationSource = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'automations.json') -Raw | ConvertFrom-Json
if ($skillSource.schemaVersion -ne 1 -or $automationSource.schemaVersion -ne 1) {
    throw 'Unsupported package schema version.'
}
$skillsRoot = Join-Path $ScoutHome 'm-skills'
$kitRoot = Join-Path $ScoutHome 'agent-team'
$stateRoot = Join-Path $kitRoot 'state'
$importRoot = Join-Path $kitRoot 'imports'
$skillNames = @($skillSource.skills | ForEach-Object { $_.name })
if (($skillNames | Select-Object -Unique).Count -ne $skillNames.Count) {
    throw 'Duplicate skill names in package.'
}
$tokens = @{
    '{{OWNER_NAME}}' = $OwnerName
    '{{OWNER_EMAIL}}' = $OwnerEmail
    '{{INTERNAL_DOMAIN}}' = $InternalDomain
    '{{ARTIFACT_ROOT}}' = [IO.Path]::GetFullPath($ArtifactRoot)
    '{{TIME_ZONE}}' = $TimeZone
    '{{DEMO_URL}}' = $DemoUrl
    '{{STATE_ROOT}}' = [IO.Path]::GetFullPath($stateRoot)
}
$writes = @()
foreach ($skill in $skillSource.skills) {
    if ($skill.name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw 'Invalid skill name.' }
    $instructions = $skill.instructions -join "`n`n"
    foreach ($entry in $tokens.GetEnumerator()) {
        $instructions = $instructions.Replace($entry.Key, [string]$entry.Value)
    }
    if ($instructions -match '\{\{[^}]+\}\}') { throw "Unresolved placeholder in $($skill.name)." }
    $nameYaml = ConvertTo-Json -InputObject $skill.name -Compress
    $descriptionYaml = ConvertTo-Json -InputObject $skill.description -Compress
    $content = "---`nname: $nameYaml`ndescription: $descriptionYaml`n---`n`n$instructions`n"
    $writes += [pscustomobject]@{
        Path = Join-Path (Join-Path $skillsRoot $skill.name) 'SKILL.md'
        Content = $content
    }
}
$index = 0
foreach ($automation in $automationSource.automations) {
    if ($skillNames -notcontains $automation.skill) { throw "Missing skill $($automation.skill)." }
    $index++
    $payload = [ordered]@{
        name = $automation.name
        description = $automation.description
        prompt = "Load and follow /$($automation.skill) for this run. If the skill is missing, stop and report setup required. Follow all host permissions and approval requirements."
        schedule = $automation.schedule
        enabled = $false
        oneShot = $false
        triggerType = 'schedule'
        teamsNotify = 'never'
    }
    $writes += [pscustomobject]@{
        Path = Join-Path $importRoot ('{0:D2}-{1}.automation.json' -f $index, $automation.skill)
        Content = ($payload | ConvertTo-Json -Depth 10) + "`n"
    }
}

# Preflight every destination before writing so existing customizations are never overwritten.
foreach ($write in $writes) {
    if (Test-Path -LiteralPath $write.Path) {
        if ((Get-Content -LiteralPath $write.Path -Raw) -cne $write.Content) {
            throw "Existing file differs: $($write.Path). No files have been changed. Back it up and resolve the conflict before installing."
        }
    }
}
if ($PSCmdlet.ShouldProcess($ScoutHome, 'Install six per-user skills and six disabled automation import definitions')) {
    New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
    foreach ($write in $writes) {
        if (-not (Test-Path -LiteralPath $write.Path)) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $write.Path) -Force | Out-Null
            Write-Utf8File -Path $write.Path -Content $write.Content
        }
    }
    Write-Output "Installed six skills under $skillsRoot"
    Write-Output "Prepared six DISABLED automation definitions under $importRoot"
    Write-Output 'No schedules were registered or enabled. No credentials, account sessions or MCP settings were copied.'
    Write-Output "Reload Scout skills, then follow SETUP.txt. Confirm Scout timezone is $TimeZone before enabling anything."
}
