function Get-ColorScriptAnsiSequence {
    param([string]$Color)

    if ([string]::IsNullOrWhiteSpace($Color)) {
        return $null
    }

    switch ($Color.ToLowerInvariant()) {
        'cyan' { return "${([char]27)}[36m" }
        'yellow' { return "${([char]27)}[33m" }
        'green' { return "${([char]27)}[32m" }
        'magenta' { return "${([char]27)}[35m" }
        'darkgray' { return "${([char]27)}[90m" }
        'red' { return "${([char]27)}[31m" }
        'blue' { return "${([char]27)}[34m" }
        default { return $null }
    }
}
