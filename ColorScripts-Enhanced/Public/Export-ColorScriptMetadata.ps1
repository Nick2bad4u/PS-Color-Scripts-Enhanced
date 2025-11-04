function Export-ColorScriptMetadata {
    <#
    .SYNOPSIS
    Export the module's colorscript metadata as structured objects or JSON.
    .DESCRIPTION
    Retrieves metadata for each colorscript, including categories and tags, and optionally augments it with
    file system and cache information. The result can be written to a JSON file for consumption by external
    tooling or returned directly to the pipeline.
    .PARAMETER Path
    Destination file path for the JSON output. When omitted, objects are emitted to the pipeline.
    .PARAMETER IncludeFileInfo
    Attach file system information (full path, file size, and last write time) for each colorscript.
    .PARAMETER IncludeCacheInfo
    Attach cache metadata including the cache location, whether a cache file exists, and its timestamp.
    .PARAMETER PassThru
    Return the in-memory objects even when writing to a file.
    .LINK
    https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is a collective noun representing the exported dataset.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata')]
    param(
        [Alias('help')]
        [switch]$h,

        [Parameter()]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,

        [Parameter()]
        [switch]$IncludeFileInfo,

        [Parameter()]
        [switch]$IncludeCacheInfo,

        [Parameter()]
        [switch]$PassThru
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Export-ColorScriptMetadata'
        return
    }

    $records = Get-ColorScriptEntry | Sort-Object Name
    Initialize-CacheDirectory

    $payload = @()

    foreach ($record in $records) {
        $entry = [ordered]@{
            Name        = $record.Name
            Category    = $record.Category
            Categories  = [string[]]$record.Categories
            Tags        = [string[]]$record.Tags
            Description = $record.Description
        }

        if ($IncludeFileInfo) {
            try {
                $fileInfo = Get-Item -LiteralPath $record.Path -ErrorAction Stop
                $entry['ScriptPath'] = $fileInfo.FullName
                $entry['ScriptSizeBytes'] = [int64]$fileInfo.Length
                $entry['ScriptLastWriteTimeUtc'] = $fileInfo.LastWriteTimeUtc
            }
            catch {
                $entry['ScriptPath'] = $record.Path
                $entry['ScriptSizeBytes'] = $null
                $entry['ScriptLastWriteTimeUtc'] = $null
                Write-Verbose ($script:Messages.UnableToRetrieveFileInfo -f $record.Name, $_.Exception.Message)
            }
        }

        if ($IncludeCacheInfo) {
            $cacheFile = if ($script:CacheDir) { Join-Path -Path $script:CacheDir -ChildPath "$( $record.Name ).cache" } else { $null }
            $cacheExists = $false
            $cacheTimestamp = $null

            if ($cacheFile -and (Test-Path -LiteralPath $cacheFile)) {
                $cacheExists = $true
                try {
                    $cacheInfo = Get-Item -LiteralPath $cacheFile -ErrorAction Stop
                    $cacheTimestamp = $cacheInfo.LastWriteTimeUtc
                }
                catch {
                    Write-Verbose ($script:Messages.UnableToReadCacheInfo -f $record.Name, $_.Exception.Message)
                }
            }

            $entry['CachePath'] = $cacheFile
            $entry['CacheExists'] = $cacheExists
            $entry['CacheLastWriteTimeUtc'] = $cacheTimestamp
        }

        $payload += [pscustomobject]$entry
    }

    if ($Path) {
        $resolvedPath = Resolve-CachePath -Path $Path
        if (-not $resolvedPath) {
            Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveOutputPath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidOutputPath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $Path -Cmdlet $PSCmdlet
        }

        if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $resolvedPath -Action 'Export colorscript metadata')) {
            if ($PassThru) {
                return $payload
            }

            return
        }

        $outputDirectory = Split-Path -Path $resolvedPath -Parent
        $directoryReady = $true

        if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
            $directoryReady = Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $outputDirectory -Action 'Create export directory'

            if ($directoryReady) {
                New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            }
        }

        if (-not $directoryReady) {
            if ($PassThru) {
                return $payload
            }

            return
        }

        $json = $payload | ConvertTo-Json -Depth 6
        Set-Content -Path $resolvedPath -Value ($json + [Environment]::NewLine) -Encoding UTF8

        if ($PassThru) {
            return $payload
        }

        return
    }

    return $payload
}
