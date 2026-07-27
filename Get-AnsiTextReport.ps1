#requires -Version 7.0

<#
.SYNOPSIS
Ranks ANSI-art PowerShell files by their amount of visible text.

.DESCRIPTION
Counts text-like characters inside multiline, non-interpolated strings passed
directly to Write-Host. PowerShell comments and metadata are ignored, as are
ANSI/ECMA-48 control sequences such as ESC[31m.

Auto mode uses a fast extractor for the standard generated-file shape and
falls back to PowerShell's AST parser for unusual files. A compiled single-pass
scanner classifies the visible payload without allocating ANSI-stripped copies
or per-character regex matches. Progress includes recent and average file
rates, MB/s, ETA, and fast-path/fallback counts.

By default, the classifier counts visible Unicode letters and combining marks
plus the text-like CP437 symbols £, ¢, and ¥.

The default table displays each short filename as an OSC 8 terminal hyperlink
to its complete file URI. The unformatted FullPath and ParserUsed properties
remain available on every result object.

.EXAMPLE
.\Get-AnsiTextReport.ps1 C:\ANSI\Converted -Recurse -Top 5000

.EXAMPLE
.\Get-AnsiTextReport.ps1 C:\ANSI\Converted -Recurse -Verbose

.EXAMPLE
.\Get-AnsiTextReport.ps1 C:\ANSI\Converted -ParserMode Fast

.EXAMPLE
.\Get-AnsiTextReport.ps1 C:\ANSI\Converted -Recurse |
    Select-Object Rank, TextCharacters, FullPath, ParserUsed
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string[]] $Path,

    [switch] $Recurse,

    [ValidateRange(1, 2147483647)]
    [int] $Top = 25,

    [ValidateSet('Auto', 'Fast', 'Ast')]
    [string] $ParserMode = 'Auto',

    [ValidateSet('Ascii', 'Unicode')]
    [string] $LetterSet = 'Unicode',

    [AllowEmptyString()]
    [string] $TextSymbols = '£¢¥',

    [string] $ExtraCharacters = '',

    [switch] $IncludeSingleLine,

    [switch] $IncludeZero,

    [ValidateSet('Name', 'Relative', 'FullPath')]
    [string] $LinkText = 'Name',

    [switch] $NoHyperlinks,

    [ValidateRange(1, 1000000)]
    [int] $ProgressInterval = 250,

    [ValidateRange(0, 1000000)]
    [int] $MaxFailureWarnings = 10,

    [switch] $NoProgress
)

