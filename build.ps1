<#
.SYNOPSIS
    Build script for ColorScripts-Enhanced PowerShell module.

.DESCRIPTION
    Generates a module manifest with version information and copies required files.
    Supports both automatic timestamp-based versioning and manual semantic versioning.

.PARAMETER Version
    Module version. If not specified, uses timestamp format (yyyy.MM.dd.HHmm).
    Can be semantic version like "1.0.0" or timestamp format.

.PARAMETER SkipReadme
    Skip copying README.md to the module directory.

.PARAMETER SkipHelp
    Skip building help files for the module.

.EXAMPLE
    .\build.ps1
    Builds with automatic timestamp version.

.EXAMPLE
    .\build.ps1 -Version "1.0.0"
    Builds with specific semantic version.

.EXAMPLE
    .\build.ps1 -Version "2025.10.09.1622" -Verbose
    Builds with specific timestamp version and verbose output.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidatePattern('^\d+\.\d+(\.\d+)?(\.\d+)?$')]
    [string]$Version = (Get-Date).ToString("yyyy.MM.dd.HHmm"),

    [switch]$SkipReadme,

    [switch]$SkipHelp
)

$ErrorActionPreference = 'Stop'

# Validate paths
$modulePath = "./ColorScripts-Enhanced"
$manifestPath = Join-Path $modulePath "ColorScripts-Enhanced.psd1"
$readmePath = "./README.md"
$scriptsPath = Join-Path $modulePath "Scripts"

Write-Verbose "Building module version: $Version"
Write-Verbose "Module path: $modulePath"

# Ensure module directory exists
if (-not (Test-Path $modulePath)) {
    throw "Module directory not found: $modulePath"
}

# Count colorscripts
$scriptCount = 0
if (Test-Path $scriptsPath) {
    $scriptCount = (Get-ChildItem -Path $scriptsPath -Filter "*.ps1" -File).Count
    Write-Verbose "Found $scriptCount colorscripts"
}
else {
    Write-Warning "Scripts directory not found: $scriptsPath"
}

# Update documentation markers to reflect the current script count before copying
$updateDocsScript = Join-Path -Path $PSScriptRoot -ChildPath 'Update-DocumentationCounts.ps1'
if (Test-Path -Path $updateDocsScript) {
    try {
        Write-Verbose "Refreshing documentation script counts"
        & $updateDocsScript -ScriptCount $scriptCount | Out-Null
    }
    catch {
        Write-Warning "Failed to refresh documentation counts: $_"
    }
}
else {
    Write-Verbose "Documentation count updater not found at: $updateDocsScript"
}

# Copy README if it exists and not skipped
if (-not $SkipReadme) {
    if (Test-Path $readmePath) {
        try {
            Copy-Item -Path $readmePath -Destination (Join-Path $modulePath "README.md") -Force
            Write-Verbose "README.md copied successfully"
        }
        catch {
            Write-Warning "Failed to copy README.md: $_"
        }
    }
    else {
        Write-Warning "README.md not found at: $readmePath"
    }
}

# Remove existing manifest
if (Test-Path $manifestPath) {
    try {
        Remove-Item -Path $manifestPath -Force
        Write-Verbose "Removed existing manifest"
    }
    catch {
        Write-Warning "Failed to remove existing manifest: $_"
    }
}

