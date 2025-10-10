#Requires -Version 5.1

# ColorScripts-Enhanced Module
# High-performance colorscripts with intelligent caching

# Module variables
$script:ModuleRoot = $PSScriptRoot
$script:ScriptsPath = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
$script:MetadataPath = Join-Path -Path $PSScriptRoot -ChildPath "ScriptMetadata.psd1"
$script:MetadataCache = $null
$script:PowerShellExecutable = $null

# Cross-platform cache directory
if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
    # Windows: Use APPDATA
    $script:CacheDir = Join-Path -Path $env:APPDATA -ChildPath "ColorScripts-Enhanced" | Join-Path -ChildPath "cache"
}
elseif ($IsMacOS) {
    # macOS: Use Application Support
    $script:CacheDir = Join-Path -Path $HOME -ChildPath "Library" | Join-Path -ChildPath "Application Support" | Join-Path -ChildPath "ColorScripts-Enhanced" | Join-Path -ChildPath "cache"
}
else {
    # Linux: Use XDG_CACHE_HOME or fallback to ~/.cache
    $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath ".cache" }
    $script:CacheDir = Join-Path -Path $xdgCache -ChildPath "ColorScripts-Enhanced"
}

# Ensure cache directory exists
if (-not (Test-Path $script:CacheDir)) {
    New-Item -ItemType Directory -Path $script:CacheDir -Force | Out-Null
}

#region Helper Functions

function Get-PowerShellExecutable {
    if (-not $script:PowerShellExecutable) {
        $candidate = Get-Command -Name pwsh -ErrorAction SilentlyContinue
        if ($candidate -and $candidate.Path) {
            $script:PowerShellExecutable = $candidate.Path
        }
        else {
            try {
                $script:PowerShellExecutable = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
            }
            catch {
                $script:PowerShellExecutable = [System.Environment]::GetCommandLineArgs()[0]
            }
        }
    }

    return $script:PowerShellExecutable
}

