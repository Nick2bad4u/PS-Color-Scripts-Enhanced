function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath)) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
    }

    if (-not $script:CacheDir) {
        try {
            Initialize-CacheDirectory
        }
        catch {
            Write-Verbose "Initialize-CacheDirectory failed: $($_.Exception.Message)"
        }
    }

    if (-not $script:CacheDir) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path -Path $script:CacheDir -ChildPath ("{0}.cache" -f $scriptName)

    try {
        $scriptFileExists = $false
        try {
            $scriptFileExists = & $script:FileExistsDelegate $ScriptPath
        }
        catch {
            Write-Verbose "Unable to verify script existence for ${ScriptPath}: $($_.Exception.Message)"
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not $scriptFileExists) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $null
                Content       = ''
                LastWriteTime = $null
            }
        }

        if (-not (Test-Path -LiteralPath $cacheFile)) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $null
            }
        }

        $scriptLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $ScriptPath
        $cacheLastWrite = & $script:FileGetLastWriteTimeUtcDelegate $cacheFile

        if ($scriptLastWrite -gt $cacheLastWrite) {
            return [pscustomobject]@{
                Available     = $false
                CacheFile     = $cacheFile
                Content       = ''
                LastWriteTime = $cacheLastWrite
            }
        }

        $content = & $script:FileReadAllTextDelegate $cacheFile $script:Utf8NoBomEncoding

        return [pscustomobject]@{
            Available     = $true
            CacheFile     = $cacheFile
            Content       = $content
            LastWriteTime = $cacheLastWrite
        }
    }
    catch {
        Write-Verbose "Cache read error for $ScriptPath : $($_.Exception.Message)"
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $null
        }
    }
}
