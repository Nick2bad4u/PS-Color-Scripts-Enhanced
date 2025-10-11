#Requires -Version 5.1

# ColorScripts-Enhanced Module
# High-performance colorscripts with intelligent caching

# Module variables
$script:ModuleRoot = $PSScriptRoot
$script:ScriptsPath = Join-Path -Path $PSScriptRoot -ChildPath "Scripts"
$script:MetadataPath = Join-Path -Path $PSScriptRoot -ChildPath "ScriptMetadata.psd1"
$script:MetadataCache = $null
$script:MetadataLastWriteTime = $null
$script:PowerShellExecutable = $null
$script:Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
$script:CacheDir = $null
$script:CacheInitialized = $false
$script:DefaultAutoCategoryRules = @(
    [pscustomobject]@{
        Category = 'System'
        Tags     = @('System', 'Utility')
        Patterns = @(
            '^(00default|alpha)$',
            '^ansi-palette$',
            '^awk-rgb-test$',
            '^colortest(-slim)?$',
            '^colorbars$',
            '^colorview$',
            '^colorwheel$',
            '^(A{6}|O{6})$',
            '^nerd-font-(glyphs|test)$',
            '^rgb-spectrum$',
            '^RGB-Wave(-Shifted)?$',
            '^spectrum(-flames)?$',
            '^terminal-benchmark$',
            '^text-styles$',
            '^unicode-showcase$',
            '^gradient-test$'
        )
    },
    [pscustomobject]@{
        Category = 'TerminalThemes'
        Tags     = @('Terminal', 'Theme')
        Patterns = @('^terminal($|-.*)')
    },
    [pscustomobject]@{
        Category = 'Logos'
        Tags     = @('Logo')
        Patterns = @('arch', 'debian', 'manjaro', 'kaisen', 'tux', 'xmonad', 'suckless', 'android', 'apple', 'windows', 'ubuntu', 'pinguco', 'crunchbang', 'amiga')
    },
    [pscustomobject]@{
        Category = 'Gaming'
        Tags     = @('Gaming', 'PopCulture')
        Patterns = @('doom', 'pacman', 'space-invaders', 'tiefighter', 'rally-x', 'tanks', 'guns', 'pukeskull', 'rupees', 'unowns', 'jangofett', 'darthvader')
    },
    [pscustomobject]@{
        Category = 'ASCIIArt'
        Tags     = @('ASCIIArt')
        Patterns = @('cats', 'crabs', 'crowns', 'elfman', 'faces', '^hearts[0-9]*$', 'kevin-woods', 'monster', '^mouseface', 'pinguco', '^thebat', 'thisisfine', '^welcome-', 'ghosts', 'bears', 'hedgehogs', '^tvs$', 'pukeskull')
    },
    [pscustomobject]@{
        Category = 'Physics'
        Tags     = @('Physics')
        Patterns = @('boids', 'cyclone', 'domain', '\bdla\b', '\bdna\b', 'lightning', 'nbody', 'particle', 'perlin', 'plasma', 'sandpile', '\bsdf\b', 'solar-system', 'verlet', 'waveform', 'wavelet', 'wave-interference', 'wave-pattern', 'vector-streams', 'vortex', 'orbit', 'field', 'life', 'langton', 'electrostatic')
    },
    [pscustomobject]@{
        Category = 'Nature'
        Tags     = @('Nature')
        Patterns = @('aurora', 'nebula', 'galaxy', 'forest', 'crystal', 'fern', 'dunes', 'twilight', 'starlit', 'cloud', 'horizon', 'cosmic', 'enchanted')
    },
    [pscustomobject]@{
        Category = 'Mathematical'
        Tags     = @('Mathematical')
        Patterns = @('apollonian', 'barnsley', 'binary-tree', 'clifford', 'fourier', 'fractal', 'hilbert', 'koch', 'lissajous', 'mandelbrot', 'newton', 'penrose', 'pythagorean', 'quasicrystal', 'rossler', 'sierpinski', 'circle-packing', 'lorenz', 'julia', 'lsystem', 'voronoi', 'iso-cubes')
    },
    [pscustomobject]@{
        Category = 'Artistic'
        Tags     = @('Artistic')
        Patterns = @('braid', 'chromatic', 'chrono', 'city', 'ember', 'kaleidoscope', 'mandala', 'mosaic', 'prismatic', 'midnight', 'illumina', 'inkblot', 'pixel', 'sunburst', 'fade', 'starlit', 'twilight', 'rainbow', 'matrix')
    },
    [pscustomobject]@{
        Category = 'Patterns'
        Tags     = @('Pattern')
        Patterns = @('bars?', 'block', 'blok', 'grid', 'maze', 'spiral', 'wave', 'zigzag', 'tile', 'lattice', 'hex', 'ring', 'polygon', 'prism', 'tessell', 'iso', 'quasicrystal', 'rail', 'pane', 'truchet', 'pattern', 'panes', 'rails', 'circle', 'square', 'triangles', 'gradient', 'voronoi', 'radial', '^six$')
    }
)

