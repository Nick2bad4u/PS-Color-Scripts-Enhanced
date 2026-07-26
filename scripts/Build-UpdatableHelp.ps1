<#
.SYNOPSIS
    Builds deterministic Updatable Help artifacts across platforms.

.DESCRIPTION
    Creates one HelpInfo XML document and one ZIP package per configured
    culture. When makecab.exe is available, it also creates one CAB package per
    culture. Package entries are ordered and timestamped from the pinned
    Help.Build.psd1 configuration. Use -Check to rebuild in isolation and
    compare the result with the checked-in publication directory. On platforms
    without makecab.exe, expected CAB files are preserved, obsolete
    culture-named CAB files are removed, and CAB bytes are ignored during
    comparison because they cannot be regenerated there.
#>
#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [string]$ModulePath,

    [Parameter()]
    [string]$ConfigurationPath,

    [Parameter()]
    [string]$OutputPath,

    [Parameter()]
    [switch]$Check,

    [Parameter()]
    [switch]$SkipCabinet
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
if (-not $ModulePath) {
    $ModulePath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced'
}
if (-not $ConfigurationPath) {
    $ConfigurationPath = Join-Path -Path $repoRoot -ChildPath 'Help.Build.psd1'
}
if (-not $OutputPath) {
    $OutputPath = Join-Path -Path $repoRoot -ChildPath 'docs/ColorScripts-Enhanced'
}

$ModulePath = (Get-Item -LiteralPath $ModulePath -ErrorAction Stop).FullName
$ConfigurationPath = (Get-Item -LiteralPath $ConfigurationPath -ErrorAction Stop).FullName
$configuration = Import-PowerShellDataFile -LiteralPath $ConfigurationPath
if ($configuration.SchemaVersion -ne 1) {
    throw "Unsupported help build configuration schema '$($configuration.SchemaVersion)'."
}

$moduleName = [string]$configuration.Module.Name
$moduleGuid = [guid][string]$configuration.Module.Guid
$helpVersion = [version][string]$configuration.Module.HelpVersion
$helpInfoUri = [uri][string]$configuration.Module.HelpInfoUri
$cultures = @($configuration.Cultures)
$sourceDate = [datetimeoffset]::Parse(
    [string]$configuration.SourceDateUtc,
    [cultureinfo]::InvariantCulture,
    [Globalization.DateTimeStyles]::AssumeUniversal
).ToUniversalTime()

if (-not $helpInfoUri.IsAbsoluteUri -or $helpInfoUri.Scheme -ne 'https' -or
    -not $helpInfoUri.AbsoluteUri.EndsWith('/')) {
    throw 'HelpInfoUri must be an absolute HTTPS directory URI.'
}
if ($sourceDate.Year -lt 1980 -or $sourceDate.Offset -ne [timespan]::Zero) {
    throw 'SourceDateUtc must be a UTC timestamp in 1980 or later.'
}
if ($cultures.Count -eq 0 -or
    @($cultures | Sort-Object -Unique).Count -ne $cultures.Count) {
    throw 'The help build must declare at least one unique culture.'
}

$manifestPath = Join-Path -Path $ModulePath -ChildPath "$moduleName.psd1"
$manifest = Import-PowerShellDataFile -LiteralPath $manifestPath
if ([string]$manifest.Guid -cne $moduleGuid.ToString() -or
    [string]$manifest.HelpInfoURI -cne $helpInfoUri.AbsoluteUri) {
    throw "Module manifest identity or HelpInfoURI does not match '$ConfigurationPath'."
}

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)][string]$LiteralPath,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($LiteralPath, $Content, $encoding)
}

function New-HelpInfoContent {
    $cultureElements = foreach ($culture in $cultures) {
        @"
    <UICulture>
      <UICultureName>$culture</UICultureName>
      <UICultureVersion>$helpVersion</UICultureVersion>
    </UICulture>
"@
    }

    return @"
<?xml version="1.0" encoding="utf-8"?>
<HelpInfo xmlns="http://schemas.microsoft.com/powershell/help/2010/05">
  <HelpContentURI>$($helpInfoUri.AbsoluteUri)</HelpContentURI>
  <SupportedUICultures>
$($cultureElements -join "`r`n")
  </SupportedUICultures>
</HelpInfo>
"@
}

