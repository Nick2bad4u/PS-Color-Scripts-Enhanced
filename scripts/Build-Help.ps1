# Generate External Help XML from Markdown
# This script converts markdown help files to MAML XML format
# Note: Requires platyPS module (optional - install manually if needed)

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModulePath,

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

function Remove-DuplicateMamlRelatedLink {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    $document = New-Object System.Xml.XmlDocument
    $document.PreserveWhitespace = $true
    $document.Load($LiteralPath)
    $removedCount = 0

    foreach ($commandNode in $document.SelectNodes("//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']")) {
        $seenLinks = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::Ordinal)
        $links = @($commandNode.SelectNodes("./*[local-name()='relatedLinks']/*[local-name()='navigationLink']"))
        foreach ($link in $links) {
            $textNode = $link.SelectSingleNode("./*[local-name()='linkText']")
            $uriNode = $link.SelectSingleNode("./*[local-name()='uri']")
            $text = if ($textNode) { $textNode.InnerText.Trim() } else { '' }
            $uri = if ($uriNode) { $uriNode.InnerText.Trim() } else { '' }
            $key = '{0}|{1}' -f $text, $uri

            if ([string]::IsNullOrWhiteSpace($uri) -or -not $seenLinks.Add($key)) {
                [void]$link.ParentNode.RemoveChild($link)
                $removedCount++
            }
        }
    }

    if ($removedCount -gt 0) {
        $writerSettings = New-Object System.Xml.XmlWriterSettings
        $writerSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
        $writerSettings.Indent = $false
        $writerSettings.NewLineHandling = [System.Xml.NewLineHandling]::None
        $writer = [System.Xml.XmlWriter]::Create($LiteralPath, $writerSettings)
        try {
            $document.Save($writer)
        }
        finally {
            $writer.Dispose()
        }
    }

    return $removedCount
}

# Set default paths relative to repository root
$repoRoot = Split-Path -Path $PSScriptRoot -Parent
if (-not $ModulePath) {
    $ModulePath = Join-Path $repoRoot 'ColorScripts-Enhanced'
}

$moduleName = Split-Path -Path $ModulePath -Leaf
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath ("{0}.psd1" -f $moduleName)
if (-not (Test-Path -LiteralPath $ModuleManifestPath -PathType Leaf)) {
    throw "Module manifest '$ModuleManifestPath' was not found."
}
$ModuleManifestPath = (Get-Item -LiteralPath $ModuleManifestPath).FullName

$moduleData = Import-PowerShellDataFile -Path $ModuleManifestPath
$moduleGuid = [string]$moduleData.GUID
$moduleVersion = [string]$moduleData.ModuleVersion

# Get all available UI cultures (directories with help content)
$availableCultures = Get-ChildItem -Path $ModulePath -Directory |
    Where-Object { $_.Name -match '^[a-z]{2}(-[A-Z]{2})?$' } |
        ForEach-Object { $_.Name } |
            Sort-Object

# Default to en-US if no cultures found
if (-not $availableCultures) {
    $availableCultures = @('en-US')
}

Write-Host "`nAvailable UI cultures: $($availableCultures -join ', ')" -ForegroundColor Cyan

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
Write-Host '=================================' -ForegroundColor Cyan

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
    if ($UpdateMarkdown -or -not $SkipXmlGeneration) {
        throw @'
Microsoft.PowerShell.PlatyPS is required to update Markdown or generate external help.
Install a trusted release explicitly, then rerun the command:
  Install-Module -Name Microsoft.PowerShell.PlatyPS -Scope CurrentUser
Use -SkipXmlGeneration without -UpdateMarkdown only when you intend to validate existing help.
'@
    }

    Write-Verbose 'Microsoft.PowerShell.PlatyPS is unavailable; validating existing help only.'
}

if (-not $SkipXmlGeneration -and $hasPlatyPS) {
    Write-Host "`nDetected PlatyPS module: $platyModuleName" -ForegroundColor Yellow
}

