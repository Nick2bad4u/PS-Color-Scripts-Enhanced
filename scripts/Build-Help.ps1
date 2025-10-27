# Generate External Help XML from Markdown
# This script converts markdown help files to MAML XML format
# Note: Requires platyPS module (optional - install manually if needed)

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModulePath,

    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [switch]$SkipXmlGeneration,

    [Parameter()]
    [switch]$UpdateMarkdown
)

function Invoke-HelperPowerShell {
    param(
        [Parameter(Mandatory)]
        [string]$ScriptContent,

        [string]$Purpose = 'helper task'
    )

    $psExe = $null

    if ($PSVersionTable.PSEdition -eq 'Core') {
        $cmd = Get-Command pwsh -ErrorAction SilentlyContinue
        if ($cmd) { $psExe = $cmd.Source }
    }

    if (-not $psExe) {
        $cmd = Get-Command powershell -ErrorAction SilentlyContinue
        if ($cmd) { $psExe = $cmd.Source }
    }

    if (-not $psExe) {
        throw "Unable to locate a PowerShell executable for $Purpose."
    }

    $tempScript = [System.IO.Path]::ChangeExtension([System.IO.Path]::GetTempFileName(), '.ps1')

    try {
        Set-Content -Path $tempScript -Value $ScriptContent -Encoding UTF8

        $psArgs = @('-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $tempScript)
        $output = & $psExe @psArgs 2>&1
        $exitCode = $LASTEXITCODE

        return [PSCustomObject]@{
            ExitCode   = $exitCode
            Output     = $output
            Executable = $psExe
        }
    }
    finally {
        Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
    }
}

# Set default paths relative to repository root
$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $ModulePath) {
    $ModulePath = Join-Path $repoRoot "ColorScripts-Enhanced"
}
if (-not $OutputPath) {
    $OutputPath = Join-Path $ModulePath "en-US"
}

$ModuleManifestPath = Get-ChildItem -Path $ModulePath -Filter '*.psd1' -File | Select-Object -First 1
if (-not $ModuleManifestPath) {
    throw "Module manifest (*.psd1) not found in $ModulePath."
}
$ModuleManifestPath = $ModuleManifestPath.FullName

$moduleData = Import-PowerShellDataFile -Path $ModuleManifestPath
$moduleGuid = [string]$moduleData.GUID
$moduleVersion = [string]$moduleData.ModuleVersion
$moduleName = Split-Path -Path $ModulePath -Leaf
$uiCulture = 'en-US'
$cabSourceFolder = Join-Path $ModulePath $uiCulture

$helpInfoUri = [string]$moduleData.HelpInfoURI
if ([string]::IsNullOrWhiteSpace($helpInfoUri)) {
    $helpInfoUri = "https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/$moduleName/en_US/"
}
elseif ($helpInfoUri[-1] -ne '/') {
    $helpInfoUri += '/'
}

$publishRoot = Join-Path $repoRoot 'docs'
$helpPublishRoot = Join-Path $publishRoot "$moduleName/en_US"

if (-not (Test-Path $publishRoot)) {
    New-Item -ItemType Directory -Path $publishRoot -Force | Out-Null
}

if (-not (Test-Path $helpPublishRoot)) {
    New-Item -ItemType Directory -Path $helpPublishRoot -Force | Out-Null
}

Write-Host "`nColorScripts-Enhanced Help Builder" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check if PlatyPS is available (handle legacy and current names)
$platyModule = Get-Module -ListAvailable -Name 'Microsoft.PowerShell.PlatyPS', 'PlatyPS', 'platyPS' |
    Sort-Object -Property @(
        @{ Expression = { $_.Name -eq 'Microsoft.PowerShell.PlatyPS' }; Descending = $true },
        @{ Expression = { $_.Version }; Descending = $true }
    ) |
        Select-Object -First 1
$hasPlatyPS = [bool]$platyModule
$platyModuleName = if ($platyModule) { $platyModule.Name } else { 'Microsoft.PowerShell.PlatyPS' }
$isModernPlaty = $platyModuleName -eq 'Microsoft.PowerShell.PlatyPS'

