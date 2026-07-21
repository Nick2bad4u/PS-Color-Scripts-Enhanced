<#
.SYNOPSIS
    Analyzes unused ANSI files to identify those with normal terminal sizes.

.DESCRIPTION
    Scans the unused-ansi-files folder to find ANSI art files that are already within
    normal terminal dimensions (width ≤ 120 columns, height ≤ 50 lines). Uses similar
    logic to the Convert-AnsiToColorScript.js for size calculations.

    The script:
    - Reads each ANSI file using CP437 encoding
    - Calculates actual terminal dimensions (visible characters, ignoring ANSI codes)
    - Identifies files that fit within "normal" terminal sizes
    - Optionally copies suitable files to a different location

.PARAMETER UnusedAnsiPath
    Path to the unused-ansi-files folder. Defaults to assets\unused-ansi-files.

.PARAMETER MaxWidth
    Maximum terminal width considered "normal". Default is 120 columns.

.PARAMETER MaxHeight
    Maximum terminal height considered "normal". Default is 50 lines.

.PARAMETER OutputCsv
    Optional path to save results as CSV file.

.PARAMETER CopyToFolder
    Optional folder to copy files that meet the criteria.

.PARAMETER ShowDetails
    Show detailed information for each file analyzed.

.PARAMETER ShowSummary
    Show a summary of results when specified.

.PARAMETER ConvertToScripts
    Automatically convert normal-sized files to PowerShell ColorScripts using Convert-AnsiToColorScript.js.

.PARAMETER ConvertOutputDir
    Directory where converted PowerShell scripts will be saved. Defaults to .\ColorScripts-Enhanced\Scripts.

.PARAMETER StripSpaceBackground
    When converting, strip background color from plain space characters.

.PARAMETER ExcludeRegularAscii
    Exclude files that contain only regular ASCII characters (0-127) without extended ASCII or ANSI escape sequences.

.PARAMETER AsciiCharLimit
    Exclude files where visible text characters exceed this limit.
    Use with -ExcludeRegularAscii to filter text-heavy files.
    - Set to 0: Exclude any file with visible text but little/no extended ASCII art
    - Set to N: Exclude files with more than N text characters
    Useful for filtering out artist info cards, copyright notices, etc. Default is 0 (disabled).

.EXAMPLE
    .\Analyze-UnusedAnsiFiles.ps1
    Analyzes all files in the unused-ansi-files folder with default size limits.

.EXAMPLE
    .\Analyze-UnusedAnsiFiles.ps1 -MaxWidth 80 -MaxHeight 25 -ShowDetails
    Analyzes files with stricter size limits and shows detailed information.

.EXAMPLE
    .\Analyze-UnusedAnsiFiles.ps1 -OutputCsv "results.csv" -CopyToFolder "normal-size-ansi"
    Analyzes files, saves results to CSV, and copies suitable files to a folder.

.EXAMPLE
    .\Analyze-UnusedAnsiFiles.ps1 -ExcludeRegularAscii -ShowSummary
    Analyzes files but excludes those containing only regular ASCII characters (no extended ASCII or ANSI colors).

.EXAMPLE
    .\Analyze-UnusedAnsiFiles.ps1 -AsciiCharLimit 50 -ShowSummary
    Analyzes files but excludes those with more than 50 visible text characters (like artist info cards).
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [string]$UnusedAnsiPath = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'assets/unused-ansi-files'),

    [Parameter()]
    [int]$MaxWidth = 120,

    [Parameter()]
    [int]$MaxHeight = 50,

    [Parameter()]
    [string]$OutputCsv,

    [Parameter()]
    [string]$CopyToFolder,

    [Parameter()]
    [switch]$ShowDetails,

    [Parameter()]
    [switch]$ShowSummary,

    [Parameter()]
    [switch]$ConvertToScripts,

    [Parameter()]
    [string]$ConvertOutputDir = (Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath 'ColorScripts-Enhanced/Scripts'),

    [Parameter()]
    [switch]$Force,

    [Parameter()]
    [switch]$StripSpaceBackground,

    [Parameter()]
    [switch]$ExcludeRegularAscii,

    [Parameter()]
    [int]$AsciiCharLimit = 0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$converterPath = Join-Path -Path $PSScriptRoot -ChildPath 'Convert-AnsiToColorScript.js'
