function Add-ColorScriptFileDetail {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Entry,

        [Parameter(Mandatory)]
        [object]$Record
    )

    try {
        $fileInfo = Get-Item -LiteralPath $Record.Path -ErrorAction Stop
        $Entry['ScriptPath'] = $fileInfo.FullName
        $Entry['ScriptSizeBytes'] = [int64]$fileInfo.Length
        $Entry['ScriptLastWriteTimeUtc'] = $fileInfo.LastWriteTimeUtc
    }
    catch {
        $Entry['ScriptPath'] = $Record.Path
        $Entry['ScriptSizeBytes'] = $null
        $Entry['ScriptLastWriteTimeUtc'] = $null
        Write-Verbose ($script:Messages.UnableToRetrieveFileInfo -f $Record.Name, $_.Exception.Message)
    }
}

function Add-ColorScriptCacheDetail {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary]$Entry,

        [Parameter(Mandatory)]
        [object]$Record
    )

    $cacheFile = if ($script:CacheDir) {
        Join-Path -Path $script:CacheDir -ChildPath "$( $Record.Name ).cache"
    }
    else {
        $null
    }

    $cacheExists = $false
    $cacheTimestamp = $null
    if ($cacheFile -and (Test-Path -LiteralPath $cacheFile)) {
        $cacheExists = $true
        try {
            $cacheInfo = Get-Item -LiteralPath $cacheFile -ErrorAction Stop
            $cacheTimestamp = $cacheInfo.LastWriteTimeUtc
        }
        catch {
            Write-Verbose ($script:Messages.UnableToReadCacheInfo -f $Record.Name, $_.Exception.Message)
        }
    }

    $Entry['CachePath'] = $cacheFile
    $Entry['CacheExists'] = $cacheExists
    $Entry['CacheLastWriteTimeUtc'] = $cacheTimestamp
}

function ConvertTo-ColorScriptMetadataPayload {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [object[]]$Records,

        [switch]$IncludeFileInfo,
        [switch]$IncludeCacheInfo
    )

    [pscustomobject[]]$payload = @(foreach ($record in $Records) {
            $entry = [ordered]@{
                Name        = $record.Name
                Category    = $record.Category
                Categories  = [string[]]$record.Categories
                Tags        = [string[]]$record.Tags
                Description = $record.Description
            }

            if ($IncludeFileInfo) {
                Add-ColorScriptFileDetail -Entry $entry -Record $record
            }

            if ($IncludeCacheInfo) {
                Add-ColorScriptCacheDetail -Entry $entry -Record $record
            }

            [pscustomobject]$entry
        })

    return $payload
}

function Export-ColorScriptMetadataPayload {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [pscustomobject[]]$Payload,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $resolvedPath = Resolve-CachePath -Path $Path
    if (-not $resolvedPath) {
        Invoke-ColorScriptError -Message ($script:Messages.UnableToResolveOutputPath -f $Path) -ErrorId 'ColorScriptsEnhanced.InvalidOutputPath' -Category ([System.Management.Automation.ErrorCategory]::InvalidArgument) -TargetObject $Path -Cmdlet $Cmdlet
    }

    if (-not (Invoke-ShouldProcess -Cmdlet $Cmdlet -Target $resolvedPath -Action 'Export colorscript metadata')) {
        return
    }

    $outputDirectory = Split-Path -Path $resolvedPath -Parent
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        if (-not (Invoke-ShouldProcess -Cmdlet $Cmdlet -Target $outputDirectory -Action 'Create export directory')) {
            return
        }

        New-Item -ItemType Directory -Path $outputDirectory -Force -ErrorAction Stop | Out-Null
    }

    $json = $Payload | ConvertTo-Json -Depth 6
    Invoke-FileWriteAllText -Path $resolvedPath -Content ($json + [Environment]::NewLine) -Encoding $script:Utf8NoBomEncoding
}

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
    Attach the raw .cache payload path, file-presence flag, and last-write timestamp. These fields do
    not report cache-policy eligibility, .cacheinfo sidecar presence, validity, or currentness.
    .PARAMETER PassThru
    Return the in-memory objects even when writing to a file.
    .LINK
    https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is a collective noun representing the exported dataset.')]
    [OutputType([pscustomobject[]], [object[]])]
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
    if ($IncludeCacheInfo) {
        Initialize-CacheDirectory
    }

    [pscustomobject[]]$payload = @(ConvertTo-ColorScriptMetadataPayload -Records $records -IncludeFileInfo:$IncludeFileInfo -IncludeCacheInfo:$IncludeCacheInfo)
    if (-not $Path) {
        return $payload
    }

    Export-ColorScriptMetadataPayload -Payload $payload -Path $Path -Cmdlet $PSCmdlet
    if ($PassThru) {
        return $payload
    }
}