if (-not $SkipXmlGeneration) {
    # Process each available culture
    foreach ($uiCulture in $availableCultures) {
        $cultureOutputPath = Join-Path $ModulePath $uiCulture
        $cultureSourceFolder = Join-Path $ModulePath $uiCulture

        Write-Host "`nProcessing culture: $uiCulture" -ForegroundColor Cyan
        Write-Host "  Source: $cultureSourceFolder" -ForegroundColor Gray
        Write-Host "  Output: $cultureOutputPath" -ForegroundColor Gray

        # Check if this culture has help files
        $hasMarkdownFiles = Get-ChildItem -Path $cultureSourceFolder -Filter '*.md' -ErrorAction SilentlyContinue
        if (-not $hasMarkdownFiles) {
            Write-Host "  ⚠ No markdown help files found for culture $uiCulture, skipping..." -ForegroundColor Yellow
            continue
        }

        # Update markdown files from module if requested
        if ($UpdateMarkdown) {
            Write-Host '  Updating markdown help files from module...' -ForegroundColor Yellow

            try {
                $escapedModulePath = $ModulePath -replace "'", "''"
                $escapedCulturePath = $cultureOutputPath -replace "'", "''"
                $escapedPlatyName = $platyModuleName -replace "'", "''"
                $escapedManifestPath = $ModuleManifestPath -replace "'", "''"
                $syncHelpPath = Join-Path -Path $PSScriptRoot -ChildPath 'Sync-HelpMetadata.ps1'
                if ($isModernPlaty -and -not (Test-Path -LiteralPath $syncHelpPath -PathType Leaf)) {
                    throw "Cannot locate the metadata synchronization script at '$syncHelpPath'."
                }
                $escapedSyncHelpPath = $syncHelpPath -replace "'", "''"

                if ($isModernPlaty) {
                    $updateScript = @"
Import-Module '$escapedModulePath' -Force -ErrorAction Stop
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop

& '$escapedSyncHelpPath' -ModuleManifestPath '$escapedManifestPath' -CulturePath '$escapedCulturePath' -Culture '$uiCulture' -PlatyModuleName '$escapedPlatyName'

Write-Host "Markdown files updated successfully for $uiCulture"
"@
                }
                else {
                    $updateScript = @"
Import-Module '$escapedModulePath' -Force -ErrorAction Stop
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop

Update-MarkdownCommandHelp -Path '$escapedCulturePath' -RefreshModulePage -AlphabeticParamsOrder -UpdateInputOutput -Force

Write-Host "Markdown files updated successfully for $uiCulture"
"@
                }

                $updateResult = Invoke-HelperPowerShell -ScriptContent $updateScript -Purpose 'markdown help update'

                if ($updateResult.ExitCode -ne 0) {
                    throw "Markdown update helper exited with code $($updateResult.ExitCode) : $($updateResult.Output)"
                }

                if ($updateResult.Output) {
                    Write-Verbose ($updateResult.Output | Out-String)
                }

                Get-ChildItem -Path $cultureOutputPath -Filter '*.md' | ForEach-Object {
                    Write-Host "    Updated: $($_.Name)" -ForegroundColor Gray
                }

                Write-Host "  ✓ Markdown files updated successfully for $uiCulture" -ForegroundColor Green
            }
            catch {
                throw "Failed to update markdown files for ${uiCulture}: $($_.Exception.Message)"
            }
        }

        $templateMarkers = @(
            Get-ChildItem -LiteralPath $cultureOutputPath -Filter '*.md' -File |
                Select-String -SimpleMatch '{{'
        )
        if ($templateMarkers.Count -gt 0) {
            $locations = $templateMarkers |
                ForEach-Object { '{0}:{1}' -f $_.Path, $_.LineNumber }
            throw "Unresolved PlatyPS template markers remain for ${uiCulture}: $($locations -join ', ')"
        }

        # Generate MAML from markdown files
        Write-Host '  Converting markdown to MAML XML...' -ForegroundColor Yellow

        try {
            $escapedCulturePath = $cultureOutputPath -replace "'", "''"
            $escapedPlatyName = $platyModuleName -replace "'", "''"

            if ($isModernPlaty) {
                $mamlScript = @"
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop
`$mdFiles = Measure-PlatyPSMarkdown -Path (Join-Path '$escapedCulturePath' '*.md')
`$commandHelpFiles = `$mdFiles | Where-Object { `$_.FileType -like '*CommandHelp*' }
if (-not `$commandHelpFiles) {
    throw "No PlatyPS command help markdown files were found in '$escapedCulturePath'."
}
`$commandHelpFiles |
    ForEach-Object { Import-MarkdownCommandHelp -Path `$_.FilePath } |
    Export-MamlCommandHelp -OutputFolder '$escapedCulturePath' -Force

`$nestedHelp = Join-Path '$escapedCulturePath' 'ColorScripts-Enhanced\ColorScripts-Enhanced-help.xml'
`$targetHelp = Join-Path '$escapedCulturePath' 'ColorScripts-Enhanced-help.xml'
if (Test-Path `$nestedHelp) {
    Move-Item -Path `$nestedHelp -Destination `$targetHelp -Force
    `$nestedDir = Join-Path '$escapedCulturePath' 'ColorScripts-Enhanced'
    if (Test-Path `$nestedDir) {
        Remove-Item -Path `$nestedDir -Recurse -Force
    }
}

if (-not (Test-Path -LiteralPath `$targetHelp -PathType Leaf)) {
    throw "PlatyPS did not generate the expected MAML file '`$targetHelp'."
}

`$maml = [xml](Get-Content -LiteralPath `$targetHelp -Raw -ErrorAction Stop)
`$mamlCommandCount = @(`$maml.SelectNodes("//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']")).Count
if (`$mamlCommandCount -ne `$commandHelpFiles.Count) {
    throw "Generated MAML contains `$mamlCommandCount commands; expected `$(`$commandHelpFiles.Count)."
}
"@
            }
            else {
                $mamlScript = @"
Import-Module '$escapedPlatyName' -Force -ErrorAction Stop
New-ExternalHelp -Path '$escapedCulturePath' -OutputPath '$escapedCulturePath' -Force
"@
            }

            $mamlResult = Invoke-HelperPowerShell -ScriptContent $mamlScript -Purpose 'external help generation'

            if ($mamlResult.ExitCode -ne 0) {
                throw "External help helper exited with code $($mamlResult.ExitCode) : $($mamlResult.Output)"
            }

            if ($mamlResult.Output) {
                Write-Verbose ($mamlResult.Output | Out-String)
            }

            $targetHelpPath = Join-Path -Path $cultureOutputPath -ChildPath 'ColorScripts-Enhanced-help.xml'
            $removedRelatedLinkCount = Remove-DuplicateMamlRelatedLink -LiteralPath $targetHelpPath
            if ($removedRelatedLinkCount -gt 0) {
                Write-Verbose "Removed $removedRelatedLinkCount duplicate or empty MAML related link(s) for $uiCulture."
            }

            Write-Host "  ✓ External help XML generated successfully for ${uiCulture}" -ForegroundColor Green
            Write-Host "    Location: $cultureOutputPath\ColorScripts-Enhanced-help.xml" -ForegroundColor Gray
        }
        catch {
            throw "Failed to generate help XML for ${uiCulture}: $($_.Exception.Message)"
        }

        # Generate HelpInfo.xml for updatable help
        Write-Host "  Generating HelpInfo.xml for ${uiCulture}..." -ForegroundColor Yellow

        try {
            # Create culture-specific HelpInfo URI
            $cultureHelpInfoUri = $helpInfoUri
            if ($uiCulture -ne 'en-US') {
                $cultureHelpInfoUri = $helpInfoUri.Replace('/en_US/', "/$uiCulture/")
            }

            # Create the HelpInfo.xml content
            $helpInfoContent = @"
<?xml version="1.0" encoding="utf-8"?>
<HelpInfo xmlns="http://schemas.microsoft.com/powershell/help/2010/05">
  <HelpContentURI>$cultureHelpInfoUri</HelpContentURI>
  <SupportedUICultures>
    <UICulture>
      <UICultureName>$uiCulture</UICultureName>
      <UICultureVersion>$moduleVersion</UICultureVersion>
    </UICulture>
  </SupportedUICultures>
</HelpInfo>
"@

            # Write to the culture directory with correct naming convention
            $helpInfoFileName = '{0}_{1}_HelpInfo.xml' -f $moduleName, $moduleGuid
            $helpInfoPath = Join-Path $cultureOutputPath $helpInfoFileName

            # Remove any old HelpInfo files with incorrect names
            Get-ChildItem -Path $cultureOutputPath -Filter '*_HelpInfo.xml' |
                Where-Object { $_.Name -ne $helpInfoFileName } |
                    Remove-Item -Force -ErrorAction SilentlyContinue

            Set-Content -Path $helpInfoPath -Value $helpInfoContent -Encoding UTF8 -NoNewline
            Write-Host "  ✓ HelpInfo.xml generated successfully for ${uiCulture}" -ForegroundColor Green
            Write-Host "    Location: $helpInfoPath" -ForegroundColor Gray
            Write-Host "    Version: $moduleVersion" -ForegroundColor Gray
        }
        catch {
            throw "Failed to generate HelpInfo.xml for ${uiCulture}: $($_.Exception.Message)"
        }
    }
}