#region Helper Functions

function Resolve-CachePath {
    param(
        [string]$Path
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }

    $expanded = [System.Environment]::ExpandEnvironmentVariables($Path)
    $candidate = $expanded

    $qualifier = $null
    try {
        $qualifier = Split-Path -Path $expanded -Qualifier -ErrorAction Stop
    }
    catch {
        $qualifier = $null
    }

    if ($qualifier -and $qualifier -notlike '\\*') {
        $driveName = $qualifier.TrimEnd(':', '\')
        if (-not (Get-PSDrive -Name $driveName -ErrorAction SilentlyContinue)) {
            return $null
        }
    }

    if (-not [System.IO.Path]::IsPathRooted($expanded)) {
        try {
            $basePath = (Get-Location).ProviderPath
        }
        catch {
            $basePath = [System.IO.Directory]::GetCurrentDirectory()
        }

        $candidate = Join-Path -Path $basePath -ChildPath $expanded
    }

    try {
        return [System.IO.Path]::GetFullPath($candidate)
    }
    catch {
        Write-Verbose "Unable to resolve cache path '$Path': $($_.Exception.Message)"
        return $null
    }
}

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

function Invoke-WithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock,
        [object[]]$Arguments
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not [Console]::IsOutputRedirected) {
        try {
            $originalEncoding = [Console]::OutputEncoding
            if ($originalEncoding.WebName -ne 'utf-8') {
                [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
                $encodingChanged = $true
            }
        }
        catch [System.IO.IOException] {
            $originalEncoding = $null
            $encodingChanged = $false
            Write-Verbose 'Console handle unavailable; skipping OutputEncoding change.'
        }
    }

    try {
        if ($Arguments) {
            return & $ScriptBlock @Arguments
        }

        return & $ScriptBlock
    }
    finally {
        if ($encodingChanged -and $originalEncoding) {
            try {
                [Console]::OutputEncoding = $originalEncoding
            }
            catch [System.IO.IOException] {
                Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding.'
            }
        }
    }
}

