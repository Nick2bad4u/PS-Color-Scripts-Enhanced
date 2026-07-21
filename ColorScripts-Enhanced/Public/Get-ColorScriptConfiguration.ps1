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

    if (-not $data.Cache) {
        $data.Cache = @{}
    }

    $effectiveCachePath = $script:CacheDir
    if (-not $effectiveCachePath) {
        $candidatePath = if (-not [string]::IsNullOrWhiteSpace($env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH)) {
            $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        }
        elseif ($data.Cache.Path) {
            $data.Cache.Path
        }
        elseif ($script:IsWindows -and $env:APPDATA) {
            Join-Path -Path (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced') -ChildPath 'cache'
        }
        elseif ($script:IsMacOS -and $HOME) {
            $macApplicationSupport = Join-Path -Path (Join-Path -Path $HOME -ChildPath 'Library') -ChildPath 'Application Support'
            Join-Path -Path (Join-Path -Path $macApplicationSupport -ChildPath 'ColorScripts-Enhanced') -ChildPath 'cache'
        }
        elseif ($HOME) {
            $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
            Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced'
        }
        else {
            Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
        }

        $effectiveCachePath = Resolve-CachePath -Path $candidatePath
    }

    $data.Cache.EffectivePath = $effectiveCachePath

    return $data
}
