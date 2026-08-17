#requires -Version 7.0

<#
.SYNOPSIS
Replaces letters in ANSI-art string literals with spaces.

.DESCRIPTION
Parses PowerShell source and changes only multiline, non-interpolated string
literals passed directly to Write-Host. Comments, metadata, commands, and line
endings are left alone. ANSI/ECMA-48 control sequences such as ESC[31m and
ESC[0m are preserved. Every matched visible letter becomes one space, so the
artwork keeps exactly the same dimensions.

By default, a file named <original>.blanked.ps1 is created beside each input
file. Use -InPlace to replace each source file after creating a .bak copy.

.EXAMPLE
.\Remove-AnsiText.ps1 .\HT-8-94.ps1

.EXAMPLE
.\Remove-AnsiText.ps1 C:\ANSI\Converted -Recurse

.EXAMPLE
.\Remove-AnsiText.ps1 .\HT-8-94.ps1 -InPlace

.EXAMPLE
.\Remove-AnsiText.ps1 .\HT-8-94.ps1 -LetterSet Unicode

.EXAMPLE
.\Remove-AnsiText.ps1 .\HT-8-94.ps1 -LetterSet Unicode -ExtraCharacters '£'
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string[]] $Path,

    [switch] $Recurse,

    [switch] $InPlace,

    [ValidateSet('Ascii', 'Unicode')]
    [string] $LetterSet = 'Ascii',

    [string] $ExtraCharacters = '',

    [switch] $IncludeSingleLine,

    [string] $Suffix = '.blanked',

    [switch] $Force
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    # OSC, DCS/SOS/PM/APC, CSI, 8-bit CSI, and short ESC control sequences.
    # These must remain byte-for-byte intact, including the final "m" in SGR.
    $ansiEscapePattern = [regex]::new(
        '(?:\x1B\][^\x07\x1B]*(?:\x07|\x1B\\)|\x1B[P_X^][\s\S]*?\x1B\\|\x1B\[[0-?]*[ -/]*[@-~]|\x9B[0-?]*[ -/]*[@-~]|\x1B[ -/]*[@-~])',
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
    )

    function Remove-LettersOutsideAnsi {
        param(
            [Parameter(Mandatory)][string] $Text,
            [Parameter(Mandatory)][regex] $LetterRegex
        )

        $builder = [System.Text.StringBuilder]::new($Text.Length)
        $cursor = 0
        $removedCount = 0

        foreach ($ansiMatch in $ansiEscapePattern.Matches($Text)) {
            $plainLength = $ansiMatch.Index - $cursor
            if ($plainLength -gt 0) {
                $plainText = $Text.Substring($cursor, $plainLength)
                $removedCount += $LetterRegex.Matches($plainText).Count
                [void] $builder.Append($LetterRegex.Replace($plainText, ' '))
            }

            [void] $builder.Append($ansiMatch.Value)
            $cursor = $ansiMatch.Index + $ansiMatch.Length
        }

        if ($cursor -lt $Text.Length) {
            $plainText = $Text.Substring($cursor)
            $removedCount += $LetterRegex.Matches($plainText).Count
            [void] $builder.Append($LetterRegex.Replace($plainText, ' '))
        }

        [pscustomobject]@{
            Text         = $builder.ToString()
            RemovedCount = $removedCount
        }
    }

    function Read-SourceFile {
        param([Parameter(Mandatory)][string] $LiteralPath)

        $bytes = [System.IO.File]::ReadAllBytes($LiteralPath)
        $offset = 0

        if ($bytes.Length -ge 4 -and
            $bytes[0] -eq 0x00 -and $bytes[1] -eq 0x00 -and
            $bytes[2] -eq 0xFE -and $bytes[3] -eq 0xFF) {
            $encoding = [System.Text.UTF32Encoding]::new($true, $true, $true)
            $offset = 4
        }
        elseif ($bytes.Length -ge 4 -and
            $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE -and
            $bytes[2] -eq 0x00 -and $bytes[3] -eq 0x00) {
            $encoding = [System.Text.UTF32Encoding]::new($false, $true, $true)
            $offset = 4
        }
        elseif ($bytes.Length -ge 3 -and
            $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
            $encoding = [System.Text.UTF8Encoding]::new($true, $true)
            $offset = 3
        }
        elseif ($bytes.Length -ge 2 -and
            $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
            $encoding = [System.Text.UnicodeEncoding]::new($false, $true, $true)
            $offset = 2
        }
        elseif ($bytes.Length -ge 2 -and
            $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
            $encoding = [System.Text.UnicodeEncoding]::new($true, $true, $true)
            $offset = 2
        }
        else {
            # Converted ANSI-art PowerShell files should normally be UTF-8,
            # even when the original .ANS file used CP437.
            $encoding = [System.Text.UTF8Encoding]::new($false, $true)
        }

        try {
            $text = $encoding.GetString($bytes, $offset, $bytes.Length - $offset)
        }
        catch {
            throw "Cannot decode '$LiteralPath' as UTF-8 or its BOM-declared encoding. Convert the .ps1 file to UTF-8 first."
        }

        [pscustomobject]@{
            Text     = $text
            Encoding = $encoding
        }
    }

    function Get-OutputPath {
        param(
            [Parameter(Mandatory)][string] $InputPath,
            [Parameter(Mandatory)][bool] $InPlaceMode,
            [Parameter(Mandatory)][string] $OutputSuffix
        )

        if ($InPlaceMode) {
            return $InputPath
        }

        $directory = [System.IO.Path]::GetDirectoryName($InputPath)
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputPath)
        $extension = [System.IO.Path]::GetExtension($InputPath)
        return [System.IO.Path]::Combine($directory, "$baseName$OutputSuffix$extension")
    }

    function Test-AnsiStringLiteralCandidate {
        param(
            [Parameter(Mandatory)]
            [System.Management.Automation.Language.CommandElementAst] $Element,

            [Parameter(Mandatory)]
            [bool] $IncludeSingleLineMode
        )

        if ($Element -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
            return $false
        }

        if ($Element.StringConstantType -eq [System.Management.Automation.Language.StringConstantType]::BareWord) {
            return $false
        }

        return $IncludeSingleLineMode -or $Element.Extent.Text -match '\r|\n'
    }

    function Get-AnsiSourceStringLiteral {
        param(
            [Parameter(Mandatory)]
            [string] $Text,

            [Parameter(Mandatory)]
            [string] $InputPath,

            [Parameter(Mandatory)]
            [bool] $IncludeSingleLineMode
        )

        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput(
            $Text,
            $InputPath,
            [ref] $tokens,
            [ref] $parseErrors
        )

        if ($parseErrors.Count -gt 0) {
            $details = ($parseErrors | ForEach-Object {
                    "line $($_.Extent.StartLineNumber): $($_.Message)"
                }) -join [Environment]::NewLine
            throw "PowerShell parsing failed for '$InputPath':$([Environment]::NewLine)$details"
        }

        $commandAsts = $ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and
                $node.GetCommandName() -ieq 'Write-Host'
            }, $true)

        foreach ($commandAst in $commandAsts) {
            foreach ($element in $commandAst.CommandElements | Select-Object -Skip 1) {
                if (Test-AnsiStringLiteralCandidate -Element $element -IncludeSingleLineMode $IncludeSingleLineMode) {
                    $element
                }
            }
        }
    }

    function New-AnsiLetterRegex {
        param(
            [Parameter(Mandatory)]
            [string] $LetterMode,

            [Parameter(Mandatory)]
            [AllowEmptyString()]
            [string] $ExtraCharacterSet
        )

        $basePattern = if ($LetterMode -eq 'Unicode') { '\p{L}' } else { '[A-Za-z]' }
        $extraPattern = ($ExtraCharacterSet.ToCharArray() | ForEach-Object {
                '\u{0:X4}' -f [int] $_
            }) -join '|'
        $pattern = if ($extraPattern) {
            "(?:$basePattern|$extraPattern)"
        }
        else {
            $basePattern
        }

        return [regex]::new(
            $pattern,
            [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
        )
    }

    function Update-AnsiSourceStringLiteral {
        param(
            [Parameter(Mandatory)]
            [string] $Text,

            [Parameter(Mandatory)]
            [AllowEmptyCollection()]
            [object[]] $StringLiteral,

            [Parameter(Mandatory)]
            [regex] $LetterRegex
        )

        $updated = $Text
        $replacementCount = 0
        $stringCount = 0
        foreach ($stringAst in $StringLiteral | Sort-Object { $_.Extent.StartOffset } -Descending) {
            $start = $stringAst.Extent.StartOffset
            $length = $stringAst.Extent.EndOffset - $start
            $literal = $updated.Substring($start, $length)
            $conversion = Remove-LettersOutsideAnsi -Text $literal -LetterRegex $LetterRegex

            if ($conversion.RemovedCount -eq 0) {
                continue
            }

            $updated = $updated.Remove($start, $length).Insert($start, $conversion.Text)
            $replacementCount += $conversion.RemovedCount
            $stringCount++
        }

        return [pscustomobject]@{
            Text             = $updated
            ReplacementCount = $replacementCount
            StringCount      = $stringCount
        }
    }

    function Write-ConvertedAnsiSource {
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory)]
            [string] $InputPath,

            [Parameter(Mandatory)]
            [string] $OutputPath,

            [Parameter(Mandatory)]
            [string] $Text,

            [Parameter(Mandatory)]
            [System.Text.Encoding] $Encoding,

            [Parameter(Mandatory)]
            [int] $ReplacementCount,

            [Parameter(Mandatory)]
            [int] $StringCount,

            [Parameter(Mandatory)]
            [bool] $InPlaceMode,

            [Parameter(Mandatory)]
            [bool] $ForceOverwrite
        )

        if (-not $InPlaceMode -and [System.IO.File]::Exists($OutputPath) -and -not $ForceOverwrite) {
            throw "Output already exists: '$OutputPath'. Use -Force to overwrite it."
        }

        if (-not $PSCmdlet.ShouldProcess($OutputPath, "Replace $ReplacementCount letter(s) in $StringCount ANSI-art string(s)")) {
            return
        }

        if ($InPlaceMode) {
            $backupPath = "$InputPath.bak"
            if ([System.IO.File]::Exists($backupPath) -and -not $ForceOverwrite) {
                throw "Backup already exists: '$backupPath'. Use -Force to overwrite it."
            }
            [System.IO.File]::Copy($InputPath, $backupPath, $true)
        }

        [System.IO.File]::WriteAllText($OutputPath, $Text, $Encoding)
    }

    function Convert-AnsiSource {
        param(
            [Parameter(Mandatory)][string] $InputPath,
            [Parameter(Mandatory)][bool] $InPlaceMode,
            [Parameter(Mandatory)][string] $LetterMode,
            [Parameter(Mandatory)][AllowEmptyString()][string] $ExtraCharacterSet,
            [Parameter(Mandatory)][bool] $IncludeSingleLineMode,
            [Parameter(Mandatory)][string] $OutputSuffix,
            [Parameter(Mandatory)][bool] $ForceOverwrite
        )

        $source = Read-SourceFile -LiteralPath $InputPath
        $stringLiterals = @(Get-AnsiSourceStringLiteral -Text $source.Text -InputPath $InputPath -IncludeSingleLineMode $IncludeSingleLineMode)
        $letterRegex = New-AnsiLetterRegex -LetterMode $LetterMode -ExtraCharacterSet $ExtraCharacterSet
        $conversion = Update-AnsiSourceStringLiteral -Text $source.Text -StringLiteral $stringLiterals -LetterRegex $letterRegex

        $outputPath = Get-OutputPath -InputPath $InputPath -InPlaceMode $InPlaceMode -OutputSuffix $OutputSuffix
        Write-ConvertedAnsiSource -InputPath $InputPath -OutputPath $outputPath -Text $conversion.Text -Encoding $source.Encoding -ReplacementCount $conversion.ReplacementCount -StringCount $conversion.StringCount -InPlaceMode $InPlaceMode -ForceOverwrite $ForceOverwrite

        [pscustomobject]@{
            InputPath        = $InputPath
            OutputPath       = $outputPath
            StringsChanged   = $conversion.StringCount
            LettersReplaced  = $conversion.ReplacementCount
            BackupPath       = if ($InPlaceMode) { "$InputPath.bak" } else { $null }
        }
    }

    $pendingPaths = [System.Collections.Generic.List[string]]::new()
}

process {
    foreach ($item in $Path) {
        $pendingPaths.Add($item)
    }
}

end {
    $files = foreach ($item in $pendingPaths) {
        $resolvedItems = Get-Item -LiteralPath $item

        foreach ($resolvedItem in $resolvedItems) {
            if ($resolvedItem.PSIsContainer) {
                Get-ChildItem -LiteralPath $resolvedItem.FullName -Filter '*.ps1' -File -Recurse:$Recurse
            }
            elseif ($resolvedItem.Extension -ieq '.ps1') {
                $resolvedItem
            }
            else {
                Write-Warning "Skipping non-PowerShell file: '$($resolvedItem.FullName)'"
            }
        }
    }

    $files |
        Sort-Object FullName -Unique |
            ForEach-Object {
                Convert-AnsiSource -InputPath $_.FullName -InPlaceMode $InPlace -LetterMode $LetterSet -ExtraCharacterSet $ExtraCharacters -IncludeSingleLineMode $IncludeSingleLine -OutputSuffix $Suffix -ForceOverwrite $Force
            }
}
