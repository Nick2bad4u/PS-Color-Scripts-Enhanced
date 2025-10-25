function Show-AscFile {
    <#
    .SYNOPSIS
        Displays ASCII art files (.asc/.ans) in PowerShell with proper encoding support.

    .DESCRIPTION
        Reads and displays ASCII art files, handling both regular and gzipped files.
        Uses CP437 encoding (DOS/OEM) which is standard for ANSI art files.

    .PARAMETER Path
        Path to the .asc or .ans file to display.

    .EXAMPLE
        Show-AscFile ".\art\myart.asc"

    .EXAMPLE
        Show-AscFile ".\art\compressed.asc.gz"
    #>
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path
    )

    process {
        if (-not (Test-Path $Path)) {
            Write-Error "File not found: $Path"
            return
        }

        try {
            # Check if file is gzipped (starts with gzip magic bytes)
            $bytes = [System.IO.File]::ReadAllBytes($Path)
            $content = ""

            if ($bytes.Length -gt 2 -and $bytes[0] -eq 0x1F -and $bytes[1] -eq 0x8B) {
                Write-Host "File is gzipped, decompressing..." -ForegroundColor Yellow

                $stream = New-Object System.IO.MemoryStream($bytes)
                $gzip = New-Object System.IO.Compression.GZipStream($stream, [System.IO.Compression.CompressionMode]::Decompress)
                $reader = New-Object System.IO.StreamReader($gzip, [System.Text.Encoding]::GetEncoding(437))
                $content = $reader.ReadToEnd()
                $reader.Close()
                $gzip.Close()
                $stream.Close()
            }
            else {
                # Read as CP437 (DOS/OEM encoding) - standard for ANSI art
                $content = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::GetEncoding(437))
            }

            # Clear screen and display the art
            Clear-Host
            Write-Host $content

        }
        catch {
            Write-Error "Failed to read file '$Path': $_"
        }
    }
}

# Example usage:
# Show-AscFile ".\assets\unused-ansi-files\avg-#introduction.ans"
