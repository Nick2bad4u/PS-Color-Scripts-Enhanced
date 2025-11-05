function New-ColorScriptAnsiText {
    param(
        [AllowNull()][string]$Text,
        [string]$Color,
        [switch]$NoAnsiOutput
    )

    $resolvedText = if ($null -ne $Text) { [string]$Text } else { '' }

    if ($NoAnsiOutput) {
        return $resolvedText
    }

    $sequence = Get-ColorScriptAnsiSequence -Color $Color
    if (-not $sequence) {
        return $resolvedText
    }

    return "${sequence}${resolvedText}${([char]27)}[0m"
}