function Get-ColorScriptMetadataTable {
    if ($script:MetadataCache) {
        return $script:MetadataCache
    }

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)

    if (Test-Path $script:MetadataPath) {
        $data = Import-PowerShellDataFile -Path $script:MetadataPath

        if ($data -is [hashtable]) {
            $internal = New-Object 'System.Collections.Generic.Dictionary[string, hashtable]' ([System.StringComparer]::OrdinalIgnoreCase)

            $ensureEntry = {
                param($map, $name)

                if (-not $map.ContainsKey($name)) {
                    $map[$name] = @{
                        Category    = $null
                        Categories  = New-Object 'System.Collections.Generic.List[string]'
                        Tags        = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
                        Description = $null
                    }
                }

                return $map[$name]
            }

            if ($data.Categories -is [hashtable]) {
                foreach ($categoryName in $data.Categories.Keys) {
                    $scripts = $data.Categories[$categoryName]
                    foreach ($scriptName in $scripts) {
                        $entry = & $ensureEntry $internal $scriptName
                        if (-not $entry.Categories.Contains($categoryName)) {
                            $null = $entry.Categories.Add($categoryName)
                        }
                        if (-not $entry.Tags.Contains("Category:$categoryName")) {
                            $null = $entry.Tags.Add("Category:$categoryName")
                        }
                        if (-not $entry.Category) {
                            $entry.Category = $categoryName
                        }
                    }
                }
            }

            if ($data.Difficulty -is [hashtable]) {
                foreach ($difficultyLevel in $data.Difficulty.Keys) {
                    foreach ($scriptName in $data.Difficulty[$difficultyLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Difficulty:$difficultyLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Complexity -is [hashtable]) {
                foreach ($complexityLevel in $data.Complexity.Keys) {
                    foreach ($scriptName in $data.Complexity[$complexityLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Complexity:$complexityLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Recommended -is [System.Collections.IEnumerable]) {
                foreach ($scriptName in $data.Recommended) {
                    $entry = & $ensureEntry $internal $scriptName
                    if (-not $entry.Tags.Contains('Recommended')) {
                        $null = $entry.Tags.Add('Recommended')
                    }
                }
            }

            foreach ($key in $internal.Keys) {
                $value = $internal[$key]
                $categoryValue = if ($value.Category) { $value.Category } else { 'Uncategorized' }

                $categoriesValue = @()
                if ($value.Categories -is [System.Collections.IEnumerable] -and $value.Categories -isnot [string]) {
                    $categoriesValue = @($value.Categories | ForEach-Object { [string]$_ })
                }
                elseif ($value.Categories) {
                    $categoriesValue = @([string]$value.Categories)
                }

                $tagsValue = @()
                if ($value.Tags -is [System.Collections.IEnumerable] -and $value.Tags -isnot [string]) {
                    $tagsValue = @($value.Tags | ForEach-Object { [string]$_ })
                }
                elseif ($value.Tags) {
                    $tagsValue = @([string]$value.Tags)
                }

                $store[$key] = [pscustomobject]@{
                    Category    = $categoryValue
                    Categories  = $categoriesValue
                    Tags        = $tagsValue
                    Description = $value.Description
                }
            }
        }
    }

    $script:MetadataCache = $store
    return $script:MetadataCache
}

function Get-ColorScriptEntry {
    param(
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    $metadata = Get-ColorScriptMetadataTable
    $scripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" |
        Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }

    $records = foreach ($script in $scripts) {
        $entry = if ($metadata.ContainsKey($script.BaseName)) { $metadata[$script.BaseName] } else { $null }

        if (-not $entry) {
            $entry = [pscustomobject]@{
                Category    = 'Uncategorized'
                Categories  = @()
                Tags        = @()
                Description = $null
            }
        }

        $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) { [string]$entry.Category } else { 'Uncategorized' }
        $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') { [string[]]$entry.Categories } else { @() }
        $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') { [string[]]$entry.Tags } else { @() }
        $descriptionValue = if ($entry.PSObject.Properties.Name -contains 'Description') { [string]$entry.Description } else { $null }

        [pscustomobject]@{
            Name        = $script.BaseName
            Path        = $script.FullName
            Category    = $categoryValue
            Categories  = $categoriesValue
            Tags        = $tagsValue
            Description = $descriptionValue
            Metadata    = $entry
        }
    }

    if ($Name) {
        $nameSet = $Name | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object { $nameSet -contains $_.Name.ToLowerInvariant() }
    }

    if ($Category) {
        $categorySet = $Category | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordCategories = @($_.Category) + $_.Categories
            $recordCategories = $recordCategories | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($categoryValue in $recordCategories) {
                if ($categorySet -contains $categoryValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    if ($Tag) {
        $tagSet = $Tag | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordTags = $_.Tags | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($tagValue in $recordTags) {
                if ($tagSet -contains $tagValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    return [pscustomobject[]]$records
}

function Get-CachedOutput {
    <#
    .SYNOPSIS
        Retrieves cached output for a colorscript if available and valid.

        The full path to the colorscript file.

    .OUTPUTS
        Returns $true if cache was used, $false otherwise.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if (-not (Test-Path $ScriptPath)) {
        return $false
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    # Check if cache exists and is valid
    if (Test-Path $cacheFile) {
        $scriptTime = (Get-Item $ScriptPath).LastWriteTime
        $cacheTime = (Get-Item $cacheFile).LastWriteTime

        if ($scriptTime -le $cacheTime) {
            # Cache is valid - output it
            $content = [System.IO.File]::ReadAllText($cacheFile)
            $originalEncoding = [Console]::OutputEncoding
            [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
            try {
                [Console]::Write($content)
            }
            finally {
                [Console]::OutputEncoding = $originalEncoding
            }
            return $true
        }
    }

    return $false
}

function Build-ScriptCache {
    <#
    .SYNOPSIS
        Builds cache for a specific colorscript.

        The full path to the colorscript file.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        CacheFile  = $cacheFile
        Success    = $false
        ExitCode   = $null
        StdOut     = ''
        StdErr     = ''
    }

    if (-not (Test-Path $ScriptPath)) {
        $result.StdErr = "Script path not found."
        return $result
    }

    $executable = Get-PowerShellExecutable

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable
        $encodedCommand = "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '$ScriptPath'"
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"$encodedCommand`""
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $errorOutput = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $result.ExitCode = $process.ExitCode
        $result.StdOut = $output
        $result.StdErr = $errorOutput

        if ($process.ExitCode -eq 0) {
            [System.IO.File]::WriteAllText($cacheFile, $output)
            $scriptItem = Get-Item -LiteralPath $ScriptPath
            [System.IO.File]::SetLastWriteTime($cacheFile, $scriptItem.LastWriteTime)
            $result.Success = $true
        }
    }
    catch {
        $result.StdErr = $_.Exception.Message
    }

    return $result
}

#endregion

#region Public Functions

function Show-ColorScript {
    <#
    .SYNOPSIS
        Displays a colorscript with automatic caching.

    .DESCRIPTION
        Shows a beautiful ANSI colorscript in your terminal. If no name is specified,
        displays a random script. Uses intelligent caching for 6-19x faster performance.

    .PARAMETER Name
        The name of the colorscript to display (without .ps1 extension).

    .PARAMETER List
        Lists all available colorscripts.

    .PARAMETER Random
        Display a random colorscript (default behavior).

    .PARAMETER NoCache
        Bypass cache and execute script directly.

    .EXAMPLE
        Show-ColorScript
        Displays a random colorscript.

    .EXAMPLE
        Show-ColorScript -Name "mandelbrot-zoom"
        Displays the mandelbrot-zoom colorscript.

    .EXAMPLE
        Show-ColorScript -List
        Lists all available colorscripts.

    .EXAMPLE
        scs hearts
        Uses the alias to display the hearts colorscript.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Random')]
    [Alias('scs')]
    param(
        [Parameter(ParameterSetName = 'Named', Position = 0)]
        [string]$Name,

        [Parameter(ParameterSetName = 'List')]
        [switch]$List,

        [Parameter(ParameterSetName = 'Random')]
        [switch]$Random,

        [Parameter()]
        [switch]$NoCache,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag,

        [Parameter()]
        [switch]$PassThru
    )

    # Handle list request
    if ($List) {
        Get-ColorScriptList
        return
    }

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag

    if (-not $records) {
        Write-Warning "No colorscripts found in $script:ScriptsPath"
        return
    }

    $useRandom = $Random -or $PSCmdlet.ParameterSetName -eq 'Random'

    $selection = $null

    if ($Name) {
        $selection = $records | Where-Object { $_.Name -eq $Name } | Select-Object -First 1
        if (-not $selection) {
            Write-Warning "Colorscript '$Name' not found with the specified filters."
            return
        }
    }
    elseif ($useRandom) {
        $selection = $records | Get-Random
    }
    else {
        $selection = $records | Select-Object -First 1
    }

    # Try to use cache first (unless NoCache specified)
    if (-not $NoCache) {
        if (Get-CachedOutput -ScriptPath $selection.Path) {
            if ($PassThru) {
                return $selection
            }
            return
        }
    }

    # Execute script directly
    $originalEncoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    try {
        & $selection.Path
    }
    finally {
        [Console]::OutputEncoding = $originalEncoding
    }

    # Build cache for next time if not already cached
    if (-not $NoCache) {
        $cacheResult = Build-ScriptCache -ScriptPath $selection.Path
        if (-not $cacheResult.Success -and $cacheResult.StdErr) {
            Write-Warning "Cache build failed for $($selection.Name): $($cacheResult.StdErr)"
        }
    }

    if ($PassThru) {
        return $selection
    }
}

<#
.SYNOPSIS
Returns metadata-rich information about available color scripts.
.DESCRIPTION
Loads script metadata and optionally filters by category or tag before returning structured objects or displaying a table view.
#>
function Get-ColorScriptList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Structured list is emitted for pipeline consumption.')]
    [CmdletBinding()]
    param(
        [switch]$AsObject,
        [switch]$Detailed,
        [string[]]$Category,
        [string[]]$Tag
    )

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag | Sort-Object Name

    if (-not $records) {
        Write-Warning "No colorscripts available with the specified filters."
        return [System.Object[]]@()
    }

    if (-not $AsObject) {
        $table = if ($Detailed) {
            $records | Select-Object Name, Category, @{ Name = 'Tags'; Expression = { $_.Tags -join ', ' } }, Description
        }
        else {
            $records | Select-Object Name, Category
        }

        $table | Format-Table -AutoSize | Out-String | Write-Host
    }

    return $records
}

<#
.SYNOPSIS
Builds or refreshes the cache for one or more color scripts.
.DESCRIPTION
Uses cached path resolution to execute color scripts and persist their output, honoring Force, WhatIf, and ShouldProcess semantics.
#>
function Build-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Force
    )

    $records = @()

    if ($Name) {
        $records = Get-ColorScriptEntry -Name $Name
        $missing = $Name | Where-Object { $records.Name -notcontains $_ }
        foreach ($item in $missing) {
            Write-Warning "Script not found: $item"
        }
    }
    elseif ($All) {
        $records = Get-ColorScriptEntry
    }
    else {
        throw "Specify -All or -Name to select scripts."
    }

    if (-not $records) {
        Write-Warning "No scripts selected for cache build."
        return [System.Management.Automation.PSCustomObject[]]@()
    }

    if (-not $PSCmdlet.ShouldProcess($script:CacheDir, "Build cache for $($records.Count) script(s)")) {
        return [System.Management.Automation.PSCustomObject[]]@()
    }

    $results = @()

    foreach ($record in $records) {
        $cacheFile = Join-Path $script:CacheDir "$($record.Name).cache"
        $status = 'Updated'

        if (-not $Force -and (Test-Path $cacheFile)) {
            $scriptItem = Get-Item -LiteralPath $record.Path
            $cacheItem = Get-Item -LiteralPath $cacheFile
            if ($cacheItem.LastWriteTime -ge $scriptItem.LastWriteTime) {
                $status = 'SkippedUpToDate'
            }
        }

        if ($status -eq 'SkippedUpToDate') {
            $results += [pscustomobject]@{
                Name      = $record.Name
                Status    = $status
                CacheFile = $cacheFile
                ExitCode  = 0
                StdOut    = ''
                StdErr    = ''
            }
            continue
        }

        if (-not $PSCmdlet.ShouldProcess($record.Name, 'Build cache')) {
            $results += [pscustomobject]@{
                Name      = $record.Name
                Status    = 'SkippedByUser'
                CacheFile = $cacheFile
                ExitCode  = $null
                StdOut    = ''
                StdErr    = ''
            }
            continue
        }

        $buildResult = Build-ScriptCache -ScriptPath $record.Path
        $status = if ($buildResult.Success) { 'Updated' } else { 'Failed' }

        if (-not $buildResult.Success -and $buildResult.StdErr) {
            Write-Warning "Failed to cache $($record.Name): $($buildResult.StdErr)"
        }

        $results += [pscustomobject]@{
            Name      = $record.Name
            Status    = $status
            CacheFile = $buildResult.CacheFile
            ExitCode  = $buildResult.ExitCode
            StdOut    = $buildResult.StdOut
            StdErr    = $buildResult.StdErr
        }
    }

    return [pscustomobject[]]$results
}

<#
.SYNOPSIS
Removes color script cache files with optional dry-run support.
.DESCRIPTION
Clears cached script output for specific scripts or the entire cache directory while providing structured, scriptable results.
#>
function Clear-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache entry.')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Parameter()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$DryRun
    )

    if (-not $Name -and -not $All) {
        throw "Specify -All or -Name to clear cache entries."
    }

    $targetRoot = if ($Path) { $Path } else { $script:CacheDir }

    try {
        $targetRoot = (Resolve-Path -Path $targetRoot -ErrorAction Stop).ProviderPath
    }
    catch {
        Write-Warning "Cache path not found: $targetRoot"
        return [pscustomobject[]]@()
    }

    $results = @()

    if ($Name) {
        foreach ($scriptName in $Name) {
            $cacheFile = Join-Path -Path $targetRoot -ChildPath "$scriptName.cache"
            if (-not (Test-Path -LiteralPath $cacheFile)) {
                $results += [pscustomobject]@{
                    Name      = $scriptName
                    CacheFile = $cacheFile
                    Status    = 'Missing'
                    Message   = 'Cache file not found.'
                }
                continue
            }

            if (-not $PSCmdlet.ShouldProcess($cacheFile, 'Clear cache')) {
                $results += [pscustomobject]@{
                    Name      = $scriptName
                    CacheFile = $cacheFile
                    Status    = 'SkippedByUser'
                    Message   = ''
                }
                continue
            }

            if ($DryRun) {
                $results += [pscustomobject]@{
                    Name      = $scriptName
                    CacheFile = $cacheFile
                    Status    = 'DryRun'
                    Message   = 'No changes applied.'
                }
                continue
            }

            try {
                Remove-Item -LiteralPath $cacheFile -Force -ErrorAction Stop
                $results += [pscustomobject]@{
                    Name      = $scriptName
                    CacheFile = $cacheFile
                    Status    = 'Removed'
                    Message   = ''
                }
            }
            catch {
                $results += [pscustomobject]@{
                    Name      = $scriptName
                    CacheFile = $cacheFile
                    Status    = 'Error'
                    Message   = $_.Exception.Message
                }
            }
        }
    }
    else {
        $cacheFiles = Get-ChildItem -Path $targetRoot -Filter "*.cache" -File -ErrorAction SilentlyContinue
        if (-not $cacheFiles) {
            Write-Warning "No cache files found at $targetRoot."
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        if (-not $PSCmdlet.ShouldProcess($targetRoot, "Clear $($cacheFiles.Count) cache file(s)")) {
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        foreach ($file in $cacheFiles) {
            if ($DryRun) {
                $results += [pscustomobject]@{
                    Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    CacheFile = $file.FullName
                    Status    = 'DryRun'
                    Message   = 'No changes applied.'
                }
                continue
            }

            try {
                Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
                $results += [pscustomobject]@{
                    Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    CacheFile = $file.FullName
                    Status    = 'Removed'
                    Message   = ''
                }
            }
            catch {
                $results += [pscustomobject]@{
                    Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                    CacheFile = $file.FullName
                    Status    = 'Error'
                    Message   = $_.Exception.Message
                }
            }
        }
    }

    return [pscustomobject[]]$results
}

function Add-ColorScriptProfile {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter()]
        [ValidateSet('CurrentUserAllHosts', 'CurrentUserCurrentHost', 'AllUsersAllHosts', 'AllUsersCurrentHost')]
        [string]$Scope = 'CurrentUserAllHosts',

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$SkipStartupScript,

        [Parameter()]
        [switch]$Force
    )

    if ($null -ne $PSSenderInfo) {
        Write-Warning "Profile updates are not supported in remote sessions."
        return [pscustomobject]@{
            Path    = $null
            Changed = $false
            Message = 'Remote session detected.'
        }
    }

    if ($PSBoundParameters.ContainsKey('Path')) {
        $profilePath = $Path
    }
    else {
        $profilePath = $PROFILE.$Scope
    }

    if (-not [System.IO.Path]::IsPathRooted($profilePath)) {
        $profilePath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $profilePath))
    }

    $profileDirectory = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path $profilePath) {
        $existingContent = [System.IO.File]::ReadAllText($profilePath)
    }

    $newline = [Environment]::NewLine
    $timestamp = (Get-Date).ToString('u')
    $snippetLines = @(
        "# Added by ColorScripts-Enhanced on $timestamp",
        'Import-Module ColorScripts-Enhanced'
    )

    if (-not $SkipStartupScript) {
        $snippetLines += 'Show-ColorScript'
    }

    $snippet = ($snippetLines -join $newline)
    $updatedContent = $existingContent

    $pattern = '(?ms)^# Added by ColorScripts-Enhanced.*?(?:\r?\n){2}'
    if ($updatedContent -match $pattern) {
        if (-not $Force) {
            Write-Verbose "Profile already contains ColorScripts-Enhanced snippet."
            return [pscustomobject]@{
                Path    = $profilePath
                Changed = $false
                Message = 'Profile already configured.'
            }
        }

        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $pattern, '', 'MultiLine')
    }

    if ($PSCmdlet.ShouldProcess($profilePath, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $updatedContent.TrimEnd()
        if ($trimmedExisting) {
            $updatedContent = $trimmedExisting + $newline + $newline + $snippet
        }
        else {
            $updatedContent = $snippet
        }

        [System.IO.File]::WriteAllText($profilePath, $updatedContent + $newline, [System.Text.Encoding]::UTF8)

        Write-Host "✓ Added ColorScripts-Enhanced startup snippet to $profilePath" -ForegroundColor Green

        return [pscustomobject] @{
            Path    = $profilePath
            Changed = $true
            Message = 'ColorScripts-Enhanced profile snippet added.'
        }
    }
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Show-ColorScript',
    'Get-ColorScriptList',
    'Build-ColorScriptCache',
    'Clear-ColorScriptCache',
    'Add-ColorScriptProfile'
) -Alias @('scs')

# Module initialization message
Write-Verbose "ColorScripts-Enhanced module loaded. Cache location: $script:CacheDir"