# Validate the help for all cultures
Write-Host 'Validating help content...' -ForegroundColor Yellow

try {
    Import-Module $ModuleManifestPath -Force -ErrorAction Stop

    $commands = @(
        'Show-ColorScript'
        'Get-ColorScriptList'
        'New-ColorScriptCache'
        'Clear-ColorScriptCache'
        'Add-ColorScriptProfile'
        'Get-ColorScriptConfiguration'
        'Set-ColorScriptConfiguration'
        'Reset-ColorScriptConfiguration'
        'Export-ColorScriptMetadata'
        'New-ColorScript'
    )

    # Test each culture
    foreach ($culture in $availableCultures) {
        Write-Host "`nTesting culture: ${culture}" -ForegroundColor Cyan

        # Set the UI culture for this test
        $originalCulture = [System.Threading.Thread]::CurrentThread.CurrentUICulture
        try {
            [System.Threading.Thread]::CurrentThread.CurrentUICulture = $culture

            $cultureHasHelp = $false
            foreach ($cmd in $commands) {
                try {
                    $help = Get-Help $cmd -ErrorAction Stop
                    if ($help.Synopsis) {
                        Write-Host "  ✓ Help validated for $cmd" -ForegroundColor Green
                        $cultureHasHelp = $true
                    }
                    else {
                        Write-Host "  ✗ Help missing synopsis for $cmd" -ForegroundColor Red
                    }
                }
                catch {
                    Write-Host "  ✗ Help failed for $cmd : $_" -ForegroundColor Red
                }
            }

            if (-not $cultureHasHelp) {
                Write-Host "  ⚠ No help files found for culture ${culture}" -ForegroundColor Yellow
            }
        }
        finally {
            [System.Threading.Thread]::CurrentThread.CurrentUICulture = $originalCulture
        }
    }

    # Test about topic (only in en-US typically)
    Write-Host "`nTesting about topics..." -ForegroundColor Cyan
    $aboutHelp = Get-Help about_ColorScripts-Enhanced -ErrorAction SilentlyContinue
    if ($aboutHelp) {
        Write-Host '  ✓ about_ColorScripts-Enhanced help topic found' -ForegroundColor Green
    }
    else {
        Write-Host '  ⚠ about_ColorScripts-Enhanced help topic not found' -ForegroundColor Yellow
    }

    Write-Host "`n==================================" -ForegroundColor Cyan
    Write-Host "✓ Help validation complete!`n" -ForegroundColor Green

    if ($SkipXmlGeneration) {
        Write-Host 'Note: Using comment-based help (XML generation skipped)' -ForegroundColor Gray
        Write-Host "All help commands will work normally with Get-Help.`n" -ForegroundColor Gray
    }
}
catch {
    Write-Host "`n✗ Help validation failed: $_" -ForegroundColor Red
    Write-Host "Module may not be properly loaded.`n" -ForegroundColor Yellow
    exit 1
}
