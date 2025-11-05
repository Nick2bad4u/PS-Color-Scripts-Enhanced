function Remove-ColorScriptAnsiSequence {
    param([AllowNull()][string]$Text)

    if ($null -eq $Text) {
        return $Text
    }

    if (-not $script:AnsiStripRegex) {
        $pattern = "${([char]27)}\[[0-9;]*[A-Za-z]"
        $script:AnsiStripRegex = [System.Text.RegularExpressions.Regex]::new(
            $pattern,
            [System.Text.RegularExpressions.RegexOptions]::Compiled
        )
    }

    return $script:AnsiStripRegex.Replace([string]$Text, '')
}
