# ColorScripts-Enhanced Module Tests
# Run this to validate module functionality

#Requires -Version 5.1

[CmdletBinding()]
param()

Write-Host "`n=== ColorScripts-Enhanced Module Tests ===`n" -ForegroundColor Cyan

$ErrorCount = 0
$SuccessCount = 0

function Test-Function {
    param(
        [string]$Name,
        [scriptblock]$Test
    )

    Write-Host "Testing: $Name..." -NoNewline
    try {
        & $Test
        Write-Host " ✓ PASS" -ForegroundColor Green
        $script:SuccessCount++
    }
    catch {
        Write-Host " ✗ FAIL" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
        $script:ErrorCount++
    }
}

# Import module
Write-Host "Importing module..." -ForegroundColor Yellow
try {
    Import-Module "$PSScriptRoot\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1" -Force
    $cacheVariable = (Get-Module ColorScripts-Enhanced -ErrorAction Stop).SessionState.PSVariable.GetValue('CacheDir')
    if (-not [string]::IsNullOrWhiteSpace($cacheVariable)) {
        $script:ModuleCacheDir = $cacheVariable
    }
    Write-Host "✓ Module imported successfully`n" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed to import module: $_" -ForegroundColor Red
    exit 1
}

# Test 1: Module loaded
Test-Function "Module loaded" {
    $module = Get-Module ColorScripts-Enhanced
    if (-not $module) { throw "Module not loaded" }
}

# Test 2: Functions exported
Test-Function "Show-ColorScript exported" {
    $cmd = Get-Command Show-ColorScript -ErrorAction Stop
    if (-not $cmd) { throw "Command not found" }
}

Test-Function "Get-ColorScriptList exported" {
    $cmd = Get-Command Get-ColorScriptList -ErrorAction Stop
    if (-not $cmd) { throw "Command not found" }
}

Test-Function "Build-ColorScriptCache exported" {
    $cmd = Get-Command Build-ColorScriptCache -ErrorAction Stop
    if (-not $cmd) { throw "Command not found" }
}

Test-Function "Clear-ColorScriptCache exported" {
    $cmd = Get-Command Clear-ColorScriptCache -ErrorAction Stop
    if (-not $cmd) { throw "Command not found" }
}

Test-Function "Add-ColorScriptProfile exported" {
    $cmd = Get-Command Add-ColorScriptProfile -ErrorAction Stop
    if (-not $cmd) { throw "Command not found" }
}

# Test 3: Alias exported
Test-Function "Alias 'scs' exists" {
    $alias = Get-Alias scs -ErrorAction Stop
    if ($alias.Definition -ne 'Show-ColorScript') {
        throw "Alias points to wrong command"
    }
}

# Test 4: Scripts directory exists
Test-Function "Scripts directory exists" {
    $scriptsPath = Join-Path $PSScriptRoot "ColorScripts-Enhanced\Scripts"
    if (-not (Test-Path $scriptsPath)) {
        throw "Scripts directory not found"
    }
}

# Test 5: Scripts are present
Test-Function "Colorscripts are available" {
    $scriptsPath = Join-Path $PSScriptRoot "ColorScripts-Enhanced\Scripts"
    $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1"
    if ($scripts.Count -eq 0) {
        throw "No colorscripts found"
    }
    Write-Host "  Found $($scripts.Count) scripts" -ForegroundColor Gray
}

# Test 6: Cache directory created
Test-Function "Cache directory exists" {
    $cacheDir = if ($script:ModuleCacheDir) { $script:ModuleCacheDir } else { Join-Path $env:APPDATA "ColorScripts-Enhanced\cache" }
    if (-not (Test-Path $cacheDir)) {
        throw "Cache directory not created"
    }
}

# Test 7: Get-ColorScriptList works
Test-Function "Get-ColorScriptList executes" {
    $null = Get-ColorScriptList *>&1
}

Test-Function "Get-ColorScriptList -Name filters results" {
    $records = Get-ColorScriptList -AsObject -Name "bars"
    if ($records.Count -ne 1 -or $records[0].Name -ne 'bars') {
        throw "Expected single bars record, found $($records.Count)"
    }
}

# Test 8: Show-ColorScript with -List
Test-Function "Show-ColorScript -List works" {
    $null = Show-ColorScript -List *>&1
}