if (-not (Test-Path -LiteralPath $converterPath -PathType Leaf)) {
    throw "ANSI converter not found: $converterPath"
}
$nodeCommand = Get-Command -Name node -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
if (-not $nodeCommand) {
    throw 'Node.js is required to analyze ANSI terminal dimensions accurately.'
}

# Helper function to strip SAUCE metadata (similar to JavaScript version)
function Remove-Sauce {
    param([byte[]]$Buffer)

    $SAUCE_LENGTH = 128
    if ($Buffer.Length -lt $SAUCE_LENGTH) {
        return @{
            Buffer = $Buffer
            Sauce  = $null
        }
    }

    $sauceOffset = $Buffer.Length - $SAUCE_LENGTH
    $sauceIdBytes = $Buffer[$sauceOffset..($sauceOffset + 4)]
    $sauceId = [System.Text.Encoding]::ASCII.GetString($sauceIdBytes)

    if ($sauceId -ne 'SAUCE') {
        return @{
            Buffer = $Buffer
            Sauce  = $null
        }
    }

    # Extract SAUCE record for width/height info
    $sauceRecord = $Buffer[$sauceOffset..($sauceOffset + $SAUCE_LENGTH - 1)]
    $tInfo1 = [BitConverter]::ToUInt16($sauceRecord, 96 - $sauceOffset + $sauceOffset)  # Width
    $tInfo2 = [BitConverter]::ToUInt16($sauceRecord, 98 - $sauceOffset + $sauceOffset)  # Height

    $sauce = @{
        Width  = $tInfo1
        Height = $tInfo2
    }

    # Check for comment block
    $trimOffset = $sauceOffset
    $comments = $sauceRecord[104 - $sauceOffset + $sauceOffset]

    if ($comments -gt 0) {
        $commentBlockLength = 5 + $comments * 64
        $commentOffset = $sauceOffset - $commentBlockLength
        if ($commentOffset -ge 0) {
            $commentIdBytes = $Buffer[$commentOffset..($commentOffset + 4)]
            $commentId = [System.Text.Encoding]::ASCII.GetString($commentIdBytes)
            if ($commentId -eq 'COMNT') {
                $trimOffset = $commentOffset
            }
        }
    }

    if ($trimOffset -gt 0 -and $Buffer[$trimOffset - 1] -eq 0x1A) {
        $trimOffset--
    }

    $contentBuffer = if ($trimOffset -gt 0) { $Buffer[0..($trimOffset - 1)] } else { [byte[]]@() }
    return @{
        Buffer = $contentBuffer
        Sauce  = $sauce
    }
}

# Helper function to calculate actual terminal dimensions
function Get-AnsiDimension {
    param(
        [System.IO.FileInfo]$FileInfo,
        [hashtable]$Sauce
    )

    # If SAUCE provides dimensions and they seem reasonable, use them
    if ($Sauce -and $Sauce.Width -gt 0 -and $Sauce.Height -gt 0 -and $Sauce.Width -le 2048 -and $Sauce.Height -le 8192) {
        return @{
            Width  = $Sauce.Width
            Height = $Sauce.Height
            Source = 'SAUCE'
        }
    }

    # Use the same bounded terminal emulator that performs conversion. Regex
    # heuristics cannot correctly account for cursor movement, overwrites, tabs,
    # erases, or wrapping and therefore misclassify real ANSI art.
    # Native stdout decoding follows the process-wide console encoding in both
    # Windows PowerShell and PowerShell 7. Pin it for this invocation so a caller
    # that previously selected UTF-16 cannot turn the ASCII JSON prefix `{` + `"`
    # into U+227B and make ConvertFrom-Json fail.
    $utf8Encoding = New-Object System.Text.UTF8Encoding($false)
    $originalOutputEncoding = $OutputEncoding
    $originalConsoleEncoding = $null
    $consoleEncodingChanged = $false
    try {
        try {
            $originalConsoleEncoding = [Console]::OutputEncoding
            [Console]::OutputEncoding = $utf8Encoding
            $consoleEncodingChanged = $true
        }
        catch {
            Write-Verbose "Unable to set the console output encoding for ANSI analysis: $($_.Exception.Message)"
        }

        $OutputEncoding = $utf8Encoding
        $analysisOutput = @(& $nodeCommand.Source $converterPath '--analyze-json' '--encoding=cp437' '--' $FileInfo.FullName 2>&1)
    }
    finally {
        $OutputEncoding = $originalOutputEncoding
        if ($consoleEncodingChanged) {
            try {
                [Console]::OutputEncoding = $originalConsoleEncoding
            }
            catch {
                Write-Verbose "Unable to restore the console output encoding after ANSI analysis: $($_.Exception.Message)"
            }
        }
    }

    if ($LASTEXITCODE -ne 0) {
        throw "ANSI dimension analysis failed for '$($FileInfo.FullName)': $($analysisOutput -join [Environment]::NewLine)"
    }
    $analysis = $analysisOutput -join [Environment]::NewLine | ConvertFrom-Json -ErrorAction Stop
    return @{
        Width  = [int]$analysis.width
        Height = [int]$analysis.height
        Source = 'Terminal emulation'
    }
}