$crc32Polynomial = [uint32]::Parse('EDB88320', [Globalization.NumberStyles]::HexNumber)
$crc32Table = [uint32[]]::new(256)
for ($tableIndex = 0; $tableIndex -lt $crc32Table.Length; $tableIndex++) {
    [uint32]$tableValue = $tableIndex
    for ($bitIndex = 0; $bitIndex -lt 8; $bitIndex++) {
        if (($tableValue -band 1) -eq 1) {
            $tableValue = [uint32]::Parse(
                ('{0:X8}' -f ($crc32Polynomial -bxor ($tableValue -shr 1))),
                [Globalization.NumberStyles]::HexNumber
            )
        }
        else {
            $tableValue = $tableValue -shr 1
        }
    }
    $crc32Table[$tableIndex] = $tableValue
}

function Get-Crc32 {
    param([Parameter(Mandatory)][byte[]]$Bytes)

    [uint32]$crc = [uint32]::MaxValue
    foreach ($byte in $Bytes) {
        $lookupIndex = ($crc -bxor $byte) -band 0xFF
        $crc = ($crc -shr 8) -bxor $crc32Table[$lookupIndex]
    }
    return [uint32]::Parse(
        ('{0:X8}' -f (-bnot $crc)),
        [Globalization.NumberStyles]::HexNumber
    )
}

function ConvertTo-DosTimestamp {
    param([Parameter(Mandatory)][datetimeoffset]$Timestamp)

    $value = $Timestamp.UtcDateTime
    return [pscustomobject]@{
        Date = [uint16]((($value.Year - 1980) -shl 9) -bor ($value.Month -shl 5) -bor $value.Day)
        Time = [uint16](($value.Hour -shl 11) -bor ($value.Minute -shl 5) -bor [math]::Floor($value.Second / 2))
    }
}

function New-DeterministicZip {
    param(
        [Parameter(Mandatory)][System.IO.FileInfo[]]$SourceFiles,
        [Parameter(Mandatory)][string]$DestinationPath
    )

    # ZipArchive maps NoCompression to different methods on .NET Framework and
    # modern .NET. Write the small ZIP32/store format directly so PowerShell 5.1
    # and PowerShell 7 produce identical release bytes.
    $stream = [System.IO.File]::Open(
        $DestinationPath,
        [System.IO.FileMode]::Create,
        [System.IO.FileAccess]::Write,
        [System.IO.FileShare]::None
    )
    $writer = New-Object System.IO.BinaryWriter(
        $stream,
        (New-Object System.Text.UTF8Encoding($false)),
        $false
    )
    try {
        $timestamp = ConvertTo-DosTimestamp -Timestamp $sourceDate
        $entries = New-Object 'System.Collections.Generic.List[object]'
        foreach ($file in $SourceFiles | Sort-Object -Property Name) {
            [byte[]]$nameBytes = [System.Text.Encoding]::UTF8.GetBytes($file.Name)
            [byte[]]$contentBytes = [System.IO.File]::ReadAllBytes($file.FullName)
            if ($contentBytes.LongLength -gt [uint32]::MaxValue -or
                $stream.Position -gt [uint32]::MaxValue) {
                throw "ZIP32 limits were exceeded while packaging '$($file.FullName)'."
            }
            $entry = [pscustomobject]@{
                NameBytes   = $nameBytes
                Content     = $contentBytes
                Crc32       = Get-Crc32 -Bytes $contentBytes
                LocalOffset = [uint32]$stream.Position
            }
            [void]$entries.Add($entry)

            $writer.Write([uint32]0x04034B50)
            $writer.Write([uint16]20)
            $writer.Write([uint16]0x0800)
            $writer.Write([uint16]0)
            $writer.Write($timestamp.Time)
            $writer.Write($timestamp.Date)
            $writer.Write([uint32]$entry.Crc32)
            $writer.Write([uint32]$contentBytes.Length)
            $writer.Write([uint32]$contentBytes.Length)
            $writer.Write([uint16]$nameBytes.Length)
            $writer.Write([uint16]0)
            $writer.Write($nameBytes)
            $writer.Write($contentBytes)
        }

        [uint32]$centralDirectoryOffset = $stream.Position
        foreach ($entry in $entries) {
            $writer.Write([uint32]0x02014B50)
            $writer.Write([uint16]20)
            $writer.Write([uint16]20)
            $writer.Write([uint16]0x0800)
            $writer.Write([uint16]0)
            $writer.Write($timestamp.Time)
            $writer.Write($timestamp.Date)
            $writer.Write([uint32]$entry.Crc32)
            $writer.Write([uint32]$entry.Content.Length)
            $writer.Write([uint32]$entry.Content.Length)
            $writer.Write([uint16]$entry.NameBytes.Length)
            $writer.Write([uint16]0)
            $writer.Write([uint16]0)
            $writer.Write([uint16]0)
            $writer.Write([uint16]0)
            $writer.Write([uint32]0)
            $writer.Write([uint32]$entry.LocalOffset)
            $writer.Write([byte[]]$entry.NameBytes)
        }

        [uint32]$centralDirectorySize = $stream.Position - $centralDirectoryOffset
        $writer.Write([uint32]0x06054B50)
        $writer.Write([uint16]0)
        $writer.Write([uint16]0)
        $writer.Write([uint16]$entries.Count)
        $writer.Write([uint16]$entries.Count)
        $writer.Write($centralDirectorySize)
        $writer.Write($centralDirectoryOffset)
        $writer.Write([uint16]0)
    }
    finally {
        $writer.Dispose()
    }
}