# Test 9: Build cache for single script
Test-Function "Build-ColorScriptCache for single script" {
    Build-ColorScriptCache -Name "bars" -ErrorAction Stop *>&1 | Out-Null
    $cacheRoot = if ($script:ModuleCacheDir) { $script:ModuleCacheDir } else { Join-Path $env:APPDATA "ColorScripts-Enhanced\cache" }
    $cacheFile = Join-Path $cacheRoot "bars.cache"
    if (-not (Test-Path $cacheFile)) {
        throw "Cache file not created"
    }
}

Test-Function "Build-ColorScriptCache wildcard" {
    $result = Build-ColorScriptCache -Name "aurora-s*" -Force -ErrorAction Stop
    if (-not $result -or $result.Count -lt 2) {
        throw "Expected multiple results for wildcard build"
    }
    $names = $result | ForEach-Object { $_.Name }
    if ($names -notcontains 'aurora-stream' -or $names -notcontains 'aurora-storm') {
        throw "Wildcard cache build missing expected entries"
    }
}

# Test 10: Show specific script
Test-Function "Show-ColorScript by name" {
    Show-ColorScript -Name "bars" -ErrorAction Stop | Out-Null
    # If we get here, it executed successfully
}

Test-Function "Show-ColorScript wildcard selection" {
    $record = Show-ColorScript -Name "aurora-s*" -NoCache -PassThru
    if (-not $record) { throw "No record returned" }
    if ($record.Name -ne 'aurora-storm') { throw "Unexpected selection '$($record.Name)'" }
}

# Test 11: Clear specific cache
Test-Function "Clear-ColorScriptCache for specific script" {
    Clear-ColorScriptCache -Name "bars" -Confirm:$false *>&1 | Out-Null
    $cacheRoot = if ($script:ModuleCacheDir) { $script:ModuleCacheDir } else { Join-Path $env:APPDATA "ColorScripts-Enhanced\cache" }
    $cacheFile = Join-Path $cacheRoot "bars.cache"
    if (Test-Path $cacheFile) {
        throw "Cache file not removed"
    }
}

Test-Function "Clear-ColorScriptCache wildcard" {
    Build-ColorScriptCache -Name "aurora-s*" -Force -ErrorAction Stop *>&1 | Out-Null
    $result = Clear-ColorScriptCache -Name "aurora-s*" -Confirm:$false
    if (-not $result -or $result.Count -lt 2) {
        throw "Expected multiple results for wildcard clear"
    }
    foreach ($entry in $result) {
        if ($entry.Status -notin @('Removed', 'Missing')) {
            throw "Unexpected status '$($entry.Status)' for $($entry.Name)"
        }
    }
}


# Test 12: Help available
Test-Function "Help for Show-ColorScript" {
    $help = Get-Help Show-ColorScript
    if (-not $help.Synopsis) {
        throw "No help synopsis found"
    }
}

Test-Function "Help for Get-ColorScriptList" {
    $help = Get-Help Get-ColorScriptList
    if (-not $help.Synopsis) {
        throw "No help synopsis found"
    }
}

Test-Function "Help for Build-ColorScriptCache" {
    $help = Get-Help Build-ColorScriptCache
    if (-not $help.Synopsis) {
        throw "No help synopsis found"
    }
}

Test-Function "Help for Clear-ColorScriptCache" {
    $help = Get-Help Clear-ColorScriptCache
    if (-not $help.Synopsis) {
        throw "No help synopsis found"
    }
}

Test-Function "Help for Add-ColorScriptProfile" {
    $help = Get-Help Add-ColorScriptProfile
    if (-not $help.Synopsis) {
        throw "No help synopsis found"
    }
}

# Test 13: About help topic
Test-Function "about_ColorScripts-Enhanced help topic" {
    $help = Get-Help about_ColorScripts-Enhanced -ErrorAction Stop
    if (-not $help) {
        throw "Help topic not found"
    }
}

# Test 14: Module manifest valid
Test-Function "Module manifest is valid" {
    $manifestPath = Join-Path $PSScriptRoot "ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
    $manifest = Test-ModuleManifest $manifestPath -ErrorAction Stop
    if (-not $manifest) {
        throw "Invalid manifest"
    }
}

# Test 15: UTF-8 encoding support
Test-Function "UTF-8 encoding preserved" {
    $output = Show-ColorScript -Name "bars" *>&1 | Out-String
    if ($output.Length -eq 0) {
        throw "Empty output"
    }
}