# Create manifest parameters
$functionsToExport = @(
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

$manifestParams = @{
    ModuleVersion         = $Version
    Path                  = $manifestPath
    Guid                  = "f77548d7-23eb-48ce-a6e0-f64b4758d995"
    Author                = "Nick"
    CompanyName           = "Community"
    Copyright             = "(c) 2025. All rights reserved."
    RootModule            = "ColorScripts-Enhanced.psm1"
    CompatiblePSEditions  = @("Desktop", "Core")
    PowerShellVersion     = "5.1"
    ProcessorArchitecture = "None"
    FunctionsToExport     = $functionsToExport
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @("scs")
    Description           = @'
Enhanced PowerShell ColorScripts with high-performance caching system. Display beautiful ANSI art in your terminal with 6-19x faster load times.

Features:
• 245+ beautiful colorscripts - Extensive collection of ANSI art
• Intelligent Caching - 6-19x performance improvement (5-20ms load times)
• OS-Wide Cache - Consistent caching across all terminal sessions
• Simple API - Easy-to-use cmdlets with tab completion
• Configurable Defaults - Persist cache locations and startup behaviour
• Auto-Update - Cache automatically invalidates when scripts change
• Centralized Storage - Cache stored in AppData/ColorScripts-Enhanced/cache
• Cross-platform - Works on Windows, Linux, and macOS
• PowerShell 5.1+ and PowerShell Core 7+ compatible

Quick Start: Show-ColorScript (or alias: scs)
Full documentation: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
'@
    ProjectUri            = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced"
    IconUri               = "https://raw.githubusercontent.com/Nick2bad4u/ps-color-scripts-enhanced/main/docs/colorscripts-icon.png"
    Tags                  = @("ColorScripts", "ANSI", "Terminal", "Art", "Cache", "Performance", "PowerShell", "Startup", "Terminal-Startup", "ANSI-Art", "Colorful-Terminal", "PowerShell-Art", "Fancy-Terminal", "Terminal-Enhancement", "Beautiful-Terminal", "Terminal-Colors", "PowerShell-Scripts", "Terminal-Art", "Colorful-Scripts", "Enhanced-Terminal", "Terminal-Visuals", "PowerShell-Module", "Colorful-Output", "Terminal-Themes", "PSEdition_Desktop", "PSEdition_Core", "Windows", "Linux", "MacOS")
    FileList              = @(
        "ColorScripts-Enhanced.psm1",
        "ColorScripts-Enhanced.psd1",
        "README.md",
        "ScriptMetadata.psd1",
        "Install.ps1"
    )
    HelpInfoUri           = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/README.md"
    ReleaseNotes          = @"
Version ${Version}:
    - Enhanced caching system with OS-wide cache in AppData
    - 6-19x performance improvement
    - Cache stored in centralized location
    - Works from any directory
    - $scriptCount beautiful colorscripts included
    - Full comment-based help documentation
    - Scripts optimized for performance and visual quality
    - Cross-platform support (Windows, Linux, macOS)
    - PowerShell 5.1+ and PowerShell Core 7+ compatible
"@
    PassThru              = $true
}

# Create the manifest
try {
    $manifest = New-ModuleManifest @manifestParams
    Write-Host "✓ Module manifest created successfully" -ForegroundColor Green
    Write-Host "  Version: $Version" -ForegroundColor Cyan
    Write-Host "  Path: $manifestPath" -ForegroundColor Cyan

    # Reformat manifest for consistent indentation and style expected by PSScriptAnalyzer
    $generatedOn = (Get-Date).ToString('M/d/yyyy')
    $projectUri = $manifestParams.ProjectUri
    $tagIndent = ' ' * 16
    $tagsBlock = ($manifestParams.Tags | ForEach-Object { "$tagIndent'$_'" }) -join [Environment]::NewLine
    $functionIndent = ' ' * 8
    $functionsBlock = ($functionsToExport | ForEach-Object { "$functionIndent'$_'" }) -join [Environment]::NewLine
    $releaseNotes = @"
Version ${Version}:
- Enhanced caching system with OS-wide cache in AppData
- 6-19x performance improvement
- Cache stored in centralized location
- Works from any directory
- $scriptCount beautiful colorscripts included
- Full comment-based help documentation
- Scripts optimized for performance and visual quality
- Cross-platform support (Windows, Linux, macOS)
- PowerShell 5.1+ and PowerShell Core 7+ compatible
"@

    $manifestContent = @"
#
# Module manifest for module 'ColorScripts-Enhanced'
#
# Generated by: Nick2bad4u
#
# Generated on: $generatedOn
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'ColorScripts-Enhanced.psm1'

    # Version number of this module.
    ModuleVersion = '$Version'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = 'f77548d7-23eb-48ce-a6e0-f64b4758d995'

    # Author of this module
    Author = 'Nick2bad4u'

    # Company or vendor of this module
    CompanyName = 'Community'

    # Copyright statement for this module
    Copyright = '(c) 2025. All rights reserved.'

    # Description of the functionality provided by this module
    Description = @'
Enhanced PowerShell ColorScripts with high-performance caching system. Display beautiful ANSI art in your terminal with 6-19x faster load times.

Features:
• 245+ beautiful colorscripts - Extensive collection of ANSI art
• Intelligent Caching - 6-19x performance improvement (5-20ms load times)
• OS-Wide Cache - Consistent caching across all terminal sessions
• Simple API - Easy-to-use cmdlets with tab completion
• Configurable Defaults - Persist cache locations and startup behaviour
• Auto-Update - Cache automatically invalidates when scripts change
• Centralized Storage - Cache stored in AppData/ColorScripts-Enhanced/cache
• Cross-platform - Works on Windows, Linux, and macOS
• PowerShell 5.1+ and PowerShell Core 7+ compatible

Quick Start: Show-ColorScript (or alias: scs)
Full documentation: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
'@

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
$functionsBlock
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @('scs')

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList = @(
        'ColorScripts-Enhanced.psm1'
        'ColorScripts-Enhanced.psd1'
        'README.md'
        'ScriptMetadata.psd1'
        'Install.ps1'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
$tagsBlock
            )

            # A URL to the license for this module.
            LicenseUri = 'https://licenses.nuget.org/MIT'

            # License expression or path to license file
            License = 'MIT'

            # A URL to the main website for this project.
            ProjectUri = '$projectUri'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/Nick2bad4u/ps-color-scripts-enhanced/main/docs/colorscripts-icon.png'

            # ReleaseNotes of this module
            ReleaseNotes = @'
$($releaseNotes.TrimEnd())
'@

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = `$false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }

    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/README.md'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
"@

    Set-Content -Path $manifestPath -Value $manifestContent -Encoding UTF8

    # Validate the formatted manifest
    Test-ModuleManifest -Path $manifestPath -ErrorAction Stop | Out-Null
    Write-Host "✓ Manifest validation passed" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create or validate manifest: $_"
    exit 1
}

# Build help files if not skipped
if (-not $SkipHelp) {
    Write-Verbose "Building help files..."

    # Check if PlatyPS is installed
    if (-not (Get-Module -ListAvailable -Name platyPS)) {
        Write-Host "Installing platyPS module..." -ForegroundColor Yellow
        try {
            # Save current execution policy
            $currentPolicy = Get-ExecutionPolicy -Scope Process

            # Temporarily set execution policy for installation
            Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

            # Install with SkipPublisherCheck to handle unsigned modules
            Install-Module -Name platyPS -Force -SkipPublisherCheck -Scope CurrentUser
            Write-Host "✓ platyPS installed successfully" -ForegroundColor Green

            # Restore execution policy
            Set-ExecutionPolicy -ExecutionPolicy $currentPolicy -Scope Process -Force
        }
        catch {
            Write-Warning "Failed to install platyPS: $_"
            Write-Host "Skipping help file generation" -ForegroundColor Yellow
            exit 0
        }
    }

    # Run Build-Help.ps1 if it exists
    $buildHelpPath = Join-Path $PSScriptRoot "Build-Help.ps1"
    if (Test-Path $buildHelpPath) {
        try {
            & $buildHelpPath
            Write-Host "✓ Help files built successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to build help files: $_"
        }
    }
    else {
        Write-Warning "Build-Help.ps1 not found at: $buildHelpPath"
    }
}