# Helper function to count ASCII characters in content
function Get-AsciiCharCount {
    param(
        [string]$Content
    )

    # Remove ANSI escape sequences first
    $cleanContent = $Content -replace '\x1b\[[0-?]*[ -/]*[@-~]', ''

    # Count different types of characters
    $extendedAsciiCount = 0      # Box drawing, special chars (128-255)
    $visibleTextCount = 0        # Regular printable ASCII (letters, numbers, punctuation)
    $whitespaceCount = 0         # Spaces, tabs, newlines
    $hasExtendedAscii = $false

    for ($i = 0; $i -lt $cleanContent.Length; $i++) {
        $charCode = [int][char]$cleanContent[$i]

        # CP437 box/block characters decode to Unicode code points such as
        # U+2500 and U+2588, not to the original byte values 128-255.
        if ($charCode -gt 127 -and -not [char]::IsWhiteSpace($cleanContent[$i])) {
            $hasExtendedAscii = $true
            $extendedAsciiCount++
        }
        # Visible text characters (letters, numbers, punctuation)
        elseif (($charCode -ge 33 -and $charCode -le 126) -or ($charCode -ge 65 -and $charCode -le 90) -or ($charCode -ge 97 -and $charCode -le 122) -or ($charCode -ge 48 -and $charCode -le 57)) {
            $visibleTextCount++
        }
        # Whitespace
        elseif ($charCode -eq 32 -or $charCode -eq 9 -or $charCode -eq 10 -or $charCode -eq 13) {
            $whitespaceCount++
        }
    }

    return @{
        ExtendedAsciiCount = $extendedAsciiCount
        VisibleTextCount   = $visibleTextCount
        WhitespaceCount    = $whitespaceCount
        HasExtendedAscii   = $hasExtendedAscii
        TotalAsciiChars    = $extendedAsciiCount + $visibleTextCount
    }
}
# Main analysis function
function Test-AnsiFile {
    param(
        [System.IO.FileInfo]$FileInfo,

        [int]$MaximumWidth,

        [int]$MaximumHeight,

        [switch]$ExcludePlainAscii,

        [int]$MaximumAsciiCharacters
    )

    try {
        # Read file as bytes
        $bytes = [System.IO.File]::ReadAllBytes($FileInfo.FullName)

        # Strip SAUCE metadata
        $result = Remove-Sauce -Buffer $bytes

        # Convert from CP437 encoding
        $cp437 = [System.Text.Encoding]::GetEncoding(437)
        $content = $cp437.GetString($result.Buffer)

        if ([string]::IsNullOrWhiteSpace($content)) {
            return [PSCustomObject]@{
                FileName     = $FileInfo.Name
                FilePath     = $FileInfo.FullName
                Width        = 0
                Height       = 0
                Source       = 'Empty file'
                IsNormalSize = $false
                FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
                Error        = 'File appears to be empty'
            }
        }

        # Check for regular ASCII characters if exclusion flag is set
        if ($ExcludePlainAscii) {
            $hasExtendedAscii = $false
            $hasAnsiEscapes = $content -match '\x1b\['

            # Check for extended ASCII characters (128-255) or ANSI escape sequences
            foreach ($char in $content.ToCharArray()) {
                if ([int]$char -gt 127) {
                    $hasExtendedAscii = $true
                    break
                }
            }

            # If file contains only regular ASCII and no ANSI escapes, exclude it
            if (-not $hasExtendedAscii -and -not $hasAnsiEscapes) {
                return [PSCustomObject]@{
                    FileName     = $FileInfo.Name
                    FilePath     = $FileInfo.FullName
                    Width        = 0
                    Height       = 0
                    Source       = 'Regular ASCII only'
                    IsNormalSize = $false
                    FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
                    Error        = 'Excluded: Contains only regular ASCII characters'
                }
            }
        }

        # Calculate dimensions
        $dimensions = Get-AnsiDimension -FileInfo $FileInfo -Sauce $result.Sauce

        # Check ASCII character limit if specified
        if ($MaximumAsciiCharacters -ge 0 -and $ExcludePlainAscii) {
            $asciiInfo = Get-AsciiCharCount -Content $content

            # If limit is 0, exclude files with significant text but little art
            if ($MaximumAsciiCharacters -eq 0) {
                # Exclude if file has lots of text but very few extended ASCII art characters
                # This filters out info cards, copyright notices, etc.
                $artToTextRatio = if ($asciiInfo.VisibleTextCount -gt 0) {
                    $asciiInfo.ExtendedAsciiCount / $asciiInfo.VisibleTextCount
                }
                else { 1.0 }

                # If less than 10% of content is art characters, it's probably a text file
                if ($asciiInfo.VisibleTextCount -gt 50 -and $artToTextRatio -lt 0.1) {
                    return [PSCustomObject]@{
                        FileName     = $FileInfo.Name
                        FilePath     = $FileInfo.FullName
                        Width        = $dimensions.Width
                        Height       = $dimensions.Height
                        Source       = $dimensions.Source
                        IsNormalSize = $false
                        FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
                        Error        = "Excluded: Text-heavy file ($($asciiInfo.VisibleTextCount) text chars, $($asciiInfo.ExtendedAsciiCount) art chars, ratio: $([Math]::Round($artToTextRatio, 2)))"
                    }
                }
            }
            # Otherwise use the explicit limit
            elseif ($asciiInfo.VisibleTextCount -gt $MaximumAsciiCharacters) {
                return [PSCustomObject]@{
                    FileName     = $FileInfo.Name
                    FilePath     = $FileInfo.FullName
                    Width        = $dimensions.Width
                    Height       = $dimensions.Height
                    Source       = $dimensions.Source
                    IsNormalSize = $false
                    FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
                    Error        = "Excluded: Contains $($asciiInfo.VisibleTextCount) visible text chars (limit: $MaximumAsciiCharacters)"
                }
            }
        }

        # Determine if it's within normal terminal size
        $isNormalSize = $dimensions.Width -le $MaximumWidth -and $dimensions.Height -le $MaximumHeight

        return [PSCustomObject]@{
            FileName     = $FileInfo.Name
            FilePath     = $FileInfo.FullName
            Width        = $dimensions.Width
            Height       = $dimensions.Height
            Source       = $dimensions.Source
            IsNormalSize = $isNormalSize
            FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
            Error        = $null
        }
    }
    catch {
        return [PSCustomObject]@{
            FileName     = $FileInfo.Name
            FilePath     = $FileInfo.FullName
            Width        = 0
            Height       = 0
            Source       = 'Error'
            IsNormalSize = $false
            FileSizeKB   = if ($FileInfo.Length) { [Math]::Round($FileInfo.Length / 1KB, 2) } else { 0 }
            Error        = $_.Exception.Message
        }
    }
}

