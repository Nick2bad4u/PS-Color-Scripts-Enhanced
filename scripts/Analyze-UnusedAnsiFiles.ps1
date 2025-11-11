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
    Show only a summary of results. Default is true.

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

[CmdletBinding()]
param(
    [Parameter()]
    [string]$UnusedAnsiPath = '.\assets\unused-ansi-files',

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
    [string]$ConvertOutputDir = '.\ColorScripts-Enhanced\Scripts',

    [Parameter()]
    [switch]$StripSpaceBackground,

    [Parameter()]
    [switch]$ExcludeRegularAscii,

    [Parameter()]
    [int]$AsciiCharLimit = 0
)

$ErrorActionPreference = 'Continue'

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

    return @{
        Buffer = $Buffer[0..($trimOffset - 1)]
        Sauce  = $sauce
    }
}

# Helper function to calculate actual terminal dimensions
function Get-AnsiDimension {
    param(
        [string]$Content,
        [hashtable]$Sauce
    )

    # If SAUCE provides dimensions and they seem reasonable, use them
    if ($Sauce -and $Sauce.Width -gt 0 -and $Sauce.Height -gt 0 -and $Sauce.Width -le 300 -and $Sauce.Height -le 200) {
        return @{
            Width  = $Sauce.Width
            Height = $Sauce.Height
            Source = 'SAUCE'
        }
    }

    # Calculate dimensions by analyzing content
    $lines = $Content -split '[\r\n]+'
    $maxWidth = 0
    $actualHeight = 0

    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        $actualHeight++

        # Remove ANSI escape sequences to get visible character count
        # This regex matches: ESC[ followed by any number of digits, semicolons, or other parameters, ending with a letter
        $visibleLine = $line -replace '\x1b\[[0-9;]*[a-zA-Z]', ''
        $visibleLength = $visibleLine.Length

        if ($visibleLength -gt $maxWidth) {
            $maxWidth = $visibleLength
        }
    }

    # Handle single-line files that might need wrapping
    if ($actualHeight -eq 1 -and $maxWidth -gt 160) {
        # Likely needs to be wrapped at 80 columns
        $estimatedHeight = [Math]::Ceiling($maxWidth / 80.0)
        return @{
            Width  = 80
            Height = $estimatedHeight
            Source = 'Calculated (wrapped)'
        }
    }

    # Check for cursor positioning that might indicate single-line format
    if ($Content -match '\x1b\[\d+;\d+[Hf]') {
        # Parse cursor positions to determine dimensions
        $maxRow = 1
        $maxCol = 1

        $cursorMatches = [regex]::Matches($Content, '\x1b\[(\d+);(\d+)[Hf]')
        foreach ($match in $cursorMatches) {
            $row = [int]$match.Groups[1].Value
            $col = [int]$match.Groups[2].Value
            if ($row -gt $maxRow) { $maxRow = $row }
            if ($col -gt $maxCol) { $maxCol = $col }
        }

        return @{
            Width  = $maxCol
            Height = $maxRow
            Source = 'Cursor positioning'
        }
    }

    return @{
        Width  = $maxWidth
        Height = $actualHeight
        Source = 'Line analysis'
    }
}

