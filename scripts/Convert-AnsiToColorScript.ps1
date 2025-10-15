<#
.SYNOPSIS
    Convert ANSI art files (.ans) to PowerShell ColorScripts.

.DESCRIPTION
    Reads ANSI art files and converts them to PowerShell scripts that can be used
    with the ColorScripts-Enhanced module. Supports standard ANSI escape sequences.

.PARAMETER AnsiFile
    Path to the .ans file to convert.

.PARAMETER OutputFile
    Path where the PowerShell script will be saved. If not specified, uses the same
    name as the input file with .ps1 extension.

.PARAMETER OutputDirectory
    Directory where the script will be saved. Defaults to ColorScripts-Enhanced/Scripts.

.PARAMETER AddComment
    Add a comment header to the generated script with the original filename.

.EXAMPLE
    .\Convert-AnsiToColorScript.ps1 -AnsiFile "myart.ans"
    Converts myart.ans to myart.ps1 in the Scripts directory.

.EXAMPLE
    .\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans" -OutputFile "custom.ps1"
    Converts art.ans to custom.ps1 in the Scripts directory.

.EXAMPLE
    Get-ChildItem *.ans | ForEach-Object { .\Convert-AnsiToColorScript.ps1 -AnsiFile $_.FullName }
    Batch convert all .ans files in current directory.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName', 'Path')]
    [string]$AnsiFile,

    [Parameter()]
    [string]$OutputFile,

    [Parameter()]
    [string]$OutputDirectory = ".\ColorScripts-Enhanced\Scripts",

    [Parameter()]
    [switch]$AddComment
)