# Main script execution
Write-Host '[ANALYZE] Analyzing unused ANSI files for normal terminal sizes...' -ForegroundColor Cyan
Write-Host "[CRITERIA] Normal size criteria: Width ≤ $MaxWidth columns, Height ≤ $MaxHeight lines" -ForegroundColor Yellow

# Validate input path
if (-not (Test-Path -LiteralPath $UnusedAnsiPath -PathType Container)) {
    Write-Error "Path not found: $UnusedAnsiPath"
    exit 1
}

# Get all .ans files
$ansiFiles = @(Get-ChildItem -LiteralPath $UnusedAnsiPath -Filter '*.ans' -File)
if ($ansiFiles.Count -eq 0) {
    Write-Warning "No .ans files found in $UnusedAnsiPath"
    exit 0
}

Write-Host "[FILES] Found $($ansiFiles.Count) ANSI files to analyze..." -ForegroundColor Green

# Analyze each file
$results = @()
$processedCount = 0
$convertedCount = 0
$conversionFailureCount = 0

foreach ($file in $ansiFiles) {
    $processedCount++
    if ($processedCount % 50 -eq 0 -or $ShowDetails) {
        Write-Progress -Activity 'Analyzing ANSI files' -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $ansiFiles.Count) * 100)
    }

    $analysisParameters = @{
        FileInfo               = $file
        MaximumWidth           = $MaxWidth
        MaximumHeight          = $MaxHeight
        ExcludePlainAscii      = $ExcludeRegularAscii
        MaximumAsciiCharacters = $AsciiCharLimit
    }
    $result = Test-AnsiFile @analysisParameters
    $results += $result

    if ($ShowDetails) {
        $statusColor = if ($result.IsNormalSize) { 'Green' } else { 'Red' }
        $status = if ($result.IsNormalSize) { '[OK] NORMAL' } else { '[BIG] OVERSIZED' }

        Write-Host "$status : $($result.FileName)" -ForegroundColor $statusColor
        Write-Host "   Size: $($result.Width)x$($result.Height) ($($result.Source)) - $($result.FileSizeKB)KB" -ForegroundColor Gray

        if ($result.Error) {
            Write-Host "   Error: $($result.Error)" -ForegroundColor Red
        }
    }

    # Copy file if it meets criteria
    if ($CopyToFolder -and $result.IsNormalSize -and -not $result.Error) {
        try {
            $copyTarget = Join-Path -Path $CopyToFolder -ChildPath $result.FileName
            if ((Test-Path -LiteralPath $copyTarget -PathType Leaf) -and -not $Force) {
                Write-Warning "Skipping existing copy target '$copyTarget'. Use -Force to replace it."
                continue
            }
            if ($PSCmdlet.ShouldProcess($copyTarget, 'Copy normal-sized ANSI file')) {
                if (-not (Test-Path -LiteralPath $CopyToFolder -PathType Container)) {
                    New-Item -ItemType Directory -Path $CopyToFolder -Force -ErrorAction Stop | Out-Null
                }
                Copy-Item -LiteralPath $result.FilePath -Destination $copyTarget -Force:$Force -ErrorAction Stop
            }
        }
        catch {
            Write-Warning "Failed to copy $($result.FileName): $_"
        }
    }

    # Convert file if it meets criteria and conversion is requested
    if ($ConvertToScripts -and $result.IsNormalSize -and -not $result.Error) {
        try {
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($result.FileName).ToLowerInvariant()
            $baseName = $baseName -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|-$', ''
            if ([string]::IsNullOrWhiteSpace($baseName)) {
                Write-Warning "Skipping '$($result.FileName)' because its name cannot form a safe colorscript filename."
                $conversionFailureCount++
                continue
            }
            $outputPath = Join-Path -Path $ConvertOutputDir -ChildPath ($baseName + '.ps1')

            if ((Test-Path -LiteralPath $outputPath -PathType Leaf) -and -not $Force) {
                Write-Warning "Skipping existing conversion output '$outputPath'. Use -Force to replace it."
                continue
            }
            if (-not $PSCmdlet.ShouldProcess($outputPath, "Convert '$($result.FileName)' to a colorscript")) {
                continue
            }

            Write-Host "Converting: $($result.FileName)" -ForegroundColor Yellow

            $nodeArgs = @(
                $converterPath
                $result.FilePath
                $outputPath
            )

            # Add optional parameters
            if ($StripSpaceBackground) {
                $nodeArgs += '--strip-space-bg'
            }

            # Run the conversion
            $conversionResult = & $nodeCommand.Source $nodeArgs 2>&1

            if ($LASTEXITCODE -eq 0) {
                Write-Host '  -> Converted successfully' -ForegroundColor Green
                $convertedCount++
            }
            else {
                Write-Warning "  -> Conversion failed: $conversionResult"
                $conversionFailureCount++
            }
        }
        catch {
            Write-Warning "Failed to convert $($result.FileName): $_"
            $conversionFailureCount++
        }
    }
}

