#requires -Version 5.1
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$root = Join-Path ([IO.Path]::GetTempPath()) ('scout-agent-kit-test-' + [Guid]::NewGuid().ToString('N'))
$testHome = Join-Path $root 'home'
$artifacts = Join-Path $root 'artifacts'
$installer = Join-Path $PSScriptRoot 'Install-AgentTeam.ps1'
function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}
try {
    New-Item -ItemType Directory -Path $artifacts -Force | Out-Null
    $params = @{
        OwnerName = 'Example User'
        OwnerEmail = 'user@example.com'
        InternalDomain = 'example.com'
        ArtifactRoot = $artifacts
        ScoutHome = $testHome
        TimeZone = 'America/Chicago'
    }
    & $installer @params -WhatIf
    Assert-True (-not (Test-Path -LiteralPath $testHome)) 'WhatIf wrote files.'
    & $installer @params
    $skills = @(Get-ChildItem (Join-Path $testHome 'm-skills') -Recurse -Filter 'SKILL.md')
    $imports = @(Get-ChildItem (Join-Path $testHome 'agent-team\imports') -Filter '*.json')
    Assert-True ($skills.Count -eq 6) 'Expected six generated skills.'
    Assert-True ($imports.Count -eq 6) 'Expected six import definitions.'
    foreach ($file in $skills) {
        $content = Get-Content -LiteralPath $file.FullName -Raw
        Assert-True ($content.StartsWith("---`nname: ")) 'Missing skill front matter.'
        Assert-True ($content -notmatch '\{\{[^}]+\}\}') 'Unresolved placeholder.'
    }
    foreach ($file in $imports) {
        $a = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json
        Assert-True ($a.enabled -eq $false) 'Automation unexpectedly enabled.'
        Assert-True ($a.teamsNotify -eq 'never') 'Unexpected outbound notification policy.'
        Assert-True ($a.triggerType -eq 'schedule' -and $a.oneShot -eq $false) 'Invalid trigger.'
        Assert-True ($a.PSObject.Properties.Name -notcontains 'skill') 'Non-tool field leaked into import payload.'
        Assert-True ($a.prompt -match '/([a-z0-9-]+)') 'Missing skill binding.'
        Assert-True (Test-Path (Join-Path $testHome "m-skills\$($Matches[1])\SKILL.md")) 'Import references missing skill.'
    }
    $hashes = @{}
    foreach ($file in @($skills) + @($imports)) {
        $hashes[$file.FullName] = (Get-FileHash -LiteralPath $file.FullName).Hash
    }
    & $installer @params
    foreach ($file in @($skills) + @($imports)) {
        Assert-True ((Get-FileHash -LiteralPath $file.FullName).Hash -eq $hashes[$file.FullName]) 'Idempotent run altered content.'
    }
    $params.OwnerName = 'Different User'
    $failed = $false
    try { & $installer @params } catch {
        if ($_.Exception.Message -notlike 'Existing file differs:*') { throw }
        $failed = $true
    }
    Assert-True $failed 'Conflicting installation should fail.'
    foreach ($file in @($skills) + @($imports)) {
        Assert-True ((Get-FileHash -LiteralPath $file.FullName).Hash -eq $hashes[$file.FullName]) 'Conflict modified existing content.'
    }
    $params.ScoutHome = Join-Path $root 'invalid-home'
    $params.DemoUrl = 'https://example.com/?token=not-a-real-token'
    $failed = $false
    try { & $installer @params } catch {
        if ($_.Exception.Message -notlike 'DemoUrl must be*') { throw }
        $failed = $true
    }
    Assert-True $failed 'Token-bearing URLs must fail.'
    Assert-True (-not (Test-Path $params.ScoutHome)) 'Invalid configuration wrote files.'
    Write-Output 'PASS: WhatIf, six skills, six safe imports, bindings, rendering, idempotence, conflict protection and URL validation.'
} finally {
    if (Test-Path -LiteralPath $root) { Remove-Item -LiteralPath $root -Recurse -Force }
}
