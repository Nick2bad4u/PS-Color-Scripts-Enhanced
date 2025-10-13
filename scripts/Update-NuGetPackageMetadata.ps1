<#
.SYNOPSIS
    Normalize NuGet package metadata to satisfy PowerShell Gallery and NuGet.org requirements.

.DESCRIPTION
    Ensures the generated .nupkg contains embedded README, license, and icon assets while updating the
    .nuspec metadata to use the modern <readme>, <license>, and <icon> elements. For PowerShell Gallery,
    uses a condensed README to stay within the 8KB limit. For NuGet.org, uses the full README.

.PARAMETER PackagePath
    Path to the .nupkg produced by Publish-Module.

.PARAMETER RepositoryRoot
    Optionally override the repository root that contains README.md, LICENSE, and docs/colorscripts-icon.png.

.PARAMETER Gallery
    Target gallery: 'PSGallery' (uses README-Gallery.md) or 'NuGet' (uses README.md). Default is 'PSGallery'.

.NOTES
    Requires PowerShell 5.1+ with System.IO.Compression.FileSystem available.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$PackagePath,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$RepositoryRoot = (Split-Path -Parent (Split-Path -Parent $PSCommandPath)),

    [Parameter()]
    [ValidateSet('PSGallery', 'NuGet')]
    [string]$Gallery = 'PSGallery'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $PackagePath)) {
    throw "Package not found: $PackagePath"
}

$packageFull = (Resolve-Path -LiteralPath $PackagePath).ProviderPath
$repoRootFull = (Resolve-Path -LiteralPath $RepositoryRoot).ProviderPath

# Choose README based on target gallery
if ($Gallery -eq 'PSGallery') {
    $readmeSource = Join-Path $repoRootFull 'ColorScripts-Enhanced\README-Gallery.md'
    Write-Verbose "Using condensed README for PowerShell Gallery: $readmeSource"
}
else {
    $readmeSource = Join-Path $repoRootFull 'README.md'
    Write-Verbose "Using full README for NuGet.org: $readmeSource"
}

$licenseSource = Join-Path $repoRootFull 'LICENSE'
$iconSource = Join-Path $repoRootFull 'docs\colorscripts-icon.png'

foreach ($source in @($readmeSource, $licenseSource, $iconSource)) {
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Required asset not found: $source"
    }
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

function Add-OrReplaceArchiveEntry {
    param(
        [Parameter(Mandatory)][System.IO.Compression.ZipArchive]$Archive,
        [Parameter(Mandatory)][string]$EntryName,
        [Parameter(Mandatory)][string]$SourcePath
    )

    $existing = $Archive.GetEntry($EntryName)
    if ($existing) {
        $existing.Delete()
    }

    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $Archive,
        $SourcePath,
        $EntryName,
        [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
}

$archive = [System.IO.Compression.ZipFile]::Open($packageFull, [System.IO.Compression.ZipArchiveMode]::Update)
try {
    Add-OrReplaceArchiveEntry -Archive $archive -EntryName 'README.md' -SourcePath $readmeSource
    Add-OrReplaceArchiveEntry -Archive $archive -EntryName 'LICENSE' -SourcePath $licenseSource
    Add-OrReplaceArchiveEntry -Archive $archive -EntryName 'icon.png' -SourcePath $iconSource

    # Provide easy access for module consumers inside the module folder as well
    Add-OrReplaceArchiveEntry -Archive $archive -EntryName 'ColorScripts-Enhanced/LICENSE' -SourcePath $licenseSource
    Add-OrReplaceArchiveEntry -Archive $archive -EntryName 'ColorScripts-Enhanced/icon.png' -SourcePath $iconSource

    $nuspecEntry = $archive.Entries | Where-Object { $_.FullName -like '*.nuspec' } | Select-Object -First 1
    if (-not $nuspecEntry) {
        throw 'Unable to locate .nuspec inside package.'
    }

    $readStream = $nuspecEntry.Open()
    try {
        $reader = New-Object System.IO.StreamReader($readStream, [System.Text.Encoding]::UTF8, $false, 1024, $true)
        $nuspecContent = $reader.ReadToEnd()
        $reader.Dispose()
    }
    finally {
        $readStream.Dispose()
    }

    $xml = New-Object System.Xml.XmlDocument
    $xml.PreserveWhitespace = $true
    $xml.LoadXml($nuspecContent)

    $namespaceUri = $xml.DocumentElement.NamespaceURI
    $nsMgr = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $nsMgr.AddNamespace('ns', $namespaceUri)

    $metadataNode = $xml.SelectSingleNode('/ns:package/ns:metadata', $nsMgr)
    if (-not $metadataNode) {
        throw 'nuspec metadata node not found.'
    }

    function Get-OrCreateNode {
        param(
            [System.Xml.XmlNode]$Parent,
            [string]$Name,
            [System.Xml.XmlNamespaceManager]$Manager,
            [string]$NamespaceUri
        )

        $node = $Parent.SelectSingleNode("ns:$Name", $Manager)
        if (-not $node) {
            $node = $Parent.OwnerDocument.CreateElement($Name, $NamespaceUri)
            [void]$Parent.AppendChild($node)
        }
        return $node
    }

    $licenseNode = Get-OrCreateNode -Parent $metadataNode -Name 'license' -Manager $nsMgr -NamespaceUri $namespaceUri
    $licenseNode.InnerText = 'MIT'
    $licenseNode.SetAttribute('type', 'expression')

    $licenseUrlNode = Get-OrCreateNode -Parent $metadataNode -Name 'licenseUrl' -Manager $nsMgr -NamespaceUri $namespaceUri
    $licenseUrlNode.InnerText = 'https://licenses.nuget.org/MIT'

    $iconNode = Get-OrCreateNode -Parent $metadataNode -Name 'icon' -Manager $nsMgr -NamespaceUri $namespaceUri
    $iconNode.InnerText = 'icon.png'

    $readmeNode = Get-OrCreateNode -Parent $metadataNode -Name 'readme' -Manager $nsMgr -NamespaceUri $namespaceUri
    $readmeNode.InnerText = 'README.md'

    foreach ($deprecated in 'iconUrl') {
        $deprecatedNode = $metadataNode.SelectSingleNode("ns:$deprecated", $nsMgr)
        if ($deprecatedNode) {
            [void]$metadataNode.RemoveChild($deprecatedNode)
        }
    }

    $writeStream = $nuspecEntry.Open()
    try {
        $writeStream.SetLength(0)
        $writer = New-Object System.IO.StreamWriter($writeStream, [System.Text.Encoding]::UTF8, 4096, $true)
        try {
            $xml.Save($writer)
        }
        finally {
            $writer.Flush()
            $writer.Dispose()
        }
    }
    finally {
        $writeStream.Dispose()
    }
}
finally {
    $archive.Dispose()
}