begin {
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'
    $displayBasePath = (Get-Location).Path

    if ($null -eq ('AnsiTextReportSupport.ScannerV2' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace AnsiTextReportSupport
{
    public sealed class ScanResult
    {
        public int TextCharacters { get; set; }
        public string UniqueCharacters { get; set; }
        public int StringsWithText { get; set; }
    }

    public static class ScannerV2
    {
        private static readonly bool[] UnicodeTextBmp = BuildUnicodeTextBmp();

        public static ScanResult Measure(
            string[] texts,
            bool includeUnicode,
            string specialCharacters)
        {
            var unique = new HashSet<int>();
            var specials = GetCodePoints(specialCharacters ?? String.Empty);
            var total = 0;
            var stringsWithText = 0;

            if (texts != null)
            {
                foreach (var text in texts)
                {
                    if (text == null)
                    {
                        continue;
                    }

                    var before = total;
                    total += Scan(text, includeUnicode, specials, unique);
                    if (total > before)
                    {
                        stringsWithText++;
                    }
                }
            }

            var sorted = new List<int>(unique);
            sorted.Sort();
            var builder = new StringBuilder();
            foreach (var codePoint in sorted)
            {
                builder.Append(Char.ConvertFromUtf32(codePoint));
            }

            return new ScanResult
            {
                TextCharacters = total,
                UniqueCharacters = builder.ToString(),
                StringsWithText = stringsWithText
            };
        }

        private static int Scan(
            string text,
            bool includeUnicode,
            HashSet<int> specials,
            HashSet<int> unique)
        {
            var count = 0;
            var index = 0;

            while (index < text.Length)
            {
                var current = text[index];
                if (current == '\x1B')
                {
                    index = SkipEscape(text, index);
                    continue;
                }
                if (current == '\x9B')
                {
                    index = SkipCsi(text, index + 1);
                    continue;
                }

                var codePoint = Char.ConvertToUtf32(text, index);
                var width = Char.IsHighSurrogate(current) &&
                    index + 1 < text.Length &&
                    Char.IsLowSurrogate(text[index + 1])
                    ? 2
                    : 1;

                if (IsTextCharacter(text, index, codePoint, includeUnicode, specials))
                {
                    count++;
                    unique.Add(codePoint);
                }

                index += width;
            }

            return count;
        }

        private static bool IsTextCharacter(
            string text,
            int index,
            int codePoint,
            bool includeUnicode,
            HashSet<int> specials)
        {
            if (specials.Contains(codePoint))
            {
                return true;
            }

            if ((codePoint >= 'A' && codePoint <= 'Z') ||
                (codePoint >= 'a' && codePoint <= 'z'))
            {
                return true;
            }

            if (!includeUnicode || codePoint <= 0x7F)
            {
                return false;
            }

            if (codePoint <= 0xFFFF)
            {
                return UnicodeTextBmp[codePoint];
            }

            return IsTextCategory(
                CharUnicodeInfo.GetUnicodeCategory(text, index));
        }

        private static bool[] BuildUnicodeTextBmp()
        {
            var result = new bool[0x10000];
            for (var codePoint = 0x80; codePoint < result.Length; codePoint++)
            {
                result[codePoint] = IsTextCategory(
                    Char.GetUnicodeCategory((char)codePoint));
            }
            return result;
        }

        private static bool IsTextCategory(UnicodeCategory category)
        {
            switch (category)
            {
                case UnicodeCategory.UppercaseLetter:
                case UnicodeCategory.LowercaseLetter:
                case UnicodeCategory.TitlecaseLetter:
                case UnicodeCategory.ModifierLetter:
                case UnicodeCategory.OtherLetter:
                case UnicodeCategory.NonSpacingMark:
                case UnicodeCategory.SpacingCombiningMark:
                case UnicodeCategory.EnclosingMark:
                    return true;
                default:
                    return false;
            }
        }

        private static int SkipEscape(string text, int index)
        {
            var nextIndex = index + 1;
            if (nextIndex >= text.Length)
            {
                return text.Length;
            }

            var next = text[nextIndex];
            if (next == '[')
            {
                return SkipCsi(text, nextIndex + 1);
            }
            if (next == ']')
            {
                return SkipStringControl(text, nextIndex + 1, true);
            }
            if (next == 'P' || next == 'X' || next == '^' || next == '_')
            {
                return SkipStringControl(text, nextIndex + 1, false);
            }

            var cursor = nextIndex;
            while (cursor < text.Length &&
                text[cursor] >= '\x20' &&
                text[cursor] <= '\x2F')
            {
                cursor++;
            }
            if (cursor < text.Length &&
                text[cursor] >= '\x30' &&
                text[cursor] <= '\x7E')
            {
                cursor++;
            }
            return cursor;
        }

        private static int SkipCsi(string text, int index)
        {
            for (var cursor = index; cursor < text.Length; cursor++)
            {
                var value = text[cursor];
                if (value >= '\x40' && value <= '\x7E')
                {
                    return cursor + 1;
                }
            }
            return text.Length;
        }

        private static int SkipStringControl(
            string text,
            int index,
            bool allowBell)
        {
            for (var cursor = index; cursor < text.Length; cursor++)
            {
                if (allowBell && text[cursor] == '\x07')
                {
                    return cursor + 1;
                }
                if (text[cursor] == '\x1B' &&
                    cursor + 1 < text.Length &&
                    text[cursor + 1] == '\\')
                {
                    return cursor + 2;
                }
            }
            return text.Length;
        }

        private static HashSet<int> GetCodePoints(string text)
        {
            var result = new HashSet<int>();
            for (var index = 0; index < text.Length;)
            {
                var codePoint = Char.ConvertToUtf32(text, index);
                result.Add(codePoint);
                index += Char.IsHighSurrogate(text[index]) &&
                    index + 1 < text.Length &&
                    Char.IsLowSurrogate(text[index + 1])
                    ? 2
                    : 1;
            }
            return result;
        }
    }
}
'@
    }
    $ansiScannerType = 'AnsiTextReportSupport.ScannerV2' -as [type]
    if ($null -eq $ansiScannerType) {
        throw 'Failed to initialize the compiled ANSI text scanner.'
    }

    $fastPatternOptions = (
        [System.Text.RegularExpressions.RegexOptions]::CultureInvariant -bor
        [System.Text.RegularExpressions.RegexOptions]::Compiled -bor
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
        [System.Text.RegularExpressions.RegexOptions]::Multiline
    )
    $fastWriteHostPattern = [regex]::new(
        '^[\t ]*Write-Host[\t ]+(?<quote>[''"])',
        $fastPatternOptions
    )

    function Get-FastPayload {
        param([Parameter(Mandatory)][string] $Source)

        $commandMatch = $fastWriteHostPattern.Match($Source)
        if (-not $commandMatch.Success -or $commandMatch.NextMatch().Success) {
            return [pscustomobject]@{
                Recognized = $false
                Payload    = $null
            }
        }

        $quoteGroup = $commandMatch.Groups['quote']
        $openingQuoteIndex = $quoteGroup.Index
        $closingQuoteIndex = $Source.LastIndexOf([char] $quoteGroup.Value[0])

        if ($closingQuoteIndex -le $openingQuoteIndex) {
            return [pscustomobject]@{
                Recognized = $false
                Payload    = $null
            }
        }

        # A non-whitespace tail means the simple extraction could include code.
        $tail = $Source.Substring($closingQuoteIndex + 1)
        if ($tail -notmatch '^\s*;?\s*$') {
            return [pscustomobject]@{
                Recognized = $false
                Payload    = $null
            }
        }

        $payloadStart = $openingQuoteIndex + 1
        $payload = $Source.Substring(
            $payloadStart,
            $closingQuoteIndex - $payloadStart
        )

        if (-not $IncludeSingleLine -and
            $payload.IndexOf([char] 10) -lt 0 -and
            $payload.IndexOf([char] 13) -lt 0) {
            $payload = $null
        }

        [pscustomobject]@{
            Recognized = $true
            Payload    = $payload
        }
    }

    function Get-AstPayloads {
        param(
            [Parameter(Mandatory)][string] $Source,
            [Parameter(Mandatory)][string] $InputPath
        )

        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput(
            $Source,
            $InputPath,
            [ref] $tokens,
            [ref] $parseErrors
        )

        if ($parseErrors.Count -gt 0) {
            $details = ($parseErrors | ForEach-Object {
                "line $($_.Extent.StartLineNumber): $($_.Message)"
            }) -join '; '
            throw "PowerShell parsing failed: $details"
        }

        $commandAsts = $ast.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and
            $node.GetCommandName() -ieq 'Write-Host'
        }, $true)

        foreach ($commandAst in $commandAsts) {
            foreach ($element in $commandAst.CommandElements | Select-Object -Skip 1) {
                if ($element -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    continue
                }

                if ($element.StringConstantType -eq [System.Management.Automation.Language.StringConstantType]::BareWord) {
                    continue
                }

                if (-not $IncludeSingleLine -and
                    $element.Extent.Text -notmatch '\r|\n') {
                    continue
                }

                $element.Extent.Text
            }
        }
    }

    function Measure-AnsiSource {
        param([Parameter(Mandatory)][string] $InputPath)

        $source = [System.IO.File]::ReadAllText($InputPath)
        $parserUsed = $null
        $payloads = $null

        if ($ParserMode -ne 'Ast') {
            $fastResult = Get-FastPayload -Source $source
            if ($fastResult.Recognized) {
                $parserUsed = 'Fast'
                $payloads = if ($null -eq $fastResult.Payload) {
                    @()
                }
                else {
                    @($fastResult.Payload)
                }
            }
            elseif ($ParserMode -eq 'Fast') {
                Write-Debug "Fast parser skipped unrecognized file: $InputPath"
                return
            }
            else {
                Write-Debug "Using AST fallback: $InputPath"
            }
        }

        if ($null -eq $parserUsed) {
            $parserUsed = 'Ast'
            $payloads = @(Get-AstPayloads -Source $source -InputPath $InputPath)
        }

        $scanResult = $ansiScannerType::Measure(
            [string[]] $payloads,
            $LetterSet -eq 'Unicode',
            "$TextSymbols$ExtraCharacters"
        )

        if ($scanResult.TextCharacters -eq 0 -and -not $IncludeZero) {
            return [pscustomobject]@{
                File             = $InputPath
                TextCharacters   = 0
                UniqueCharacters = ''
                StringsWithText  = 0
                ParserUsed       = $parserUsed
                IncludeInReport  = $false
            }
        }

        [pscustomobject]@{
            File             = $InputPath
            TextCharacters   = $scanResult.TextCharacters
            UniqueCharacters = $scanResult.UniqueCharacters
            StringsWithText  = $scanResult.StringsWithText
            ParserUsed       = $parserUsed
            IncludeInReport  = $true
        }
    }

    function New-TerminalFileLink {
        param([Parameter(Mandatory)][string] $FullPath)

        $label = switch ($LinkText) {
            'FullPath' {
                $FullPath
                break
            }
            'Relative' {
                [System.IO.Path]::GetRelativePath($displayBasePath, $FullPath)
                break
            }
            default {
                [System.IO.Path]::GetFileName($FullPath)
            }
        }

        $supportsVirtualTerminal = (
            $Host.UI.PSObject.Properties.Name -contains 'SupportsVirtualTerminal' -and
            $Host.UI.SupportsVirtualTerminal
        )
        if ($NoHyperlinks -or -not $supportsVirtualTerminal) {
            return $label
        }

        $fileUri = [System.Uri]::new($FullPath).AbsoluteUri
        $escape = [char] 27
        return "${escape}]8;;${fileUri}${escape}\${label}${escape}]8;;${escape}\"
    }

    $pendingPaths = [System.Collections.Generic.List[string]]::new()
}

