function Test-ColorScriptIsBundledPath {
    <#
    .SYNOPSIS
        Verifies that a path identifies a regular file in the bundled Scripts directory.

    .DESCRIPTION
        Policy files contain script names, but a matching base name alone is not a trust
        boundary. This helper resolves both the supplied path and the expected package path,
        rejects links/reparse points, and compares the resulting provider paths using the
        platform-appropriate case sensitivity.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptPath,

        [Parameter()]
        [string]$ScriptName
    )

    if ([string]::IsNullOrWhiteSpace($script:ScriptsPath)) {
        return $false
    }

    $expectedName = if ([string]::IsNullOrWhiteSpace($ScriptName)) {
        [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    }
    else {
        $ScriptName
    }

    if ([string]::IsNullOrWhiteSpace($expectedName) -or
        $expectedName.IndexOfAny([char[]]@('/', '\')) -ge 0) {
        return $false
    }

    try {
        $actualItem = Get-Item -LiteralPath $ScriptPath -Force -ErrorAction Stop
        $expectedPath = Join-Path -Path $script:ScriptsPath -ChildPath ($expectedName + '.ps1')
        $expectedItem = Get-Item -LiteralPath $expectedPath -Force -ErrorAction Stop

        if ($actualItem.PSIsContainer -or $expectedItem.PSIsContainer) {
            return $false
        }

        $reparsePoint = [System.IO.FileAttributes]::ReparsePoint
        if (($actualItem.Attributes -band $reparsePoint) -ne 0 -or
            ($expectedItem.Attributes -band $reparsePoint) -ne 0) {
            return $false
        }

        $actualPath = (Resolve-Path -LiteralPath $actualItem.FullName -ErrorAction Stop).ProviderPath
        $expectedResolvedPath = (Resolve-Path -LiteralPath $expectedItem.FullName -ErrorAction Stop).ProviderPath
        $comparison = if ([System.IO.Path]::DirectorySeparatorChar -eq '\') {
            [System.StringComparison]::OrdinalIgnoreCase
        }
        else {
            [System.StringComparison]::Ordinal
        }

        return [string]::Equals($actualPath, $expectedResolvedPath, $comparison)
    }
    catch {
        Write-Verbose ("Unable to validate bundled colorscript path '{0}': {1}" -f $ScriptPath, $_.Exception.Message)
        return $false
    }
}
