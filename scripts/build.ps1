<#
.SYNOPSIS
    Validate and assemble the ColorScripts-Enhanced module.

.DESCRIPTION
    Treats the checked-in module manifest as the authoritative package metadata,
    refreshes documentation counts, copies repository documentation into the
    module package, optionally updates ModuleVersion, and validates the result.
    The build never installs dependencies or changes execution policy.

.PARAMETER Version
    Optional module version to write to the checked-in manifest. When omitted,
    the existing ModuleVersion is preserved.

.PARAMETER SkipReadme
    Skip copying the root README and documentation tree into the module folder.

.PARAMETER SkipHelp
    Skip the external-help generation step.

.EXAMPLE
    .\scripts\build.ps1 -SkipHelp
    Builds the module without changing its version or generating external help.

.EXAMPLE
    .\scripts\build.ps1 -Version 1.2.3
    Updates only ModuleVersion, then performs the normal build validation.
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidatePattern('^\d+\.\d+(?:\.\d+)?(?:\.\d+)?$')]
    [string]$Version,

    [Parameter()]
    [switch]$SkipReadme,

    [Parameter()]
    [switch]$SkipHelp
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$utf8WithBom = New-Object System.Text.UTF8Encoding($true)
$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$modulePath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced'
$manifestPath = Join-Path -Path $modulePath -ChildPath 'ColorScripts-Enhanced.psd1'
$scriptsPath = Join-Path -Path $modulePath -ChildPath 'Scripts'

function Write-TextFileUtf8NoBom {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Content
    )

    [System.IO.File]::WriteAllText($LiteralPath, $Content, $utf8NoBom)
}

function Write-TextFileUtf8Bom {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Content
    )

    [System.IO.File]::WriteAllText($LiteralPath, $Content, $utf8WithBom)
}

function Update-DocRelativeLink {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    $content = [System.IO.File]::ReadAllText($LiteralPath)
    $updated = $content
    $updated = $updated -replace '\]\((\.\./)', '](../../'
    $updated = $updated -replace '(?m)(^\s*\[[^\]]+\]:\s*)(\.\./)', '$1../../'
    $updated = $updated -replace '(src\s*=\s*")\.\./', '$1../../'
    $updated = $updated -replace "(src\s*=\s*')\.\./", '$1../../'
    $updated = $updated -replace '(href\s*=\s*")\.\./', '$1../../'
    $updated = $updated -replace "(href\s*=\s*')\.\./", '$1../../'

    if ($updated -cne $content) {
        Write-TextFileUtf8NoBom -LiteralPath $LiteralPath -Content $updated
    }
}

function Update-PackagedReadmeLink {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath
    )

    $content = [System.IO.File]::ReadAllText($LiteralPath)
    $updated = $content
    $repositoryBlobBase = 'https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/'
    foreach ($repositoryPath in @(
            'LICENSE',
            'CONTRIBUTING.md',
            'CHANGELOG.md',
            'CODE_OF_CONDUCT.md',
            'SECURITY.md',
            '.github/workflows/test.yml',
            '.github/workflows/publish.yml')) {
        $updated = $updated.Replace("]($repositoryPath)", "]($repositoryBlobBase$repositoryPath)")
    }

    $mascotPath = 'assets/ColorScripts-Mascot-Dark.jpeg'
    $mascotUri = 'https://raw.githubusercontent.com/Nick2bad4u/PS-Color-Scripts-Enhanced/main/assets/ColorScripts-Mascot-Dark.jpeg'
    $updated = $updated.Replace("]($mascotPath)", "]($mascotUri)")
    $updated = $updated.Replace("src=`"$mascotPath`"", "src=`"$mascotUri`"")

    if ($updated -cne $content) {
        Write-TextFileUtf8NoBom -LiteralPath $LiteralPath -Content $updated
    }
}

