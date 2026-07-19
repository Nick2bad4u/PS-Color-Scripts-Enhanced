function Get-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Get-ColorScriptConfiguration'
        return
    }

    $data = Copy-ColorScriptHashtable (Get-ConfigurationDataInternal)

    try {
        Initialize-CacheDirectory
    }
    catch {
        Write-Verbose ("Unable to resolve the effective cache path: {0}" -f $_.Exception.Message)
    }

    if (-not $data.Cache) {
        $data.Cache = @{}
    }
    $data.Cache.EffectivePath = $script:CacheDir

    return $data
}