function New-DeterministicCabinet {
    param(
        [Parameter(Mandatory)][System.IO.FileInfo[]]$SourceFiles,
        [Parameter(Mandatory)][string]$DestinationPath,
        [Parameter(Mandatory)][string]$WorkingPath
    )

    $makeCab = Get-Command -Name makecab.exe -CommandType Application -ErrorAction Stop
    $stagePath = Join-Path -Path $WorkingPath -ChildPath 'cab-stage'
    New-Item -ItemType Directory -Path $stagePath -Force | Out-Null

    $directiveLines = New-Object 'System.Collections.Generic.List[string]'
    [void]$directiveLines.Add('.Set Cabinet=ON')
    [void]$directiveLines.Add('.Set Compress=ON')
    [void]$directiveLines.Add('.Set CompressionType=MSZIP')
    [void]$directiveLines.Add('.Set CabinetNameTemplate=help.cab')
    [void]$directiveLines.Add('.Set DiskDirectoryTemplate=.')
    [void]$directiveLines.Add('.Set InfFileName=NUL')
    [void]$directiveLines.Add('.Set RptFileName=NUL')

    foreach ($file in $SourceFiles | Sort-Object -Property Name) {
        $stagedPath = Join-Path -Path $stagePath -ChildPath $file.Name
        Copy-Item -LiteralPath $file.FullName -Destination $stagedPath -Force
        (Get-Item -LiteralPath $stagedPath).LastWriteTimeUtc = $sourceDate.UtcDateTime
        [void]$directiveLines.Add(('"{0}" "{1}"' -f $stagedPath, $file.Name))
    }

    $directivePath = Join-Path -Path $WorkingPath -ChildPath 'help.ddf'
    Write-Utf8NoBom -LiteralPath $directivePath -Content (($directiveLines -join "`r`n") + "`r`n")
    Push-Location -LiteralPath $WorkingPath
    try {
        $makeCabOutput = & $makeCab.Source /F $directivePath 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "makecab.exe failed with exit code $LASTEXITCODE`: $($makeCabOutput -join [Environment]::NewLine)"
        }
    }
    finally {
        Pop-Location
    }

    $cabinetPath = Join-Path -Path $WorkingPath -ChildPath 'help.cab'
    if (-not (Test-Path -LiteralPath $cabinetPath -PathType Leaf)) {
        throw "makecab.exe did not create '$cabinetPath'."
    }
    Copy-Item -LiteralPath $cabinetPath -Destination $DestinationPath -Force
}

function Assert-MamlArtifact {
    param([Parameter(Mandatory)][string]$LiteralPath)

    $content = [System.IO.File]::ReadAllText($LiteralPath)
    if ($content.Contains('```') -or $content.Contains([char]0x80)) {
        throw "MAML artifact '$LiteralPath' contains an unnormalized fence or separator."
    }
    $document = [xml]$content
    $commandCount = @($document.SelectNodes(
            "//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"
        )).Count
    if ($commandCount -ne 10) {
        throw "MAML artifact '$LiteralPath' contains $commandCount commands; expected 10."
    }
    $emptyExampleCode = @($document.SelectNodes(
            "//*[local-name()='example']/*[local-name()='code' and namespace-uri()='http://schemas.microsoft.com/maml/dev/2004/10' and not(normalize-space())]"
        ))
    if ($emptyExampleCode.Count -gt 0) {
        throw "MAML artifact '$LiteralPath' contains $($emptyExampleCode.Count) examples without dev:code."
    }
}