function Initialize-CacheDirectory {
    if ($script:CacheInitialized -and $script:CacheDir) {
        return
    }

    $overrideCacheRoot = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
    $resolvedOverride = $null

    if ($overrideCacheRoot) {
        $resolvedOverride = Resolve-CachePath -Path $overrideCacheRoot
        if (-not $resolvedOverride) {
            Write-Verbose "Ignoring COLOR_SCRIPTS_ENHANCED_CACHE_PATH override '$overrideCacheRoot' because the path could not be resolved."
        }
    }

    $candidatePaths = @()

    if ($resolvedOverride) {
        $candidatePaths += $resolvedOverride
    }

    if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $windowsBase = Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced'
            $candidatePaths += (Join-Path -Path $windowsBase -ChildPath 'cache')
        }
    }
    elseif ($IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $macBase = Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced'
        $candidatePaths += (Join-Path -Path $macBase -ChildPath 'cache')
    }
    else {
        $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath '.cache' }
        if ($xdgCache) {
            $candidatePaths += (Join-Path -Path $xdgCache -ChildPath 'ColorScripts-Enhanced')
        }
    }

    $candidatePaths = $candidatePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($candidate in $candidatePaths) {
        $target = Resolve-CachePath -Path $candidate
        if (-not $target) {
            Write-Verbose "Skipping cache candidate '$candidate' because it could not be resolved."
            continue
        }

        try {
            if (-not (Test-Path -LiteralPath $target)) {
                New-Item -ItemType Directory -Path $target -Force -ErrorAction Stop | Out-Null
            }

            try {
                $resolvedPhysicalPath = (Resolve-Path -LiteralPath $target -ErrorAction Stop).ProviderPath
            }
            catch {
                $resolvedPhysicalPath = $target
            }

            $script:CacheDir = $resolvedPhysicalPath
            $script:CacheInitialized = $true
            return
        }
        catch {
            Write-Warning "Unable to prepare cache directory '$target': $($_.Exception.Message)"
        }
    }

    $fallback = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'ColorScripts-Enhanced'
    if (-not (Test-Path -LiteralPath $fallback)) {
        New-Item -ItemType Directory -Path $fallback -Force -ErrorAction Stop | Out-Null
    }

    try {
        $resolvedFallback = (Resolve-Path -LiteralPath $fallback -ErrorAction Stop).ProviderPath
    }
    catch {
        $resolvedFallback = $fallback
    }

    $script:CacheDir = $resolvedFallback
    $script:CacheInitialized = $true
}

Initialize-CacheDirectory

