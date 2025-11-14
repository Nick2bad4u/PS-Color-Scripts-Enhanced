function Reset-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [OutputType([hashtable])]
    [CmdletBinding(SupportsShouldProcess = $true, HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration')]
    param(
        [Alias('help')]
        [switch]$h,

        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Reset-ColorScriptConfiguration'
        return
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Reset ColorScripts-Enhanced configuration')) {
        $script:ConfigurationData = Copy-ColorScriptHashtable $script:DefaultConfiguration
        Save-ColorScriptConfiguration -Configuration $script:ConfigurationData -Force
        $script:CacheInitialized = $false
        $script:CacheDir = $null
        $script:CacheValidationPerformed = $false
        $script:CacheValidationManualOverride = $false
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}