# Helper function to count ASCII characters in content
function Get-AsciiCharCount {
    param(
        [string]$Content
    )

    # Remove ANSI escape sequences first
    $cleanContent = $Content -replace '\x1b\[[0-9;]*[a-zA-Z]', ''

    # Count different types of characters
    $extendedAsciiCount = 0      # Box drawing, special chars (128-255)
    $visibleTextCount = 0        # Regular printable ASCII (letters, numbers, punctuation)
    $whitespaceCount = 0         # Spaces, tabs, newlines
    $hasExtendedAscii = $false

    for ($i = 0; $i -lt $cleanContent.Length; $i++) {
        $charCode = [int][char]$cleanContent[$i]

        # Check for extended ASCII (128-255) - used in box drawing, etc.
        if ($charCode -ge 128 -and $charCode -le 255) {
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
        TotalAsciiChars    = $asciiCount + $regularAsciiOnlyCount
    }
}
# Main analysis function
function Test-AnsiFile {
    param(
        [System.IO.FileInfo]$FileInfo
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
        if ($ExcludeRegularAscii) {
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
        $dimensions = Get-AnsiDimension -Content $content -Sauce $result.Sauce

        # Check ASCII character limit if specified
        if ($AsciiCharLimit -ge 0 -and $ExcludeRegularAscii) {
            $asciiInfo = Get-AsciiCharCount -Content $content

            # If limit is 0, exclude files with significant text but little art
            if ($AsciiCharLimit -eq 0) {
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
            elseif ($asciiInfo.VisibleTextCount -gt $AsciiCharLimit) {
                return [PSCustomObject]@{
                    FileName     = $FileInfo.Name
                    FilePath     = $FileInfo.FullName
                    Width        = $dimensions.Width
                    Height       = $dimensions.Height
                    Source       = $dimensions.Source
                    IsNormalSize = $false
                    FileSizeKB   = [Math]::Round($FileInfo.Length / 1KB, 2)
                    Error        = "Excluded: Contains $($asciiInfo.VisibleTextCount) visible text chars (limit: $AsciiCharLimit)"
                }
            }
        }

        # Determine if it's within normal terminal size
        $isNormalSize = $dimensions.Width -le $MaxWidth -and $dimensions.Height -le $MaxHeight

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
if (-not (Test-Path $UnusedAnsiPath)) {
    Write-Error "Path not found: $UnusedAnsiPath"
    exit 1
}

# Get all .ans files
$ansiFiles = Get-ChildItem -Path $UnusedAnsiPath -Filter '*.ans' -File
if ($ansiFiles.Count -eq 0) {
    Write-Warning "No .ans files found in $UnusedAnsiPath"
    exit 0
}

Write-Host "[FILES] Found $($ansiFiles.Count) ANSI files to analyze..." -ForegroundColor Green

# Create output folder if specified
if ($CopyToFolder) {
    if (-not (Test-Path $CopyToFolder)) {
        New-Item -ItemType Directory -Path $CopyToFolder -Force | Out-Null
        Write-Host "[FOLDER] Created output folder: $CopyToFolder" -ForegroundColor Green
    }
}

# Create conversion output directory if needed
if ($ConvertToScripts) {
    if (-not (Test-Path $ConvertOutputDir)) {
        New-Item -ItemType Directory -Path $ConvertOutputDir -Force | Out-Null
        Write-Host "[FOLDER] Created conversion output folder: $ConvertOutputDir" -ForegroundColor Green
    }
}

# Analyze each file
$results = @()
$processedCount = 0
$convertedCount = 0

foreach ($file in $ansiFiles) {
    $processedCount++
    if ($processedCount % 50 -eq 0 -or $ShowDetails) {
        Write-Progress -Activity 'Analyzing ANSI files' -Status "Processing $($file.Name)" -PercentComplete (($processedCount / $ansiFiles.Count) * 100)
    }

    $result = Test-AnsiFile -FileInfo $file
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
            Copy-Item -Path $result.FilePath -Destination $CopyToFolder -Force
        }
        catch {
            Write-Warning "Failed to copy $($result.FileName): $_"
        }
    }

    # Convert file if it meets criteria and conversion is requested
    if ($ConvertToScripts -and $result.IsNormalSize -and -not $result.Error) {
        try {
            Write-Host "Converting: $($result.FileName)" -ForegroundColor Yellow

            # Build the node command
            $nodeArgs = @(
                '.\scripts\Convert-AnsiToColorScript.js'
                $result.FilePath
            )

            # Add optional parameters
            if ($StripSpaceBackground) {
                $nodeArgs += '--strip-space-bg'
            }

            # Run the conversion
            $conversionResult = & node $nodeArgs 2>&1

            if ($LASTEXITCODE -eq 0) {
                Write-Host '  -> Converted successfully' -ForegroundColor Green
                $convertedCount++
            }
            else {
                Write-Warning "  -> Conversion failed: $conversionResult"
            }
        }
        catch {
            Write-Warning "Failed to convert $($result.FileName): $_"
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
        $results | Export-Csv -Path $OutputCsv -NoTypeInformation -Encoding UTF8
        Write-Host "`n[SAVED] Results saved to: $OutputCsv" -ForegroundColor Cyan
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
