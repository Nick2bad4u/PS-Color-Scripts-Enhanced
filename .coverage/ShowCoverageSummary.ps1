param(
    [string]$Path = (Join-Path $PSScriptRoot 'coverage.clixml'),
    [int]$Top = 20,
    [string]$Function
)

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Error "Coverage file '$Path' not found."
    exit 1
}

$cov = Import-Clixml -Path $Path
$missed = $cov.CodeCoverage.CommandsMissed

if ($Function) {
    $functionMisses = $missed | Where-Object { $_.Function -eq $Function }
    if (-not $functionMisses) {
        Write-Host "No missed commands recorded for function '$Function'."
        return
    }

    foreach ($miss in $functionMisses) {
        $location = "{0}:{1}" -f $miss.File, $miss.StartLine
        Write-Host $location -ForegroundColor Cyan
        if ($miss.Command) {
            Write-Host "    $($miss.Command)"
        }
        else {
            Write-Host "    [No command text captured]"
        }
        Write-Host
    }
    return
}

$groups = $missed | Group-Object Function | Sort-Object Count -Descending
$groups | Select-Object -First $Top | Format-Table -AutoSize