function Get-CanonicalHelpSourceFiles {
    param(
        [Parameter(Mandatory)][System.IO.FileInfo[]]$SourceFiles,
        [Parameter(Mandatory)][string]$WorkingPath
    )

    New-Item -ItemType Directory -Path $WorkingPath -Force | Out-Null
    foreach ($file in $SourceFiles | Sort-Object -Property Name) {
        $canonicalContent = [System.IO.File]::ReadAllText($file.FullName) -replace "`r`n?", "`n"
        $canonicalPath = Join-Path -Path $WorkingPath -ChildPath $file.Name
        Write-Utf8NoBom -LiteralPath $canonicalPath -Content $canonicalContent
        (Get-Item -LiteralPath $canonicalPath).LastWriteTimeUtc = $sourceDate.UtcDateTime
        Get-Item -LiteralPath $canonicalPath
    }
}

function Compare-ArtifactDirectory {
    param(
        [Parameter(Mandatory)][string]$ExpectedPath,
        [Parameter(Mandatory)][string]$ActualPath,
        [Parameter()][string[]]$UnverifiedExpectedNames = @()
    )

    $expectedFiles = @(Get-ChildItem -LiteralPath $ExpectedPath -File | Sort-Object Name)
    $expectedNames = @($expectedFiles.Name) + @($UnverifiedExpectedNames)
    $actualFiles = @(Get-ChildItem -LiteralPath $ActualPath -File -ErrorAction SilentlyContinue | Sort-Object Name)
    $differences = Compare-Object `
        -ReferenceObject $expectedNames `
        -DifferenceObject $actualFiles.Name `
        -CaseSensitive
    if ($differences) {
        throw "Published Updatable Help file set is stale: $($differences | Out-String)"
    }
    foreach ($expectedFile in $expectedFiles) {
        $actualFile = Get-Item -LiteralPath (Join-Path -Path $ActualPath -ChildPath $expectedFile.Name)
        $expectedHash = (Get-FileHash -LiteralPath $expectedFile.FullName -Algorithm SHA256).Hash
        $actualHash = (Get-FileHash -LiteralPath $actualFile.FullName -Algorithm SHA256).Hash
        if ($expectedHash -cne $actualHash) {
            throw "Published Updatable Help artifact '$($expectedFile.Name)' is stale."
        }
    }
}

function Remove-StalePublishedHelpArtifact {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$LiteralPath,
        [Parameter(Mandatory)][string[]]$ExpectedNames,
        [Parameter()][string[]]$PreservedNames = @()
    )

    $fullOutputPath = [System.IO.Path]::GetFullPath($LiteralPath)
    $rootPath = [System.IO.Path]::GetPathRoot($fullOutputPath)
    $trimmedOutputPath = $fullOutputPath.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
    $trimmedRootPath = $rootPath.TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
    $pathComparison = if (
        [System.Environment]::OSVersion.Platform -eq [System.PlatformID]::Win32NT
    ) {
        [System.StringComparison]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparison]::Ordinal
    }
    if ([string]::Equals($trimmedOutputPath, $trimmedRootPath, $pathComparison)) {
        throw "Refusing to reconcile Updatable Help artifacts at filesystem root '$fullOutputPath'."
    }
    foreach ($protectedPath in @($repoRoot, $ModulePath)) {
        $trimmedProtectedPath = $protectedPath.TrimEnd(
            [System.IO.Path]::DirectorySeparatorChar,
            [System.IO.Path]::AltDirectorySeparatorChar
        )
        if ([string]::Equals($trimmedOutputPath, $trimmedProtectedPath, $pathComparison)) {
            throw "Refusing to reconcile Updatable Help artifacts at protected path '$fullOutputPath'."
        }
    }

    $expectedNameSet = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::Ordinal
    )
    foreach ($expectedName in @($ExpectedNames) + @($PreservedNames)) {
        [void]$expectedNameSet.Add($expectedName)
    }
    $escapedModuleName = [regex]::Escape($moduleName)
    $escapedModuleGuid = [regex]::Escape($moduleGuid.ToString())
    $managedNamePattern = '^{0}_{1}_(?:HelpInfo\.xml|[^\\/]+_HelpContent\.(?:zip|cab))$' -f (
        $escapedModuleName,
        $escapedModuleGuid
    )
    foreach ($publishedFile in Get-ChildItem -LiteralPath $fullOutputPath -File) {
        if ($expectedNameSet.Contains($publishedFile.Name) -or
            $publishedFile.Name -notmatch $managedNamePattern) {
            continue
        }
        if ($PSCmdlet.ShouldProcess($publishedFile.FullName, 'Remove stale Updatable Help artifact')) {
            Remove-Item -LiteralPath $publishedFile.FullName -Force
        }
    }
}

$makeCabCommand = Get-Command -Name makecab.exe -CommandType Application -ErrorAction SilentlyContinue
$includeCabinet = -not $SkipCabinet -and $null -ne $makeCabCommand
$expectedCabinetNames = @(
    foreach ($culture in $cultures) {
        '{0}_{1}_{2}_HelpContent.cab' -f $moduleName, $moduleGuid, $culture
    }
)
if (-not $SkipCabinet -and -not $includeCabinet) {
    Write-Verbose 'makecab.exe is unavailable; building and validating HelpInfo and ZIP artifacts only.'
}

$tempRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("colorscripts-updatable-help-{0}" -f [guid]::NewGuid())
$generatedPath = Join-Path -Path $tempRoot -ChildPath 'generated'
try {
    New-Item -ItemType Directory -Path $generatedPath -Force | Out-Null

    $helpInfoName = '{0}_{1}_HelpInfo.xml' -f $moduleName, $moduleGuid
    Write-Utf8NoBom `
        -LiteralPath (Join-Path -Path $generatedPath -ChildPath $helpInfoName) `
        -Content (New-HelpInfoContent)

    foreach ($culture in $cultures) {
        $culturePath = Join-Path -Path $ModulePath -ChildPath $culture
        $mamlPath = Join-Path -Path $culturePath -ChildPath "$moduleName-help.xml"
        $aboutPath = Join-Path -Path $culturePath -ChildPath "about_$moduleName.help.txt"
        foreach ($requiredPath in @($mamlPath, $aboutPath)) {
            if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
                throw "Updatable Help source '$requiredPath' was not found."
            }
        }
        Assert-MamlArtifact -LiteralPath $mamlPath
        $sourceFiles = @(
            Get-Item -LiteralPath $aboutPath
            Get-Item -LiteralPath $mamlPath
        )
        $sourceFiles = @(
            Get-CanonicalHelpSourceFiles `
                -SourceFiles $sourceFiles `
                -WorkingPath (Join-Path -Path $tempRoot -ChildPath "source-$culture")
        )

        $baseName = '{0}_{1}_{2}_HelpContent' -f $moduleName, $moduleGuid, $culture
        $zipPath = Join-Path -Path $generatedPath -ChildPath "$baseName.zip"
        New-DeterministicZip -SourceFiles $sourceFiles -DestinationPath $zipPath

        if ($includeCabinet) {
            $cabWorkPath = Join-Path -Path $tempRoot -ChildPath "cab-$culture"
            New-Item -ItemType Directory -Path $cabWorkPath -Force | Out-Null
            New-DeterministicCabinet `
                -SourceFiles $sourceFiles `
                -DestinationPath (Join-Path -Path $generatedPath -ChildPath "$baseName.cab") `
                -WorkingPath $cabWorkPath
        }
    }

    if ($Check) {
        if (-not (Test-Path -LiteralPath $OutputPath -PathType Container)) {
            throw "Published Updatable Help directory '$OutputPath' was not found."
        }
        $comparisonParameters = @{
            ExpectedPath = $generatedPath
            ActualPath   = $OutputPath
        }
        if (-not $includeCabinet) {
            $comparisonParameters.UnverifiedExpectedNames = $expectedCabinetNames
        }
        Compare-ArtifactDirectory @comparisonParameters
        Write-Host 'Updatable Help artifacts are current and byte-stable.' -ForegroundColor Green
    }
    elseif ($PSCmdlet.ShouldProcess($OutputPath, 'Publish deterministic Updatable Help artifacts')) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        $generatedFiles = @(Get-ChildItem -LiteralPath $generatedPath -File)
        Remove-StalePublishedHelpArtifact `
            -LiteralPath $OutputPath `
            -ExpectedNames @($generatedFiles.Name) `
            -PreservedNames $(if ($includeCabinet) { @() } else { $expectedCabinetNames }) `
            -Confirm:$false
        foreach ($file in $generatedFiles) {
            Copy-Item -LiteralPath $file.FullName -Destination (Join-Path -Path $OutputPath -ChildPath $file.Name) -Force
        }
        $comparisonParameters = @{
            ExpectedPath = $generatedPath
            ActualPath   = $OutputPath
        }
        if (-not $includeCabinet) {
            $comparisonParameters.UnverifiedExpectedNames = $expectedCabinetNames
        }
        Compare-ArtifactDirectory @comparisonParameters
        Write-Host "Published Updatable Help artifacts to '$OutputPath'." -ForegroundColor Green
    }
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
