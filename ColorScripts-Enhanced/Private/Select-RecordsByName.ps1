function ConvertTo-ColorScriptRecordArray {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records
    )

    $recordList = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in $Records) {
        $null = $recordList.Add($record)
    }

    return $recordList.ToArray()
}

function Test-ColorScriptRecordHasName {
    param(
        [Parameter(Mandatory)]
        [object]$Record
    )

    return $record.PSObject.Properties.Name -contains 'Name'
}

function Update-ExactNameMatcherSet {
    param(
        [Parameter(Mandatory)]
        [string]$CandidateName,

        [Parameter(Mandatory)]
        [object[]]$Matchers,

        [Parameter(Mandatory)]
        [ref]$RemainingMatchers
    )

    $recordMatched = $false
    foreach ($matcher in $Matchers) {
        if ($matcher.Matched) {
            continue
        }

        if (-not [System.String]::Equals($CandidateName, [string]$matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        $matcher.Matched = $true
        $RemainingMatchers.Value--
        $null = $matcher.Matches.Add($CandidateName)
        $recordMatched = $true
    }

    return $recordMatched
}

function Select-ExactColorScriptRecord {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [Parameter(Mandatory)]
        [object[]]$Matchers
    )

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    $selected = New-Object 'System.Collections.Generic.List[object]'
    $remainingMatchers = $Matchers.Count

    foreach ($record in $Records) {
        if (-not (Test-ColorScriptRecordHasName -Record $record)) {
            continue
        }

        $candidateName = [string]$record.Name
        $recordMatched = Update-ExactNameMatcherSet -CandidateName $candidateName -Matchers $Matchers -RemainingMatchers ([ref]$remainingMatchers)
        if ($recordMatched -and $selectedNames.Add($candidateName)) {
            $null = $selected.Add($record)
        }

        if ($remainingMatchers -eq 0) {
            break
        }
    }

    return $selected.ToArray()
}

function Test-ColorScriptNameMatcher {
    param(
        [Parameter(Mandatory)]
        [string]$CandidateName,

        [Parameter(Mandatory)]
        [object]$Matcher
    )

    if ($Matcher.IsWildcard) {
        return $Matcher.Matcher.IsMatch($CandidateName)
    }

    return [System.String]::Equals($CandidateName, [string]$Matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)
}

function Update-ColorScriptNameMatcherSet {
    param(
        [Parameter(Mandatory)]
        [string]$CandidateName,

        [Parameter(Mandatory)]
        [object[]]$Matchers
    )

    $recordMatched = $false
    foreach ($matcher in $Matchers) {
        if (-not (Test-ColorScriptNameMatcher -CandidateName $CandidateName -Matcher $matcher)) {
            continue
        }

        $matcher.Matched = $true
        if (-not $matcher.Matches.Contains($CandidateName)) {
            $null = $matcher.Matches.Add($CandidateName)
        }
        $recordMatched = $true
    }

    return $recordMatched
}

function Select-ColorScriptRecordByMatcher {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [Parameter(Mandatory)]
        [object[]]$Matchers
    )

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    $selected = New-Object 'System.Collections.Generic.List[object]'

    foreach ($record in $Records) {
        if (-not (Test-ColorScriptRecordHasName -Record $record)) {
            continue
        }

        $candidateName = [string]$record.Name
        if ((Update-ColorScriptNameMatcherSet -CandidateName $candidateName -Matchers $Matchers) -and $selectedNames.Add($candidateName)) {
            $null = $selected.Add($record)
        }
    }

    return $selected.ToArray()
}

function New-ColorScriptNameSelectionResult {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]]$Records,

        [Parameter(Mandatory)]
        [object[]]$Matchers
    )

    $missing = $Matchers | Where-Object { -not $_.Matched } | ForEach-Object { $_.Pattern }
    $matchMap = $Matchers | ForEach-Object {
        [pscustomobject]@{
            Pattern    = $_.Pattern
            IsWildcard = $_.IsWildcard
            Matched    = $_.Matched
            Matches    = $_.Matches.ToArray()
        }
    }

    return [pscustomobject]@{
        Records         = $Records
        MissingPatterns = [string[]]$missing
        MatchMap        = $matchMap
    }
}

function Select-RecordsByName {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [string[]]$Name
    )

    if (-not $Name -or $Name.Count -eq 0) {
        return [pscustomobject]@{
            Records         = ConvertTo-ColorScriptRecordArray -Records $Records
            MissingPatterns = @()
        }
    }

    $matchers = @(New-NameMatcherSet -Patterns $Name)
    if ($matchers.Count -eq 0) {
        return [pscustomobject]@{
            Records         = @()
            MissingPatterns = @()
        }
    }

    $containsWildcard = @($matchers | Where-Object IsWildcard).Count -gt 0
    $selected = if ($containsWildcard) {
        $recordList = ConvertTo-ColorScriptRecordArray -Records $Records
        Select-ColorScriptRecordByMatcher -Records $recordList -Matchers $matchers
    }
    else {
        Select-ExactColorScriptRecord -Records $Records -Matchers $matchers
    }

    return New-ColorScriptNameSelectionResult -Records @($selected) -Matchers $matchers
}
