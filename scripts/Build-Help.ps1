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

    $tempScript = Join-Path `
        -Path ([System.IO.Path]::GetTempPath()) `
        -ChildPath ("colorscripts-help-{0}.ps1" -f [guid]::NewGuid())

    try {
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($tempScript, $ScriptContent, $utf8NoBom)

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
        Remove-Item -LiteralPath $tempScript -Force -ErrorAction SilentlyContinue
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
        # PlatyPS emits CommandInfo.HelpUri first and then appends the Markdown link. Walk in
        # reverse so duplicate URIs retain the explicitly localized Markdown label.
        for ($linkIndex = $links.Count - 1; $linkIndex -ge 0; $linkIndex--) {
            $link = $links[$linkIndex]
            $uriNode = $link.SelectSingleNode("./*[local-name()='uri']")
            $uri = if ($uriNode) { $uriNode.InnerText.Trim() } else { '' }

            if ([string]::IsNullOrWhiteSpace($uri) -or -not $seenLinks.Add($uri)) {
                $precedingWhitespace = $link.PreviousSibling
                [void]$link.ParentNode.RemoveChild($link)
                if ($precedingWhitespace -and
                    $precedingWhitespace.NodeType -in @(
                        [System.Xml.XmlNodeType]::Whitespace,
                        [System.Xml.XmlNodeType]::SignificantWhitespace
                    ) -and
                    [string]::IsNullOrWhiteSpace($precedingWhitespace.Value)) {
                    [void]$precedingWhitespace.ParentNode.RemoveChild($precedingWhitespace)
                }
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
$helpBuildConfigPath = Join-Path -Path $repoRoot -ChildPath 'Help.Build.psd1'
if (-not (Test-Path -LiteralPath $helpBuildConfigPath -PathType Leaf)) {
    throw "Help build configuration '$helpBuildConfigPath' was not found."
}
$helpBuildConfig = Import-PowerShellDataFile -LiteralPath $helpBuildConfigPath
if ($helpBuildConfig.SchemaVersion -ne 1) {
    throw "Unsupported help build configuration schema '$($helpBuildConfig.SchemaVersion)'."
}
$sourceDate = [datetimeoffset]::Parse(
    [string]$helpBuildConfig.SourceDateUtc,
    [cultureinfo]::InvariantCulture,
    [Globalization.DateTimeStyles]::AssumeUniversal
).ToUniversalTime()
if ($sourceDate.Year -lt 1980 -or $sourceDate.Offset -ne [timespan]::Zero) {
    throw "SourceDateUtc in '$helpBuildConfigPath' must be a UTC timestamp in 1980 or later."
}
$metadataDate = $sourceDate.UtcDateTime.ToString('MM/dd/yyyy', [cultureinfo]::InvariantCulture)

if (-not $ModulePath) {
    $ModulePath = Join-Path $repoRoot 'ColorScripts-Enhanced'
}

$moduleName = Split-Path -Path $ModulePath -Leaf
$ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath ("{0}.psd1" -f $moduleName)
if (-not (Test-Path -LiteralPath $ModuleManifestPath -PathType Leaf)) {
    throw "Module manifest '$ModuleManifestPath' was not found."
}
$ModuleManifestPath = (Get-Item -LiteralPath $ModuleManifestPath).FullName

$moduleData = Import-PowerShellDataFile -LiteralPath $ModuleManifestPath
$moduleGuid = [string]$moduleData.GUID
if ($moduleName -cne [string]$helpBuildConfig.Module.Name -or
    $moduleGuid -cne [string]$helpBuildConfig.Module.Guid) {
    throw "Module identity does not match '$helpBuildConfigPath'."
}

# Culture membership is a public help-distribution contract, so it is pinned
# instead of being inferred from any directory that happens to match a pattern.
$availableCultures = @($helpBuildConfig.Cultures)
if ($availableCultures.Count -eq 0 -or
    @($availableCultures | Sort-Object -Unique).Count -ne $availableCultures.Count) {
    throw "Help build configuration must declare at least one unique culture."
}
foreach ($uiCulture in $availableCultures) {
    $culturePath = Join-Path -Path $ModulePath -ChildPath $uiCulture
    if (-not (Test-Path -LiteralPath $culturePath -PathType Container)) {
        throw "Configured help culture '$uiCulture' was not found at '$culturePath'."
    }
}

Write-Host "`nAvailable UI cultures: $($availableCultures -join ', ')" -ForegroundColor Cyan

$helpInfoUri = [string]$helpBuildConfig.Module.HelpInfoUri
if ([string]::IsNullOrWhiteSpace($helpInfoUri) -or $helpInfoUri[-1] -ne '/') {
    throw "HelpInfoUri in '$helpBuildConfigPath' must be an absolute directory URI ending in '/'."
}
if ([string]$moduleData.HelpInfoURI -cne $helpInfoUri) {
    throw "Module HelpInfoURI '$($moduleData.HelpInfoURI)' does not match '$helpInfoUri'."
}

Write-Host "`nColorScripts-Enhanced Help Builder" -ForegroundColor Cyan
Write-Host '=================================' -ForegroundColor Cyan

# Generated Markdown and MAML are sensitive to PlatyPS serializer changes.
$platyModuleName = [string]$helpBuildConfig.PlatyPS.Name
$requiredPlatyVersion = [version]$helpBuildConfig.PlatyPS.RequiredVersion
$platyModule = Get-Module -ListAvailable -Name $platyModuleName |
    Where-Object Version -EQ $requiredPlatyVersion |
        Select-Object -First 1
$hasPlatyPS = [bool]$platyModule
$isModernPlaty = $true

if (-not $hasPlatyPS) {
    if ($UpdateMarkdown -or -not $SkipXmlGeneration) {
        throw @"
$platyModuleName $requiredPlatyVersion is required to update Markdown or generate external help.
Install a trusted release explicitly, then rerun the command:
  Install-Module -Name $platyModuleName -RequiredVersion $requiredPlatyVersion -Scope CurrentUser
Use -SkipXmlGeneration without -UpdateMarkdown only when you intend to validate existing help.
"@
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
        $hasMarkdownFiles = Get-ChildItem -LiteralPath $cultureSourceFolder -Filter '*.md' -ErrorAction SilentlyContinue
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
                $escapedPlatyVersion = $requiredPlatyVersion.ToString() -replace "'", "''"
                $escapedManifestPath = $ModuleManifestPath -replace "'", "''"
                $escapedMetadataDate = $metadataDate -replace "'", "''"
                $syncHelpPath = Join-Path -Path $PSScriptRoot -ChildPath 'Sync-HelpMetadata.ps1'
                if ($isModernPlaty -and -not (Test-Path -LiteralPath $syncHelpPath -PathType Leaf)) {
                    throw "Cannot locate the metadata synchronization script at '$syncHelpPath'."
                }
                $escapedSyncHelpPath = $syncHelpPath -replace "'", "''"

                if ($isModernPlaty) {
                    $updateScript = @"
Import-Module '$escapedModulePath' -Force -ErrorAction Stop
Import-Module -Name '$escapedPlatyName' -RequiredVersion '$escapedPlatyVersion' -Force -ErrorAction Stop

& '$escapedSyncHelpPath' -ModuleManifestPath '$escapedManifestPath' -CulturePath '$escapedCulturePath' -Culture '$uiCulture' -PlatyModuleName '$escapedPlatyName' -PlatyModuleVersion '$escapedPlatyVersion' -MetadataDate '$escapedMetadataDate'

Write-Host "Markdown files updated successfully for $uiCulture"
"@
                }
                else {
                    $updateScript = @"
Import-Module '$escapedModulePath' -Force -ErrorAction Stop
Import-Module -Name '$escapedPlatyName' -RequiredVersion '$escapedPlatyVersion' -Force -ErrorAction Stop

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

                Get-ChildItem -LiteralPath $cultureOutputPath -Filter '*.md' | ForEach-Object {
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
            $escapedPlatyVersion = $requiredPlatyVersion.ToString() -replace "'", "''"

            if ($isModernPlaty) {
                $mamlScript = @"
Import-Module -Name '$escapedPlatyName' -RequiredVersion '$escapedPlatyVersion' -Force -ErrorAction Stop
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
Import-Module -Name '$escapedPlatyName' -RequiredVersion '$escapedPlatyVersion' -Force -ErrorAction Stop
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
            $normalizerPath = Join-Path -Path $PSScriptRoot -ChildPath 'Normalize-MamlFencedCode.ps1'
            if (-not (Test-Path -LiteralPath $normalizerPath -PathType Leaf)) {
                throw "Cannot locate the MAML normalizer at '$normalizerPath'."
            }
            $normalization = & $normalizerPath -LiteralPath $targetHelpPath
            if ($normalization.ExampleCount -le 0) {
                throw "MAML normalization did not validate any examples for '$uiCulture'."
            }

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
    }

    $updatableHelpBuilder = Join-Path -Path $PSScriptRoot -ChildPath 'Build-UpdatableHelp.ps1'
    if (-not (Test-Path -LiteralPath $updatableHelpBuilder -PathType Leaf)) {
        throw "Cannot locate the updatable-help builder at '$updatableHelpBuilder'."
    }
    & $updatableHelpBuilder -ModulePath $ModulePath -ConfigurationPath $helpBuildConfigPath
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
    $helpValidationFailures = New-Object 'System.Collections.Generic.List[string]'
    foreach ($culture in $availableCultures) {
        Write-Host "`nTesting culture: ${culture}" -ForegroundColor Cyan

        # Set the UI culture for this test
        $originalCulture = [System.Threading.Thread]::CurrentThread.CurrentUICulture
        try {
            [System.Threading.Thread]::CurrentThread.CurrentUICulture = $culture

            foreach ($cmd in $commands) {
                try {
                    $help = Get-Help $cmd -ErrorAction Stop
                    if ($help.Synopsis) {
                        Write-Host "  ✓ Help validated for $cmd" -ForegroundColor Green
                    }
                    else {
                        Write-Host "  ✗ Help missing synopsis for $cmd" -ForegroundColor Red
                        [void]$helpValidationFailures.Add(
                            "${culture}: $cmd has no synopsis."
                        )
                    }
                }
                catch {
                    Write-Host "  ✗ Help failed for $cmd : $_" -ForegroundColor Red
                    [void]$helpValidationFailures.Add(
                        "${culture}: $cmd failed validation: $($_.Exception.Message)"
                    )
                }
            }
        }
        finally {
            [System.Threading.Thread]::CurrentThread.CurrentUICulture = $originalCulture
        }
    }
    if ($helpValidationFailures.Count -gt 0) {
        throw "Help validation failed:`n$($helpValidationFailures -join [Environment]::NewLine)"
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
