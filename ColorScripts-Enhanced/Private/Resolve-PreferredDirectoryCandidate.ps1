function Resolve-PreferredDirectoryCandidate {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$CandidatePaths,
        [scriptblock]$CreateDirectory,
        [scriptblock]$OnCreateFailure,
        [scriptblock]$OnResolutionFailure
    )

    foreach ($candidate in $CandidatePaths) {
        if ([string]::IsNullOrWhiteSpace($candidate)) {
            continue
        }

        $resolved = Resolve-PreferredDirectory -Path $candidate -CreateDirectory $CreateDirectory -OnCreateFailure $OnCreateFailure -OnResolutionFailure $OnResolutionFailure
        if ($resolved) {
            return $resolved
        }
    }

    return $null
}