Write-Progress -Activity 'Analyzing ANSI files' -Completed

# Generate summary
$normalSizeFiles = $results | Where-Object { $_.IsNormalSize -and -not $_.Error }
$oversizedFiles = $results | Where-Object { -not $_.IsNormalSize -and -not $_.Error -and $_.Source -ne 'Regular ASCII only' }
$asciiOnlyFiles = $results | Where-Object { $_.Source -eq 'Regular ASCII only' }
$errorFiles = $results | Where-Object { $_.Error }

if ($ShowSummary) {
    Write-Host "`n[SUMMARY] ANALYSIS SUMMARY" -ForegroundColor Cyan
    Write-Host '==================' -ForegroundColor Cyan
    Write-Host "Total files analyzed: $($results.Count)" -ForegroundColor White
    Write-Host "Normal size files: $($normalSizeFiles.Count)" -ForegroundColor Green
    Write-Host "Oversized files: $($oversizedFiles.Count)" -ForegroundColor Red
    if ($ExcludeRegularAscii) {
        Write-Host "ASCII-only files (excluded): $($asciiOnlyFiles.Count)" -ForegroundColor Gray
    }
    Write-Host "Files with errors: $($errorFiles.Count)" -ForegroundColor Yellow

    Write-Host "`n[NORMAL] NORMAL SIZE FILES (Width ≤ $MaxWidth, Height ≤ $MaxHeight):" -ForegroundColor Green
    if ($normalSizeFiles.Count -gt 0) {
        $normalSizeFiles | Sort-Object Width, Height | ForEach-Object {
            Write-Host "  [OK] $($_.FileName) - $($_.Width)x$($_.Height) ($($_.Source))" -ForegroundColor Green
        }

        # Show size distribution
        Write-Host "`n[SIZES] Size Distribution:" -ForegroundColor Cyan
        $sizeGroups = $normalSizeFiles | Group-Object {
            if ($_.Width -le 80) { '≤80 columns' }
            elseif ($_.Width -le 100) { '81-100 columns' }
            else { "101-$MaxWidth columns" }
        }
        foreach ($group in $sizeGroups) {
            Write-Host "  $($group.Name): $($group.Count) files" -ForegroundColor White
        }
    }
    else {
        Write-Host '  No files found within normal size limits.' -ForegroundColor Yellow
    }

    if ($oversizedFiles.Count -gt 0) {
        Write-Host "`n[OVERSIZED] OVERSIZED FILES (showing first 10):" -ForegroundColor Red
        $oversizedFiles | Sort-Object Width -Descending | Select-Object -First 10 | ForEach-Object {
            Write-Host "  [BIG] $($_.FileName) - $($_.Width)x$($_.Height) ($($_.Source))" -ForegroundColor Red
        }
        if ($oversizedFiles.Count -gt 10) {
            Write-Host "  ... and $($oversizedFiles.Count - 10) more oversized files" -ForegroundColor Red
        }
    }

    if ($errorFiles.Count -gt 0) {
        Write-Host "`n[ERROR] FILES WITH ERRORS:" -ForegroundColor Yellow
        $errorFiles | ForEach-Object {
            Write-Host "  ! $($_.FileName) - $($_.Error)" -ForegroundColor Yellow
        }
    }
}

# Save to CSV if requested
if ($OutputCsv) {
    try {
        if ($PSCmdlet.ShouldProcess($OutputCsv, 'Export ANSI analysis results')) {
            $results | Export-Csv -LiteralPath $OutputCsv -NoTypeInformation -Encoding UTF8
            Write-Host "`n[SAVED] Results saved to: $OutputCsv" -ForegroundColor Cyan
        }
    }
    catch {
        Write-Error "Failed to save CSV: $_"
    }
}

# Copy summary
if ($CopyToFolder -and $normalSizeFiles.Count -gt 0) {
    Write-Host "`n[COPIED] Copied $($normalSizeFiles.Count) normal-sized files to: $CopyToFolder" -ForegroundColor Green
}

# Conversion summary
if ($ConvertToScripts) {
    Write-Host "`n[CONVERTED] Converted $convertedCount/$($normalSizeFiles.Count) normal-sized files to PowerShell scripts in: $ConvertOutputDir" -ForegroundColor Green
}

Write-Host "`n[COMPLETE] Analysis complete!" -ForegroundColor Green

if ($conversionFailureCount -gt 0) {
    throw "$conversionFailureCount ANSI file conversion(s) failed."
}