begin {
    $ErrorActionPreference = 'Stop'

    # Ensure output directory exists
    if (-not (Test-Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    }
}

process {
    # Validate input file
    if (-not (Test-Path $AnsiFile)) {
        Write-Error "ANSI file not found: $AnsiFile"
        return
    }

    $ansiFileInfo = Get-Item $AnsiFile

    # Determine output filename
    if (-not $OutputFile) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($ansiFileInfo.Name)
        # Clean up the name for PowerShell (lowercase, replace spaces/special chars with hyphens)
        $baseName = $baseName.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|-$', ''
        $OutputFile = "$baseName.ps1"
    }

    $outputPath = Join-Path $OutputDirectory $OutputFile

    try {
        # Read the ANSI file as raw bytes first
        $bytes = [System.IO.File]::ReadAllBytes($AnsiFile)

        # Convert from CP437 (DOS/OEM) encoding to Unicode
        # This is the encoding used by traditional ANSI art files
        $cp437 = [System.Text.Encoding]::GetEncoding(437)
        $content = $cp437.GetString($bytes)

        # Check if content is actually present
        if ([string]::IsNullOrWhiteSpace($content)) {
            Write-Warning "ANSI file appears to be empty: $AnsiFile"
            return
        }

        # Detect and convert single-line ANSI files
        # Case 1: Files with cursor positioning (ESC[row;colH)
        # Case 2: Files with one long line that should be wrapped (80-column format)
        $lines = @($content -split '[\r\n]+')
        $nonEmptyLines = @($lines | Where-Object { $_.Length -gt 0 })
        $firstLineLength = if ($nonEmptyLines.Count -gt 0 -and $nonEmptyLines[0] -is [string]) {
            ($nonEmptyLines[0] -replace '\x1b\[[^m]*m', '').Length
        }
        else { 0 }
        $hasCursorPositioning = $content -match '\x1b\[\d+;\d+[Hf]'
        # Check if first line is much longer than expected (e.g., 80*10 = 800 chars suggests wrapped format)
        # Also check if there's a second line that's much shorter (likely SAUCE metadata)
        $isLongSingleLine = ($firstLineLength -gt 800) -and ($nonEmptyLines.Count -le 2)

        if ($hasCursorPositioning) {
            Write-Verbose "Detected single-line ANSI file with cursor positioning - converting to multi-line format"

            # Convert cursor positioning to newlines
            # ESC[row;colH or ESC[row;colf moves cursor to position
            $lines = @{}
            $currentLine = 1
            $currentCol = 1
            $result = [System.Text.StringBuilder]::new()

            # Parse through the content character by character
            $i = 0
            while ($i -lt $content.Length) {
                if ($content[$i] -eq "`e" -and $i + 1 -lt $content.Length -and $content[$i + 1] -eq '[') {
                    # Found escape sequence
                    $escStart = $i
                    $i += 2
                    $escSeq = [System.Text.StringBuilder]::new()

                    # Read until we hit a letter (command character)
                    while ($i -lt $content.Length -and $content[$i] -match '[\d;]') {
                        [void]$escSeq.Append($content[$i])
                        $i++
                    }

                    if ($i -lt $content.Length) {
                        $cmd = $content[$i]

                        # Handle cursor positioning commands
                        if ($cmd -eq 'H' -or $cmd -eq 'f') {
                            # Cursor position: ESC[row;colH
                            $parts = $escSeq.ToString() -split ';'
                            if ($parts.Count -eq 2) {
                                $newLine = [int]$parts[0]
                                $newCol = [int]$parts[1]

                                # Add newlines if moving to a new row
                                if ($newLine -gt $currentLine) {
                                    [void]$result.Append("`n" * ($newLine - $currentLine))
                                    $currentLine = $newLine
                                    $currentCol = 1
                                }

                                # Add spaces if moving to a new column on same row
                                if ($newCol -gt $currentCol) {
                                    [void]$result.Append(' ' * ($newCol - $currentCol))
                                    $currentCol = $newCol
                                }
                            }
                        }
                        elseif ($cmd -eq 'B') {
                            # Cursor down: ESC[nB
                            $n = if ($escSeq.Length -gt 0) { [int]$escSeq.ToString() } else { 1 }
                            [void]$result.Append("`n" * $n)
                            $currentLine += $n
                            $currentCol = 1
                        }
                        elseif ($cmd -eq 'C') {
                            # Cursor forward: ESC[nC
                            $n = if ($escSeq.Length -gt 0) { [int]$escSeq.ToString() } else { 1 }
                            [void]$result.Append(' ' * $n)
                            $currentCol += $n
                        }
                        else {
                            # Keep other escape sequences intact
                            [void]$result.Append($content.Substring($escStart, $i - $escStart + 1))
                        }
                        $i++
                    }
                }
                else {
                    # Regular character
                    [void]$result.Append($content[$i])
                    $currentCol++
                    $i++
                }
            }

            $content = $result.ToString()
        }
        elseif ($isLongSingleLine) {
            Write-Verbose "Detected 80-column wrapped ANSI file - splitting into multiple lines"

            # Get the first line (the one with all the content)
            $firstLine = $nonEmptyLines[0]            # We need to split this line every 80 visible characters while preserving ANSI codes
            # ANSI codes don't count toward the 80-character width
            $result = [System.Text.StringBuilder]::new()
            $visibleCount = 0
            $lineWidth = 80
            $currentColorCodes = [System.Collections.ArrayList]::new()

            $i = 0
            while ($i -lt $firstLine.Length) {
                if ($firstLine[$i] -eq "`e" -and $i + 1 -lt $firstLine.Length -and $firstLine[$i + 1] -eq '[') {
                    # Start of escape sequence - copy it without counting toward width
                    $escStart = $i
                    $i += 2
                    while ($i -lt $firstLine.Length -and $firstLine[$i] -match '[0-9;]') {
                        $i++
                    }
                    if ($i -lt $firstLine.Length) {
                        # Include the final character (like 'm')
                        $escSeq = $firstLine.Substring($escStart, $i - $escStart + 1)
                        [void]$result.Append($escSeq)

                        # Track color state (only for SGR sequences ending in 'm')
                        if ($firstLine[$i] -eq 'm') {
                            # Check if this is a reset code
                            if ($escSeq -match '\[0m' -or $escSeq -match '\[m') {
                                $currentColorCodes.Clear()
                            }
                            else {
                                # Add to current color state
                                [void]$currentColorCodes.Add($escSeq)
                            }
                        }

                        $i++ # Move past the final character
                    }
                }
                else {
                    # Regular character - counts toward width
                    [void]$result.Append($firstLine[$i])
                    $visibleCount++
                    $i++

                    # Add newline every 80 visible characters
                    if ($visibleCount -eq $lineWidth -and $i -lt $firstLine.Length) {
                        # Reset colors before newline to prevent bleeding
                        [void]$result.Append("`e[0m")
                        [void]$result.AppendLine()

                        # Restore color state at start of next line
                        foreach ($code in $currentColorCodes) {
                            [void]$result.Append($code)
                        }

                        $visibleCount = 0
                    }
                }
            }

            # Add final reset if there were any color codes
            if ($currentColorCodes.Count -gt 0) {
                [void]$result.Append("`e[0m")
            }            $content = $result.ToString()
        }
        else {
            # Case 3: Multi-line file where some individual lines exceed 80 chars and need wrapping
            # Check if any line is significantly longer than 80 visible characters
            $lines = @($content -split '[\r\n]+')
            $hasLongLines = $false
            foreach ($line in $lines) {
                $visibleLength = ($line -replace '\x1b\[[^m]*m', '').Length
                if ($visibleLength -gt 100) {
                    # More than 80 with some tolerance
                    $hasLongLines = $true
                    break
                }
            }

            if ($hasLongLines) {
                Write-Verbose "Detected multi-line ANSI file with some long lines - wrapping at 80 columns"

                $result = [System.Text.StringBuilder]::new()
                $lineWidth = 80

                foreach ($line in $lines) {
                    $visibleLength = ($line -replace '\x1b\[[^m]*m', '').Length

                    if ($visibleLength -le $lineWidth) {
                        # Line is fine as-is, but add reset code if it has colors and doesn't end with one
                        if ($line -match '\x1b\[' -and $line -notmatch '\[0m\s*$') {
                            [void]$result.Append($line)
                            [void]$result.AppendLine("`e[0m")
                        }
                        else {
                            [void]$result.AppendLine($line)
                        }
                    }
                    else {
                        # Need to wrap this line at 80 characters
                        # Track current color state to restore after line breaks
                        $visibleCount = 0
                        $i = 0
                        $currentColorCodes = [System.Collections.ArrayList]::new()

                        while ($i -lt $line.Length) {
                            if ($line[$i] -eq "`e" -and $i + 1 -lt $line.Length -and $line[$i + 1] -eq '[') {
                                # Start of escape sequence - copy it without counting toward width
                                $escStart = $i
                                $i += 2
                                while ($i -lt $line.Length -and $line[$i] -match '[0-9;]') {
                                    $i++
                                }
                                if ($i -lt $line.Length) {
                                    # Include the final character (like 'm')
                                    $escSeq = $line.Substring($escStart, $i - $escStart + 1)
                                    [void]$result.Append($escSeq)

                                    # Track color state (only for SGR sequences ending in 'm')
                                    if ($line[$i] -eq 'm') {
                                        # Check if this is a reset code
                                        if ($escSeq -match '\[0m' -or $escSeq -match '\[m') {
                                            $currentColorCodes.Clear()
                                        }
                                        else {
                                            # Add to current color state
                                            [void]$currentColorCodes.Add($escSeq)
                                        }
                                    }

                                    $i++ # Move past the final character
                                }
                            }
                            else {
                                # Regular character - counts toward width
                                [void]$result.Append($line[$i])
                                $visibleCount++
                                $i++

                                # Add newline every 80 visible characters
                                if ($visibleCount -eq $lineWidth -and $i -lt $line.Length) {
                                    # Reset all attributes before newline to prevent bleeding
                                    # Use both [0m (full reset) and [49m (background reset) for compatibility
                                    [void]$result.Append("`e[0m`e[49m")
                                    [void]$result.AppendLine()

                                    # Restore color state at start of next line
                                    foreach ($code in $currentColorCodes) {
                                        [void]$result.Append($code)
                                    }

                                    $visibleCount = 0
                                }
                            }
                        }

                        # Add reset and newline after processing this line
                        if ($currentColorCodes.Count -gt 0) {
                            [void]$result.Append("`e[0m`e[49m")
                        }
                        [void]$result.AppendLine()
                    }
                }

                $content = $result.ToString()
            }
        }

        # Build the PowerShell script
        $scriptBuilder = [System.Text.StringBuilder]::new()

        # Add header comment if requested
        if ($AddComment) {
            [void]$scriptBuilder.AppendLine("# Converted from: $($ansiFileInfo.Name)")
            [void]$scriptBuilder.AppendLine("# Conversion date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
            [void]$scriptBuilder.AppendLine("")
        }

        # For PowerShell, we can just use Write-Host with the content directly
        # since PowerShell handles ANSI escape sequences natively in modern versions
        [void]$scriptBuilder.AppendLine('Write-Host @"')
        [void]$scriptBuilder.AppendLine($content.TrimEnd())
        [void]$scriptBuilder.AppendLine('"@')

        # Write the output file
        $scriptContent = $scriptBuilder.ToString()
        Set-Content -Path $outputPath -Value $scriptContent -Encoding UTF8 -NoNewline

        Write-Host "✓ Converted: $($ansiFileInfo.Name) → $OutputFile" -ForegroundColor Green
        Write-Host "  Output: $outputPath" -ForegroundColor Cyan

        # Return info about the created file
        [PSCustomObject]@{
            SourceFile = $ansiFileInfo.FullName
            OutputFile = $outputPath
            Size       = (Get-Item $outputPath).Length
        }
    }
    catch {
        Write-Error "Failed to convert $($ansiFileInfo.Name): $_"
    }
}

end {
    Write-Host "`n✓ Conversion complete!" -ForegroundColor Green
}
