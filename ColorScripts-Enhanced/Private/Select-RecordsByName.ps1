function Select-RecordsByName {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [string[]]$Name
    )

    $recordList = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in $Records) {
        $null = $recordList.Add($record)
    }

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    if (-not $Name -or $Name.Count -eq 0) {
        return [pscustomobject]@{
            Records         = $recordList.ToArray()
            MissingPatterns = @()
        }
    }

    $matchers = New-NameMatcherSet -Patterns $Name
    if (-not $matchers -or $matchers.Count -eq 0) {
        return [pscustomobject]@{
            Records         = @()
            MissingPatterns = @()
        }
    }

    $selected = New-Object 'System.Collections.Generic.List[object]'

    foreach ($record in $recordList) {
        if (-not ($record.PSObject.Properties.Name -contains 'Name')) {
            continue
        }

        $candidateName = [string]$record.Name
        $recordMatched = $false

        foreach ($matcher in $matchers) {
            $isMatch = if ($matcher.IsWildcard) {
                $matcher.Matcher.IsMatch($candidateName)
            }
            else {
                [System.String]::Equals($candidateName, [string]$matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)
            }

            if ($isMatch) {
                $matcher.Matched = $true
                if (-not $matcher.Matches.Contains($candidateName)) {
                    $null = $matcher.Matches.Add($candidateName)
                }
                $recordMatched = $true
            }
        }

        if ($recordMatched) {
            if ($selectedNames.Add($candidateName)) {
                $null = $selected.Add($record)
            }
        }
    }

    $missing = $matchers | Where-Object { -not $_.Matched } | ForEach-Object { $_.Pattern }

    $matchMap = $matchers | ForEach-Object {
        [pscustomobject]@{
            Pattern    = $_.Pattern
            IsWildcard = $_.IsWildcard
            Matched    = $_.Matched
            Matches    = $_.Matches.ToArray()
        }
    }

    return [pscustomobject]@{
        Records         = $selected.ToArray()
        MissingPatterns = [string[]]$missing
        MatchMap        = $matchMap
    }
}