if (-not $hasPlatyPS) {
    Write-Host "`nplatyPS module is not installed." -ForegroundColor Yellow
    Write-Host "`nThe module already has comment-based help that works without platyPS." -ForegroundColor Green
    Write-Host "External XML help is optional and only needed for advanced scenarios.`n" -ForegroundColor Gray

    Write-Host "To install platyPS (optional):" -ForegroundColor Yellow
    Write-Host "  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass" -ForegroundColor Gray
    Write-Host "  Install-Module -Name Microsoft.PowerShell.PlatyPS -Scope CurrentUser -Force -SkipPublisherCheck`n" -ForegroundColor Gray

    Write-Host "Skipping markdown update and XML generation.`n" -ForegroundColor Green
    $SkipXmlGeneration = $true
    $UpdateMarkdown = $false
}

if (-not $SkipXmlGeneration -and $hasPlatyPS) {
    Write-Host "`nDetected PlatyPS module: $platyModuleName" -ForegroundColor Yellow
}

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

if (-not $SkipXmlGeneration) {
    # Update markdown files from module if requested
    if ($UpdateMarkdown) {
        Write-Host "`nUpdating markdown help files from module..." -ForegroundColor Yellow

        try {
            $escapedModulePath = $ModulePath -replace "'", "''"
            $escapedOutputPath = $OutputPath -replace "'", "''"
            $escapedPlatyName = $platyModuleName -replace "'", "''"

            $updateScript = @"
Import-Module '$escapedModulePath' -Force -ErrorAction Stop
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop

# Update all markdown help files for the module
# Note: Update-MarkdownCommandHelp should be called on the directory, not individual files
Update-MarkdownCommandHelp -Path '$escapedOutputPath' -RefreshModulePage -AlphabeticParamsOrder -UpdateInputOutput -Force

Write-Host "Markdown files updated successfully"
"@

            $updateResult = Invoke-HelperPowerShell -ScriptContent $updateScript -Purpose 'markdown help update'

            if ($updateResult.ExitCode -ne 0) {
                throw "Markdown update helper exited with code $($updateResult.ExitCode) : $($updateResult.Output)"
            }

            if ($updateResult.Output) {
                Write-Verbose ($updateResult.Output | Out-String)
            }

            Get-ChildItem -Path $OutputPath -Filter '*.md' | ForEach-Object {
                Write-Host "  Updated: $($_.Name)" -ForegroundColor Gray
            }

            Write-Host "✓ Markdown files updated successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "✗ Failed to update markdown files: $_" -ForegroundColor Red
            Write-Host "  Continuing with existing markdown...`n" -ForegroundColor Yellow
        }
    }

    # Generate MAML from markdown files
    Write-Host "`nConverting markdown to MAML XML..." -ForegroundColor Yellow

    try {
        $escapedOutputPath = $OutputPath -replace "'", "''"
        $escapedPlatyName = $platyModuleName -replace "'", "''"

        if ($isModernPlaty) {
            $mamlScript = @"
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop
`$mdFiles = Measure-PlatyPSMarkdown -Path (Join-Path '$escapedOutputPath' '*.md')
`$commandHelpFiles = `$mdFiles | Where-Object { `$_.FileType -like '*CommandHelp*' }
if (-not `$commandHelpFiles) {
    throw "No PlatyPS command help markdown files were found in '$escapedOutputPath'."
}
`$commandHelpFiles |
    Import-MarkdownCommandHelp -Path { `$_.FilePath } |
    Export-MamlCommandHelp -OutputFolder '$escapedOutputPath' -Force

`$nestedHelp = Join-Path '$escapedOutputPath' 'ColorScripts-Enhanced\ColorScripts-Enhanced-help.xml'
`$targetHelp = Join-Path '$escapedOutputPath' 'ColorScripts-Enhanced-help.xml'
if (Test-Path `$nestedHelp) {
    Move-Item -Path `$nestedHelp -Destination `$targetHelp -Force
    `$nestedDir = Join-Path '$escapedOutputPath' 'ColorScripts-Enhanced'
    if (Test-Path `$nestedDir) {
        Remove-Item -Path `$nestedDir -Recurse -Force
    }
}
"@
        }
        else {
            $mamlScript = @"
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop
New-ExternalHelp -Path '$escapedOutputPath' -OutputPath '$escapedOutputPath' -Force
"@
        }

        $mamlResult = Invoke-HelperPowerShell -ScriptContent $mamlScript -Purpose 'external help generation'

        if ($mamlResult.ExitCode -ne 0) {
            throw "External help helper exited with code $($mamlResult.ExitCode) : $($mamlResult.Output)"
        }

        if ($mamlResult.Output) {
            Write-Verbose ($mamlResult.Output | Out-String)
        }

        Write-Host "✓ External help XML generated successfully" -ForegroundColor Green
        Write-Host "  Location: $OutputPath\ColorScripts-Enhanced-help.xml`n" -ForegroundColor Gray
    }
    catch {
        Write-Host "✗ Failed to generate help XML: $_" -ForegroundColor Red
        throw
    }

    # Generate HelpInfo.xml for updatable help
    Write-Host "Generating HelpInfo.xml..." -ForegroundColor Yellow

    try {
        # Create the HelpInfo.xml content
        $helpInfoContent = @"
<?xml version="1.0" encoding="utf-8"?>
<HelpInfo xmlns="http://schemas.microsoft.com/powershell/help/2010/05">
  <HelpContentURI>$helpInfoUri</HelpContentURI>
  <SupportedUICultures>
    <UICulture>
      <UICultureName>$uiCulture</UICultureName>
      <UICultureVersion>$moduleVersion</UICultureVersion>
    </UICulture>
  </SupportedUICultures>
</HelpInfo>
"@

        # Write to the output directory with correct naming convention
        $helpInfoFileName = "{0}_{1}_HelpInfo.xml" -f $moduleName, $moduleGuid
        $helpInfoPath = Join-Path $OutputPath $helpInfoFileName

        # Remove any old HelpInfo files with incorrect names
        Get-ChildItem -Path $OutputPath -Filter "*_HelpInfo.xml" |
            Where-Object { $_.Name -ne $helpInfoFileName } |
                Remove-Item -Force -ErrorAction SilentlyContinue

        Set-Content -Path $helpInfoPath -Value $helpInfoContent -Encoding UTF8 -NoNewline
        Write-Host "✓ HelpInfo.xml generated successfully" -ForegroundColor Green
        Write-Host "  Location: $helpInfoPath" -ForegroundColor Gray
        Write-Host "  Version: $moduleVersion`n" -ForegroundColor Gray
    }
    catch {
        Write-Host "✗ Failed to generate HelpInfo.xml: $_" -ForegroundColor Red
        Write-Host "  Continuing without HelpInfo.xml...`n" -ForegroundColor Yellow
    }
}

# Validate the help
Write-Host "Validating help content..." -ForegroundColor Yellow

try {
    Import-Module $ModuleManifestPath -Force -ErrorAction Stop

    $commands = @(
        'Show-ColorScript'
        'Get-ColorScriptList'
        'Build-ColorScriptCache'
        'Clear-ColorScriptCache'
        'Add-ColorScriptProfile'
        'Get-ColorScriptConfiguration'
        'Set-ColorScriptConfiguration'
        'Reset-ColorScriptConfiguration'
        'Export-ColorScriptMetadata'
        'New-ColorScript'
    )

    Write-Host ""
    foreach ($cmd in $commands) {
        $help = Get-Help $cmd -ErrorAction Stop
        if ($help.Synopsis) {
            Write-Host "  ✓ Help validated for $cmd" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ Help missing synopsis for $cmd" -ForegroundColor Red
        }
    }

    # Test about topic
    Write-Host ""
    $aboutHelp = Get-Help about_ColorScripts-Enhanced -ErrorAction SilentlyContinue
    if ($aboutHelp) {
        Write-Host "  ✓ about_ColorScripts-Enhanced help topic found" -ForegroundColor Green
    }
    else {
        Write-Host "  ⚠ about_ColorScripts-Enhanced help topic not found" -ForegroundColor Yellow
    }

    Write-Host "`n==================================" -ForegroundColor Cyan
    Write-Host "✓ Help validation complete!`n" -ForegroundColor Green

    if ($SkipXmlGeneration) {
        Write-Host "Note: Using comment-based help (XML generation skipped)" -ForegroundColor Gray
        Write-Host "All help commands will work normally with Get-Help.`n" -ForegroundColor Gray
    }
}
catch {
    Write-Host "`n✗ Help validation failed: $_" -ForegroundColor Red
    Write-Host "Module may not be properly loaded.`n" -ForegroundColor Yellow
    exit 1
}