function Copy-DocumentationTree {
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath -PathType Container)) {
        throw "Documentation directory not found: $SourcePath"
    }

    $destinationFullPath = [System.IO.Path]::GetFullPath($DestinationPath).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)
    $expectedDestination = [System.IO.Path]::GetFullPath(
        (Join-Path -Path $modulePath -ChildPath 'docs')).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)
    $pathComparison = if ([System.IO.Path]::DirectorySeparatorChar -eq '\') {
        [System.StringComparison]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparison]::Ordinal
    }
    if (-not $destinationFullPath.Equals($expectedDestination, $pathComparison)) {
        throw "Refusing to replace unexpected documentation destination: $destinationFullPath"
    }

    if (Test-Path -LiteralPath $destinationFullPath -PathType Container) {
        Remove-Item -LiteralPath $destinationFullPath -Recurse -Force -ErrorAction Stop
    }
    New-Item -ItemType Directory -Path $destinationFullPath -Force -ErrorAction Stop | Out-Null

    $sourceResolved = (Resolve-Path -LiteralPath $SourcePath -ErrorAction Stop).ProviderPath.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar)

    foreach ($sourceFile in Get-ChildItem -LiteralPath $sourceResolved -Recurse -File) {
        # Agent instruction files configure repository tooling and are not
        # end-user module documentation.
        if ($sourceFile.Name -ieq 'AGENTS.md') {
            continue
        }

        $relativePath = $sourceFile.FullName.Substring($sourceResolved.Length).TrimStart(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar)
        $targetPath = Join-Path -Path $destinationFullPath -ChildPath $relativePath
        $targetDirectory = Split-Path -Path $targetPath -Parent

        if (-not (Test-Path -LiteralPath $targetDirectory -PathType Container)) {
            New-Item -ItemType Directory -Path $targetDirectory -Force -ErrorAction Stop | Out-Null
        }

        Copy-Item -LiteralPath $sourceFile.FullName -Destination $targetPath -Force -ErrorAction Stop
        if ($sourceFile.Extension -ieq '.md') {
            Update-DocRelativeLink -LiteralPath $targetPath
        }
    }
}

function Set-ManifestModuleVersion {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [Parameter(Mandatory)]
        [string]$NewVersion
    )

    $content = [System.IO.File]::ReadAllText($LiteralPath)
    $pattern = "(?m)^(?<prefix>\s*ModuleVersion\s*=\s*)'[^']+'(?<suffix>\s*(?:#.*)?)$"
    $versionMatches = [regex]::Matches($content, $pattern)
    if ($versionMatches.Count -ne 1) {
        throw "Expected exactly one single-quoted ModuleVersion entry in '$LiteralPath'; found $($versionMatches.Count)."
    }

    $updated = [regex]::Replace(
        $content,
        $pattern,
        ('$1''' + $NewVersion + '''$2'))
    # The manifest contains non-ASCII metadata and must remain readable by
    # Windows PowerShell 5.1, which requires a BOM for UTF-8 source files.
    Write-TextFileUtf8Bom -LiteralPath $LiteralPath -Content $updated
}

if (-not (Test-Path -LiteralPath $modulePath -PathType Container)) {
    throw "Module directory not found: $modulePath"
}
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Module manifest not found: $manifestPath"
}
if (-not (Test-Path -LiteralPath $scriptsPath -PathType Container)) {
    throw "Colorscript directory not found: $scriptsPath"
}

$existingManifest = Import-PowerShellDataFile -Path $manifestPath -ErrorAction Stop
$effectiveVersion = if ($PSBoundParameters.ContainsKey('Version')) {
    Set-ManifestModuleVersion -LiteralPath $manifestPath -NewVersion $Version
    $Version
}
else {
    [string]$existingManifest.ModuleVersion
}

$scriptCount = @(Get-ChildItem -LiteralPath $scriptsPath -Filter '*.ps1' -File).Count
$updateDocsScript = Join-Path -Path $PSScriptRoot -ChildPath 'Update-DocumentationCounts.ps1'
if (-not (Test-Path -LiteralPath $updateDocsScript -PathType Leaf)) {
    throw "Documentation count updater not found: $updateDocsScript"
}
& $updateDocsScript -ScriptCount $scriptCount

if (-not $SkipReadme) {
    $readmePath = Join-Path -Path $repoRoot -ChildPath 'README.md'
    $moduleReadmePath = Join-Path -Path $modulePath -ChildPath 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath -PathType Leaf)) {
        throw "Repository README not found: $readmePath"
    }
    Copy-Item -LiteralPath $readmePath -Destination $moduleReadmePath -Force -ErrorAction Stop
    Update-PackagedReadmeLink -LiteralPath $moduleReadmePath

    Copy-DocumentationTree `
        -SourcePath (Join-Path -Path $repoRoot -ChildPath 'docs') `
        -DestinationPath (Join-Path -Path $modulePath -ChildPath 'docs')
}

$validatedManifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop
if ([string]$validatedManifest.Version -ne $effectiveVersion) {
    throw "Manifest validation returned version '$($validatedManifest.Version)' instead of '$effectiveVersion'."
}

if (-not $SkipHelp) {
    $buildHelpPath = Join-Path -Path $PSScriptRoot -ChildPath 'Build-Help.ps1'
    if (-not (Test-Path -LiteralPath $buildHelpPath -PathType Leaf)) {
        throw "Help builder not found: $buildHelpPath"
    }
    & $buildHelpPath -UpdateMarkdown
}

Write-Host 'Module build validation passed.' -ForegroundColor Green
Write-Host "  Version:      $effectiveVersion" -ForegroundColor Cyan
Write-Host "  Colorscripts: $scriptCount" -ForegroundColor Cyan
Write-Host "  Manifest:     $manifestPath" -ForegroundColor Cyan
