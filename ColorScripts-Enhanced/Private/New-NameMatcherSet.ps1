function New-NameMatcherSet {
    param(
        [string[]]$Patterns
    )

    $matchers = New-Object 'System.Collections.Generic.List[object]'

    if (-not $Patterns) {
        return $matchers.ToArray()
    }

    foreach ($pattern in $Patterns) {
        if ([string]::IsNullOrWhiteSpace($pattern)) {
            continue
        }

        $hasWildcard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
        if ($hasWildcard) {
            $wildcard = New-Object System.Management.Automation.WildcardPattern ($pattern, [System.Management.Automation.WildcardOptions]::IgnoreCase)
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $wildcard
                    IsWildcard = $true
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
        else {
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $pattern
                    IsWildcard = $false
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
    }

    return $matchers.ToArray()
}