process {
    foreach ($item in $Path) {
        $pendingPaths.Add($item)
    }
}

end {
    $pathComparer = if ($IsWindows) {
        [System.StringComparer]::OrdinalIgnoreCase
    }
    else {
        [System.StringComparer]::Ordinal
    }
    $seenPaths = [System.Collections.Generic.HashSet[string]]::new($pathComparer)
    $filePaths = [System.Collections.Generic.List[string]]::new()

    $enumerationOptions = [System.IO.EnumerationOptions]::new()
    $enumerationOptions.RecurseSubdirectories = $Recurse.IsPresent
    $enumerationOptions.IgnoreInaccessible = $true

    foreach ($item in $pendingPaths) {
        $resolvedItem = Get-Item -LiteralPath $item

        if ($resolvedItem.PSIsContainer) {
            foreach ($filePath in [System.IO.Directory]::EnumerateFiles(
                $resolvedItem.FullName,
                '*.ps1',
                $enumerationOptions
            )) {
                $fullPath = [System.IO.Path]::GetFullPath($filePath)
                if ($seenPaths.Add($fullPath)) {
                    $filePaths.Add($fullPath)
                }
            }
        }
        elseif ($resolvedItem.Extension -ieq '.ps1') {
            if ($seenPaths.Add($resolvedItem.FullName)) {
                $filePaths.Add($resolvedItem.FullName)
            }
        }
        else {
            Write-Warning "Skipping non-PowerShell file: '$($resolvedItem.FullName)'"
        }
    }

    $filePaths.Sort($pathComparer)
    $totalFiles = $filePaths.Count
    Write-Verbose (
        "Discovered {0:N0} .ps1 file(s). Parser mode: {1}. Top limits output, not scanning." -f
        $totalFiles,
        $ParserMode
    )

    if ($totalFiles -eq 0) {
        Write-Verbose 'No .ps1 files were found.'
        return
    }

    $reports = [System.Collections.Generic.List[object]]::new()
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $fastFiles = 0
    $astFiles = 0
    $skippedFiles = 0
    $failedFiles = 0
    [long] $processedBytes = 0
    $previousProgressCount = 0
    $previousProgressSeconds = 0.0

    for ($index = 0; $index -lt $totalFiles; $index++) {
        $filePath = $filePaths[$index]
        [long] $currentFileBytes = 0

        try {
            $currentFileBytes = [System.IO.FileInfo]::new($filePath).Length
            $processedBytes += $currentFileBytes
            $measurement = Measure-AnsiSource -InputPath $filePath
            if ($null -eq $measurement) {
                $skippedFiles++
            }
            else {
                if ($measurement.ParserUsed -eq 'Fast') {
                    $fastFiles++
                }
                else {
                    $astFiles++
                }

                if ($measurement.IncludeInReport) {
                    $reports.Add($measurement)
                }
            }
        }
        catch {
            $failedFiles++
            if ($failedFiles -le $MaxFailureWarnings) {
                Write-Warning "Skipping '$filePath': $($_.Exception.Message)"
            }
            elseif ($failedFiles -eq ($MaxFailureWarnings + 1)) {
                Write-Warning (
                    'Further per-file warnings are suppressed. The final summary will include the complete failure count.'
                )
            }
            Write-Debug "Failed '$filePath': $($_.Exception)"
        }

        $processed = $index + 1
        $shouldReportProgress = (
            $processed -eq $totalFiles -or
            $processed % $ProgressInterval -eq 0
        )
        if (-not $shouldReportProgress) {
            continue
        }

        $elapsedSeconds = [Math]::Max($stopwatch.Elapsed.TotalSeconds, 0.001)
        $averageFilesPerSecond = $processed / $elapsedSeconds
        $intervalSeconds = [Math]::Max(
            $elapsedSeconds - $previousProgressSeconds,
            0.001
        )
        $recentFilesPerSecond = (
            ($processed - $previousProgressCount) / $intervalSeconds
        )
        $megabytesPerSecond = (
            ($processedBytes / 1MB) / $elapsedSeconds
        )
        $remainingSeconds = if ($averageFilesPerSecond -gt 0) {
            ($totalFiles - $processed) / $averageFilesPerSecond
        }
        else {
            0
        }
        $eta = [System.TimeSpan]::FromSeconds($remainingSeconds).ToString('hh\:mm\:ss')
        $status = (
            '{0:N0}/{1:N0} | Recent {2:N1}/s | Avg {3:N1}/s | {4:N1} MB/s | ETA {5} | Fast {6:N0} | AST {7:N0}' -f
            $processed,
            $totalFiles,
            $recentFilesPerSecond,
            $averageFilesPerSecond,
            $megabytesPerSecond,
            $eta,
            $fastFiles,
            $astFiles
        )

        if (-not $NoProgress) {
            Write-Progress `
                -Activity 'Analyzing ANSI PowerShell files' `
                -Status $status `
                -PercentComplete (($processed / $totalFiles) * 100)
        }
        Write-Verbose $status
        $previousProgressCount = $processed
        $previousProgressSeconds = $elapsedSeconds
    }

    $stopwatch.Stop()
    if (-not $NoProgress) {
        Write-Progress -Activity 'Analyzing ANSI PowerShell files' -Completed
    }

    $elapsed = $stopwatch.Elapsed.ToString('hh\:mm\:ss\.fff')
    $averageRate = $totalFiles / [Math]::Max($stopwatch.Elapsed.TotalSeconds, 0.001)
    $averageMegabytesPerSecond = (
        ($processedBytes / 1MB) /
        [Math]::Max($stopwatch.Elapsed.TotalSeconds, 0.001)
    )
    Write-Verbose (
        'Finished in {0} ({1:N1} files/s; {2:N1} MB/s). Fast: {3:N0}; AST: {4:N0}; skipped: {5:N0}; failed: {6:N0}; matches: {7:N0}.' -f
        $elapsed,
        $averageRate,
        $averageMegabytesPerSecond,
        $fastFiles,
        $astFiles,
        $skippedFiles,
        $failedFiles,
        $reports.Count
    )

    $sortProperties = @(
        @{ Expression = 'TextCharacters'; Descending = $true }
        @{ Expression = 'File'; Descending = $false }
    )
    $sortedReports = $reports |
        Sort-Object -Property $sortProperties |
        Select-Object -First $Top

    $rank = 0
    foreach ($report in $sortedReports) {
        $rank++
        $result = [pscustomobject]@{
            Rank             = $rank
            TextCharacters   = $report.TextCharacters
            UniqueCharacters = $report.UniqueCharacters
            StringsWithText  = $report.StringsWithText
            File             = New-TerminalFileLink -FullPath $report.File
            FullPath         = $report.File
            ParserUsed       = $report.ParserUsed
        }

        $defaultDisplayProperties = [string[]] @(
            'Rank',
            'TextCharacters',
            'UniqueCharacters',
            'StringsWithText',
            'File'
        )
        $defaultDisplayPropertySet = [System.Management.Automation.PSPropertySet]::new(
            'DefaultDisplayPropertySet',
            $defaultDisplayProperties
        )
        $standardMembers = [System.Management.Automation.PSMemberInfo[]] @(
            $defaultDisplayPropertySet
        )
        $result | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $standardMembers
        $result
    }
}