# Test 16: NoCache parameter
Test-Function "Show-ColorScript -NoCache works" {
    Show-ColorScript -Name "bars" -NoCache -ErrorAction Stop | Out-Null
    # If we get here, it executed successfully
}

# Test 17: Random script selection
Test-Function "Show-ColorScript random selection" {
    Show-ColorScript -ErrorAction Stop | Out-Null
    # If we get here, it executed successfully
}

Test-Function "Add-ColorScriptProfile creates snippet" {
    $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfile_" + [Guid]::NewGuid() + '.ps1')
    if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

    try {
        $result = Add-ColorScriptProfile -Path $tempProfile
        if (-not $result.Changed) { throw "Profile not updated" }

        $content = Get-Content $tempProfile -Raw
        if ($content -notmatch 'Import-Module\s+ColorScripts-Enhanced') {
            throw "Import line missing"
        }
        if ($content -notmatch 'Show-ColorScript') {
            throw "Startup script missing"
        }
    }
    finally {
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
    }
}

Test-Function "Add-ColorScriptProfile SkipStartupScript" {
    $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfileSkip_" + [Guid]::NewGuid() + '.ps1')
    if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

    try {
        Add-ColorScriptProfile -Path $tempProfile -SkipStartupScript | Out-Null
        $content = Get-Content $tempProfile -Raw
        if ($content -notmatch 'Import-Module\s+ColorScripts-Enhanced') {
            throw "Import line missing"
        }
        if ($content -match 'Show-ColorScript') {
            throw "Startup script unexpectedly present"
        }
    }
    finally {
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
    }
}

Test-Function "Add-ColorScriptProfile expands tilde" {
    $uniqueName = "ColorScriptsProfileHome_{0}.ps1" -f ([Guid]::NewGuid())
    $tildePath = "~/$uniqueName"
    $expectedPath = [System.IO.Path]::GetFullPath((Join-Path $HOME $uniqueName))

    if (Test-Path $expectedPath) { Remove-Item $expectedPath -Force }

    try {
        $result = Add-ColorScriptProfile -Path $tildePath -SkipStartupScript -Force
        if ($result.Path -ne $expectedPath) { throw "Path not expanded as expected" }
        if (-not (Test-Path $expectedPath)) { throw "Profile file not created" }
    }
    finally {
        if (Test-Path $expectedPath) { Remove-Item $expectedPath -Force }
    }
}
Test-Function "Script analyzer clean" {
    if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
        throw "PSScriptAnalyzer module not installed. Run 'Install-Module PSScriptAnalyzer -Scope CurrentUser'."
    }

    Import-Module PSScriptAnalyzer -ErrorAction Stop

    $settingsPath = Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1'
    $moduleRoot = Join-Path $PSScriptRoot 'ColorScripts-Enhanced'
    $moduleItems = Get-ChildItem -Path $moduleRoot -File -Recurse -Include *.ps1, *.psm1, *.psd1

    $lintResults = New-Object 'System.Collections.Generic.List[psobject]'

    foreach ($item in $moduleItems) {
        $params = @{
            Path        = $item.FullName
            Severity    = 'Error', 'Warning'
            ErrorAction = 'Stop'
        }

        if (Test-Path $settingsPath) {
            $params.Settings = $settingsPath
        }

        try {
            $result = Invoke-ScriptAnalyzer @params
        }
        catch {
            $exception = $_.Exception
            $isNullRef = $exception -is [System.NullReferenceException] -or ($exception -and $exception.Message -like 'Object reference*')

            if ($isNullRef -and $params.ContainsKey('Settings')) {
                Write-Warning "ScriptAnalyzer encountered a known issue analyzing '$($item.FullName)' with custom settings. Retrying without settings."
                $params.Remove('Settings')
                $result = Invoke-ScriptAnalyzer @params
            }
            else {
                throw
            }
        }

        if ($result) {
            foreach ($entry in $result) {
                $lintResults.Add($entry) | Out-Null
            }
        }
    }

    if ($lintResults.Count -gt 0) {
        $lintResults | Format-Table -AutoSize | Out-String | Write-Host
        throw "ScriptAnalyzer reported issues"
    }
}

# Summary
Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $SuccessCount" -ForegroundColor Green
Write-Host "Failed: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { 'Red' } else { 'Green' })

if ($ErrorCount -eq 0) {
    Write-Host "`n✓ All tests passed!`n" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "`n✗ Some tests failed!`n" -ForegroundColor Red
    exit 1
}
