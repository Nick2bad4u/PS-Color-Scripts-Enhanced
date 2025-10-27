param(
    [Parameter()]
    [string]$OutputPath = 'coverage.clixml',

    [Parameter()]
    [string[]]$CoveragePath = @('./ColorScripts-Enhanced/ColorScripts-Enhanced.psm1')
)

$configuration = New-PesterConfiguration
$configuration.Run.Path = @('./Tests')
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.Path = $CoveragePath

$result = Invoke-Pester -Configuration $configuration
$result | Export-Clixml -Path $OutputPath
