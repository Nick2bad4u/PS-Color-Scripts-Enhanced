function Get-PokemonScriptNameSet {
    [CmdletBinding()]
    param()

    # Cache per-module to avoid repeated parsing
    if ($script:PokemonScriptNameSet -is [System.Collections.Generic.HashSet[string]]) {
        return $script:PokemonScriptNameSet
    }

    $nameMatches = @()

    if ($script:MetadataPath -and (Test-Path -LiteralPath $script:MetadataPath)) {
        try {
            $raw = Get-Content -LiteralPath $script:MetadataPath -Raw -ErrorAction Stop
            if (-not [string]::IsNullOrWhiteSpace($raw)) {
                # Extract the body of the Pokemon category array: Pokemon = @(...)
                $regex = [System.Text.RegularExpressions.Regex]::new(
                    'Pokemon\s*=\s*@\((?<body>.*?)\)',
                    [System.Text.RegularExpressions.RegexOptions]::Singleline
                )

                $match = $regex.Match($raw)
                if ($match.Success) {
                    $body = $match.Groups['body'].Value
                    # Capture all single-quoted string literals inside the body
                    $nameMatches = [System.Text.RegularExpressions.Regex]::Matches(
                        $body,
                        "'([^']+)'"
                    )
                }
            }
        }
        catch {
            # If anything goes wrong, fall back to an empty set rather than failing the caller
            $nameMatches = @()
        }
    }

    $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($m in $nameMatches) {
        $value = $m.Groups[1].Value
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $null = $set.Add($value)
        }
    }

    $script:PokemonScriptNameSet = $set
    return $set
}