function Get-ColorScriptMetadataTable {
    $currentTimestamp = $null
    if (Test-Path $script:MetadataPath) {
        try {
            $currentTimestamp = (Get-Item -LiteralPath $script:MetadataPath).LastWriteTimeUtc
        }
        catch {
            Write-Verbose "Unable to determine metadata timestamp: $($_.Exception.Message)"
        }
    }

    if ($script:MetadataCache -and $script:MetadataLastWriteTime -and $currentTimestamp -eq $script:MetadataLastWriteTime) {
        return $script:MetadataCache
    }

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)

    $mergeUnique = {
        param(
            [string[]]$existing,
            [string[]]$additional
        )

        $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        $list = New-Object 'System.Collections.Generic.List[string]'

        if ($existing) {
            foreach ($value in $existing) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        if ($additional) {
            foreach ($value in $additional) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        return $list.ToArray()
    }

    $data = $null

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
                    $scriptsForCategory = $data.Categories[$categoryName]
                    foreach ($scriptName in $scriptsForCategory) {
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

    $autoRules = @()

    if ($data -is [hashtable] -and $data.ContainsKey('AutoCategories') -and $data.AutoCategories -is [System.Collections.IEnumerable]) {
        foreach ($rule in $data.AutoCategories) {
            $categoryName = $rule.Category
            if ([string]::IsNullOrWhiteSpace($categoryName)) {
                continue
            }

            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                foreach ($pattern in $rule.Patterns) {
                    $patternValue = [string]$pattern
                    if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                        $patterns += $patternValue
                    }
                }
            }
            elseif ($rule.Patterns) {
                $patternValue = [string]$rule.Patterns
                if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                    $patterns += $patternValue
                }
            }

            if ($patterns.Count -eq 0) {
                continue
            }

            $tags = @()
            if ($rule.Tags -is [System.Collections.IEnumerable]) {
                foreach ($tag in $rule.Tags) {
                    $tagValue = [string]$tag
                    if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                        $tags += $tagValue
                    }
                }
            }
            elseif ($rule.Tags) {
                $tagValue = [string]$rule.Tags
                if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                    $tags += $tagValue
                }
            }

            $autoRules += [pscustomobject]@{
                Category = [string]$categoryName
                Patterns = $patterns
                Tags     = $tags
            }
        }
    }

    if ($autoRules.Count -eq 0) {
        $autoRules = $script:DefaultAutoCategoryRules
    }

    $resolveAutoCategory = {
        param([string]$Name)

        $matchedCategories = New-Object 'System.Collections.Generic.List[string]'
        $matchedTags = New-Object 'System.Collections.Generic.List[string]'

        foreach ($rule in $autoRules) {
            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                $patterns = $rule.Patterns
            }
            elseif ($rule.Patterns) {
                $patterns = @($rule.Patterns)
            }

            foreach ($pattern in $patterns) {
                $patternValue = [string]$pattern
                if ([string]::IsNullOrWhiteSpace($patternValue)) { continue }
                if ([System.Text.RegularExpressions.Regex]::IsMatch($Name, $patternValue, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                    if (-not $matchedCategories.Contains($rule.Category)) {
                        $null = $matchedCategories.Add([string]$rule.Category)
                    }

                    if ($rule.Tags -is [System.Collections.IEnumerable]) {
                        foreach ($tag in $rule.Tags) {
                            $tagValue = [string]$tag
                            if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                                $null = $matchedTags.Add($tagValue)
                            }
                        }
                    }
                    elseif ($rule.Tags) {
                        $tagValue = [string]$rule.Tags
                        if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                            $null = $matchedTags.Add($tagValue)
                        }
                    }

                    break
                }
            }
        }

        if ($matchedCategories.Count -eq 0) {
            $null = $matchedCategories.Add('Abstract')
        }

        [pscustomobject]@{
            Categories = [string[]]$matchedCategories.ToArray()
            Tags       = [string[]]$matchedTags.ToArray()
        }
    }

    $scripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1" |
        Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }

    foreach ($scriptFile in $scripts) {
        $name = $scriptFile.BaseName
        $entryExists = $store.ContainsKey($name)
        $existingEntry = if ($entryExists) {
            $store[$name]
        }
        else {
            [pscustomobject]@{
                Category    = 'Uncategorized'
                Categories  = @()
                Tags        = @()
                Description = $null
            }
        }

        $needsAuto = -not $entryExists -or [string]::IsNullOrWhiteSpace($existingEntry.Category) -or $existingEntry.Category -eq 'Uncategorized'

        if ($needsAuto) {
            $autoInfo = & $resolveAutoCategory $name
            $autoCategories = if ($autoInfo.Categories) { [string[]]$autoInfo.Categories } else { @('Abstract') }
            $autoTags = if ($autoInfo.Tags) { [string[]]$autoInfo.Tags } else { @() }

            $baseCategories = @()
            if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') {
                $baseCategories += [string]$existingEntry.Category
            }
            if ($existingEntry.Categories) {
                foreach ($cat in [string[]]$existingEntry.Categories) {
                    if (-not [string]::IsNullOrWhiteSpace($cat) -and $cat -ne 'Uncategorized') {
                        $baseCategories += $cat
                    }
                }
            }

            $categories = [string[]](& $mergeUnique $baseCategories $autoCategories)
            if (-not $categories -or $categories.Length -eq 0) {
                $categories = @('Abstract')
            }

            $newCategory = if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') { [string]$existingEntry.Category } else { $categories[0] }

            $existingTags = @()
            if ($existingEntry.Tags) {
                $existingTags = [string[]]$existingEntry.Tags
            }

            $autoTagList = @()
            if ($autoTags) { $autoTagList += $autoTags }
            $autoTagList += ($categories | ForEach-Object { "Category:$($_)" })
            $autoTagList += 'AutoCategorized'

            $tags = [string[]](& $mergeUnique $existingTags $autoTagList)

            $store[$name] = [pscustomobject]@{
                Category    = $newCategory
                Categories  = $categories
                Tags        = $tags
                Description = $existingEntry.Description
            }
        }
    }

    foreach ($key in @($store.Keys)) {
        $entry = $store[$key]

        $baseCategories = @()
        if ($entry.Category -and $entry.Category -ne 'Uncategorized') {
            $baseCategories += [string]$entry.Category
        }
        if ($entry.Categories) {
            foreach ($cat in [string[]]$entry.Categories) {
                if (-not [string]::IsNullOrWhiteSpace($cat)) {
                    $baseCategories += $cat
                }
            }
        }

        if (-not $baseCategories -or $baseCategories.Count -eq 0) {
            $baseCategories = @('Abstract')
        }

        $categories = [string[]](& $mergeUnique @() $baseCategories)
        if (-not $categories -or $categories.Length -eq 0) {
            $categories = @('Abstract')
        }

        $existingTags = @()
        if ($entry.Tags) {
            $existingTags = [string[]]$entry.Tags
        }

        $categoryTags = $categories | ForEach-Object { "Category:$($_)" }
        $tags = [string[]](& $mergeUnique $existingTags $categoryTags)

        $store[$key] = [pscustomobject]@{
            Category    = $categories[0]
            Categories  = $categories
            Tags        = $tags
            Description = $entry.Description
        }
    }

    $script:MetadataCache = $store
    $script:MetadataLastWriteTime = $currentTimestamp
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
                Category    = 'Abstract'
                Categories  = @('Abstract')
                Tags        = @('Category:Abstract', 'AutoCategorized')
                Description = $null
            }
        }

        $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) { [string]$entry.Category } else { 'Abstract' }
        $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') { [string[]]$entry.Categories } else { @() }
        if (-not $categoriesValue -or $categoriesValue.Count -eq 0) {
            $categoriesValue = @($categoryValue)
        }

        $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') { [string[]]$entry.Tags } else { @() }
        if (-not $tagsValue -or $tagsValue.Count -eq 0) {
            $tagsValue = @("Category:$categoryValue")
        }
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
            Invoke-WithUtf8Encoding -ScriptBlock {
                param($text)

                try {
                    [Console]::Write($text)
                }
                catch [System.IO.IOException] {
                    Write-Verbose 'Console handle unavailable; routing cached output through Write-Output.'
                    Write-Output $text
                }
            } -Arguments $content
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
        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $encodedCommand = "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '$escapedScriptPath'"
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
            [System.IO.File]::WriteAllText($cacheFile, $output, $script:Utf8NoBomEncoding)
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
    Invoke-WithUtf8Encoding -ScriptBlock {
        param($scriptPath)
        & $scriptPath
    } -Arguments $selection.Path

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

    $importPattern = '(?mi)^\s*Import-Module\s+ColorScripts-Enhanced\b.*$'

    if (-not $Force -and $existingContent -match $importPattern) {
        Write-Verbose "Profile already imports ColorScripts-Enhanced."
        return [pscustomobject]@{
            Path    = $profilePath
            Changed = $false
            Message = 'Profile already configured.'
        }
    }

    if ($Force) {
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $importPattern + '(?:\r?\n)?', '', 'Multiline')
        $showPattern = '(?mi)^\s*(Show-ColorScript|scs)\b.*(?:\r?\n)?'
        $updatedContent = [System.Text.RegularExpressions.Regex]::Replace($updatedContent, $showPattern, '', 'Multiline')
    }

    if ($PSCmdlet.ShouldProcess($profilePath, 'Add ColorScripts-Enhanced profile snippet')) {
        $trimmedExisting = $updatedContent.TrimEnd()
        if ($trimmedExisting) {
            $updatedContent = $trimmedExisting + $newline + $newline + $snippet
        }
        else {
            $updatedContent = $snippet
        }

        [System.IO.File]::WriteAllText($profilePath, $updatedContent + $newline, $script:Utf8NoBomEncoding)

        Write-Host "✓ Added ColorScripts-Enhanced startup snippet to $profilePath" -ForegroundColor Green

        return [pscustomobject]@{
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
