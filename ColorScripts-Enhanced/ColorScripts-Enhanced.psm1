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
$script:ConfigurationRoot = $null
$script:ConfigurationPath = $null
$script:ConfigurationData = $null
$script:ConfigurationInitialized = $false
$script:DefaultConfiguration = @{
    Cache   = @{
        Path = $null
    }
    Startup = @{
        AutoShowOnImport = $false
        ProfileAutoShow  = $true
        DefaultScript    = $null
    }
}

function Copy-ColorScriptHashtable {
    param([hashtable]$Source)

    if (-not $Source) {
        return @{}
    }

    $clone = @{}
    foreach ($key in $Source.Keys) {
        $value = $Source[$key]
        if ($value -is [hashtable]) {
            $clone[$key] = Copy-ColorScriptHashtable $value
        }
        elseif ($value -is [System.Collections.IDictionary]) {
            $clone[$key] = Copy-ColorScriptHashtable ([hashtable]$value)
        }
        elseif ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
            $clone[$key] = @($value)
        }
        else {
            $clone[$key] = $value
        }
    }

    return $clone
}

function Merge-ColorScriptConfiguration {
    param(
        [hashtable]$Base,
        [hashtable]$Override
    )

    if (-not $Override) {
        return Copy-ColorScriptHashtable $Base
    }

    $result = Copy-ColorScriptHashtable $Base
    foreach ($key in $Override.Keys) {
        $overrideValue = $Override[$key]
        if ($result.ContainsKey($key)) {
            $baseValue = $result[$key]
            if ($baseValue -is [hashtable] -and $overrideValue -is [hashtable]) {
                $result[$key] = Merge-ColorScriptConfiguration $baseValue ([hashtable]$overrideValue)
                continue
            }
        }

        if ($overrideValue -is [hashtable]) {
            $result[$key] = Copy-ColorScriptHashtable ([hashtable]$overrideValue)
        }
        elseif ($overrideValue -is [System.Collections.IDictionary]) {
            $result[$key] = Copy-ColorScriptHashtable ([hashtable]$overrideValue)
        }
        elseif ($overrideValue -is [System.Collections.IEnumerable] -and $overrideValue -isnot [string]) {
            $result[$key] = @($overrideValue)
        }
        else {
            $result[$key] = $overrideValue
        }
    }

    return $result
}

function Get-ColorScriptsConfigurationRoot {
    if ($script:ConfigurationRoot) {
        return $script:ConfigurationRoot
    }

    $candidates = @()

    $overrideRoot = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT
    if (-not [string]::IsNullOrWhiteSpace($overrideRoot)) {
        $candidates += $overrideRoot
    }

    if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
        if ($env:APPDATA) {
            $candidates += (Join-Path -Path $env:APPDATA -ChildPath 'ColorScripts-Enhanced')
        }
    }
    elseif ($IsMacOS) {
        $macBase = Join-Path -Path $HOME -ChildPath 'Library'
        $macBase = Join-Path -Path $macBase -ChildPath 'Application Support'
        $candidates += (Join-Path -Path $macBase -ChildPath 'ColorScripts-Enhanced')
    }
    else {
        $xdgConfig = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path -Path $HOME -ChildPath '.config' }
        if ($xdgConfig) {
            $candidates += (Join-Path -Path $xdgConfig -ChildPath 'ColorScripts-Enhanced')
        }
    }

    if (-not $candidates) {
        $candidates = @([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'ColorScripts-Enhanced'))
    }

    foreach ($candidate in $candidates) {
        if ([string]::IsNullOrWhiteSpace($candidate)) { continue }
        $resolved = Resolve-CachePath -Path $candidate
        if (-not $resolved) { continue }

        try {
            if (-not (Test-Path -LiteralPath $resolved)) {
                New-Item -ItemType Directory -Path $resolved -Force -ErrorAction Stop | Out-Null
            }
            $script:ConfigurationRoot = $resolved
            return $script:ConfigurationRoot
        }
        catch {
            Write-Verbose "Unable to prepare configuration directory '$resolved': $($_.Exception.Message)"
        }
    }

    throw "Unable to determine configuration directory for ColorScripts-Enhanced."
}

function Save-ColorScriptConfiguration {
    param([hashtable]$Configuration)

    $configRoot = Get-ColorScriptsConfigurationRoot
    if (-not $configRoot) {
        throw 'Configuration root could not be resolved.'
    }

    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'
    $json = $Configuration | ConvertTo-Json -Depth 6
    Set-Content -Path $script:ConfigurationPath -Value ($json + [Environment]::NewLine) -Encoding UTF8
}

function Initialize-Configuration {
    if ($script:ConfigurationInitialized -and $script:ConfigurationData) {
        return
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $script:ConfigurationPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    $existing = $null
    if (Test-Path -LiteralPath $script:ConfigurationPath) {
        try {
            $raw = Get-Content -LiteralPath $script:ConfigurationPath -Raw -ErrorAction Stop
            if (-not [string]::IsNullOrWhiteSpace($raw)) {
                $existing = ConvertFrom-Json -InputObject $raw -AsHashtable
            }
        }
        catch {
            Write-Warning "Failed to parse configuration file at '$script:ConfigurationPath': $($_.Exception.Message). Using defaults."
        }
    }

    $script:ConfigurationData = Merge-ColorScriptConfiguration $script:DefaultConfiguration $existing
    Save-ColorScriptConfiguration -Configuration $script:ConfigurationData
    $script:ConfigurationInitialized = $true
}

function Get-ConfigurationDataInternal {
    Initialize-Configuration
    return $script:ConfigurationData
}

function Get-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [CmdletBinding()]
    param(
        [Alias('Help')]
        [switch]$h
    )

    if ($h) {
        Get-Help Get-ColorScriptConfiguration -Full
        return
    }

    $data = Copy-ColorScriptHashtable (Get-ConfigurationDataInternal)
    return $data
}

function Set-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [CmdletBinding()]
    param(
        [Alias('Help')]
        [switch]$h,

        [Nullable[bool]]$AutoShowOnImport,
        [Nullable[bool]]$ProfileAutoShow,
        [string]$CachePath,
        [string]$DefaultScript,
        [switch]$PassThru
    )

    if ($h) {
        Get-Help Set-ColorScriptConfiguration -Full
        return
    }

    $data = Get-ConfigurationDataInternal

    if ($PSBoundParameters.ContainsKey('AutoShowOnImport')) {
        $data.Startup.AutoShowOnImport = [bool]$AutoShowOnImport
    }

    if ($PSBoundParameters.ContainsKey('ProfileAutoShow')) {
        $data.Startup.ProfileAutoShow = [bool]$ProfileAutoShow
    }

    if ($PSBoundParameters.ContainsKey('CachePath')) {
        if ([string]::IsNullOrWhiteSpace($CachePath)) {
            $data.Cache.Path = $null
        }
        else {
            $resolvedCache = Resolve-CachePath -Path $CachePath
            if (-not $resolvedCache) {
                throw "Unable to resolve cache path '$CachePath'."
            }

            if (-not (Test-Path -LiteralPath $resolvedCache)) {
                New-Item -ItemType Directory -Path $resolvedCache -Force | Out-Null
            }

            $data.Cache.Path = $resolvedCache
        }

        $script:CacheInitialized = $false
        $script:CacheDir = $null
    }

    if ($PSBoundParameters.ContainsKey('DefaultScript')) {
        if ([string]::IsNullOrWhiteSpace($DefaultScript)) {
            $data.Startup.DefaultScript = $null
        }
        else {
            $data.Startup.DefaultScript = [string]$DefaultScript
        }
    }

    Save-ColorScriptConfiguration -Configuration $data

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}

function Reset-ColorScriptConfiguration {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Alias('Help')]
        [switch]$h,

        [switch]$PassThru
    )

    if ($h) {
        Get-Help Reset-ColorScriptConfiguration -Full
        return
    }

    $configRoot = Get-ColorScriptsConfigurationRoot
    $configPath = Join-Path -Path $configRoot -ChildPath 'config.json'

    if ($PSCmdlet.ShouldProcess($configPath, 'Reset ColorScripts-Enhanced configuration')) {
        $script:ConfigurationData = Copy-ColorScriptHashtable $script:DefaultConfiguration
        Save-ColorScriptConfiguration -Configuration $script:ConfigurationData
        $script:CacheInitialized = $false
        $script:CacheDir = $null
    }

    if ($PassThru) {
        return Get-ColorScriptConfiguration
    }
}

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

    if ($expanded -and $expanded.StartsWith('~')) {
        $homeDirectory = [System.Environment]::GetFolderPath('UserProfile')
        if (-not $homeDirectory) {
            $homeDirectory = $HOME
        }

        if ($homeDirectory) {
            if ($expanded.Length -eq 1) {
                $expanded = $homeDirectory
            }
            elseif ($expanded.Length -gt 1 -and ($expanded[1] -eq '/' -or $expanded[1] -eq '\')) {
                $relativeSegment = $expanded.Substring(2)
                $expanded = if ($relativeSegment) {
                    Join-Path -Path $homeDirectory -ChildPath $relativeSegment
                }
                else {
                    $homeDirectory
                }
            }
        }
    }

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


function Write-RenderedText {
    param(
        [AllowNull()]
        [string]$Text
    )

    $outputText = if ($null -ne $Text) { [string]$Text } else { '' }

    try {
        [Console]::Write($outputText)

        $requiresNewLine = $true
        if ($outputText) {
            $requiresNewLine = -not $outputText.EndsWith("`n")
        }

        if ($requiresNewLine) {
            [Console]::Write([Environment]::NewLine)
        }
    }
    catch [System.IO.IOException] {
        Write-Verbose 'Console handle unavailable during cached render; writing rendered text to the pipeline.'
        Write-Output $outputText
    }
}


function Initialize-CacheDirectory {
    if ($script:CacheInitialized -and $script:CacheDir) {
        return
    }

    Initialize-Configuration

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

    $configData = $script:ConfigurationData
    if ($configData -and $configData.Cache -and $configData.Cache.Path) {
        $configuredPath = Resolve-CachePath -Path $configData.Cache.Path
        if ($configuredPath) {
            $candidatePaths += $configuredPath
        }
        else {
            Write-Warning "Configured cache path '$($configData.Cache.Path)' could not be resolved. Falling back to default locations."
        }
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

function New-NameMatcherSet {
    param(
        [string[]]$Patterns
    )

    $matchers = New-Object 'System.Collections.Generic.List[object]'

    if (-not $Patterns) {
        return $matchers.ToArray()
    }

    foreach ($pattern in $Patterns) {
        if ([string]::IsNullOrWhiteSpace($pattern)) {
            continue
        }

        $hasWildcard = [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($pattern)
        if ($hasWildcard) {
            $wildcard = New-Object System.Management.Automation.WildcardPattern ($pattern, [System.Management.Automation.WildcardOptions]::IgnoreCase)
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $wildcard
                    IsWildcard = $true
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
        else {
            $null = $matchers.Add(
                [pscustomobject]@{
                    Pattern    = $pattern
                    Matcher    = $pattern
                    IsWildcard = $false
                    Matched    = $false
                    Matches    = New-Object 'System.Collections.Generic.List[string]'
                }
            )
        }
    }

    return $matchers.ToArray()
}

function Select-RecordsByName {
    param(
        [Parameter(Mandatory)]
        [System.Collections.IEnumerable]$Records,

        [string[]]$Name
    )

    $recordList = New-Object 'System.Collections.Generic.List[object]'
    foreach ($record in $Records) {
        $null = $recordList.Add($record)
    }

    $selectedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    if (-not $Name -or $Name.Count -eq 0) {
        return [pscustomobject]@{
            Records         = $recordList.ToArray()
            MissingPatterns = @()
        }
    }

    $matchers = New-NameMatcherSet -Patterns $Name
    if (-not $matchers -or $matchers.Count -eq 0) {
        return [pscustomobject]@{
            Records         = @()
            MissingPatterns = @()
        }
    }

    $selected = New-Object 'System.Collections.Generic.List[object]'

    foreach ($record in $recordList) {
        if (-not ($record.PSObject.Properties.Name -contains 'Name')) {
            continue
        }

        $candidateName = [string]$record.Name
        $recordMatched = $false

        foreach ($matcher in $matchers) {
            $isMatch = if ($matcher.IsWildcard) {
                $matcher.Matcher.IsMatch($candidateName)
            }
            else {
                [System.String]::Equals($candidateName, [string]$matcher.Matcher, [System.StringComparison]::OrdinalIgnoreCase)
            }

            if ($isMatch) {
                $matcher.Matched = $true
                if (-not $matcher.Matches.Contains($candidateName)) {
                    $null = $matcher.Matches.Add($candidateName)
                }
                $recordMatched = $true
            }
        }

        if ($recordMatched) {
            if ($selectedNames.Add($candidateName)) {
                $null = $selected.Add($record)
            }
        }
    }

    $missing = $matchers | Where-Object { -not $_.Matched } | ForEach-Object { $_.Pattern }

    $matchMap = $matchers | ForEach-Object {
        [pscustomobject]@{
            Pattern    = $_.Pattern
            IsWildcard = $_.IsWildcard
            Matched    = $_.Matched
            Matches    = $_.Matches.ToArray()
        }
    }

    return [pscustomobject]@{
        Records         = $selected.ToArray()
        MissingPatterns = [string[]]$missing
        MatchMap        = $matchMap
    }
}

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

            if ($data.Tags -is [hashtable]) {
                foreach ($taggedScript in $data.Tags.Keys) {
                    $entry = & $ensureEntry $internal $taggedScript
                    $tagsForScript = $data.Tags[$taggedScript]

                    if ($tagsForScript -is [System.Collections.IEnumerable] -and $tagsForScript -isnot [string]) {
                        foreach ($tagValue in $tagsForScript) {
                            $tagText = [string]$tagValue
                            if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                                $null = $entry.Tags.Add($tagText)
                            }
                        }
                    }
                    elseif ($tagsForScript) {
                        $tagText = [string]$tagsForScript
                        if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                            $null = $entry.Tags.Add($tagText)
                        }
                    }
                }
            }

            if ($data.Descriptions -is [hashtable]) {
                foreach ($describedScript in $data.Descriptions.Keys) {
                    $entry = & $ensureEntry $internal $describedScript
                    $descriptionText = $data.Descriptions[$describedScript]
                    if ($null -ne $descriptionText -and -not [string]::IsNullOrWhiteSpace([string]$descriptionText)) {
                        $entry.Description = [string]$descriptionText
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

    $scripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1"

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
        [SupportsWildcards()]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    $metadata = Get-ColorScriptMetadataTable
    $scripts = Get-ChildItem -Path $script:ScriptsPath -Filter "*.ps1"

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
        $selection = Select-RecordsByName -Records $records -Name $Name
        $records = $selection.Records
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

    .DESCRIPTION
        Returns a structured object that indicates whether a cache entry is available for the supplied
        script path together with the cached text content when the cache is current. No console output is emitted.

    .OUTPUTS
        PSCustomObject with the following properties:
            Available      - Indicates whether the cache entry was used.
            CacheFile      - Full path to the cache file.
            Content        - Cached ANSI text when Available is $true, otherwise an empty string.
            LastWriteTime  - Last write time (UTC) of the cache file when Available is $true.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $null
            Content       = ''
            LastWriteTime = $null
        }
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"

    if (-not (Test-Path -LiteralPath $cacheFile)) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $null
        }
    }

    $scriptItem = Get-Item -LiteralPath $ScriptPath
    $cacheItem = Get-Item -LiteralPath $cacheFile

    if ($scriptItem.LastWriteTimeUtc -gt $cacheItem.LastWriteTimeUtc) {
        return [pscustomobject]@{
            Available     = $false
            CacheFile     = $cacheFile
            Content       = ''
            LastWriteTime = $cacheItem.LastWriteTimeUtc
        }
    }

    $content = [System.IO.File]::ReadAllText($cacheFile, $script:Utf8NoBomEncoding)

    return [pscustomobject]@{
        Available     = $true
        CacheFile     = $cacheFile
        Content       = $content
        LastWriteTime = $cacheItem.LastWriteTimeUtc
    }
}

function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Executes a colorscript in an isolated process and captures its output.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        StdOut     = ''
        StdErr     = ''
        ExitCode   = $null
        Success    = $false
    }

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result.StdErr = 'Script path not found.'
        return $result
    }

    $executable = Get-PowerShellExecutable
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
    $process = $null

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable

        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $escapedScriptDir = if ($scriptDirectory) { $scriptDirectory.Replace("'", "''") } else { $null }
        $commandBuilder = New-Object System.Text.StringBuilder
        $null = $commandBuilder.Append("[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; ")
        if ($escapedScriptDir) {
            $null = $commandBuilder.Append("Set-Location -LiteralPath '$escapedScriptDir'; ")
        }
        $null = $commandBuilder.Append("& ([ScriptBlock]::Create([System.IO.File]::ReadAllText('$escapedScriptPath', [System.Text.Encoding]::UTF8)))")

        $encodedCommand = $commandBuilder.ToString()
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"$encodedCommand`""
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        if ($scriptDirectory) {
            $startInfo.WorkingDirectory = $scriptDirectory
        }

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $errorOutput = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $result.ExitCode = $process.ExitCode
        $result.StdOut = $output
        $result.StdErr = $errorOutput
        $result.Success = ($process.ExitCode -eq 0)
    }
    catch {
        $result.StdErr = $_.Exception.Message
    }
    finally {
        if ($process) {
            $process.Dispose()
        }
    }

    return $result
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

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result.StdErr = "Script path not found."
        return $result
    }

    $execution = Invoke-ColorScriptProcess -ScriptPath $ScriptPath
    $result.ExitCode = $execution.ExitCode
    $result.StdOut = $execution.StdOut
    $result.StdErr = $execution.StdErr

    if ($execution.Success) {
        try {
            [System.IO.File]::WriteAllText($cacheFile, $execution.StdOut, $script:Utf8NoBomEncoding)
            $scriptItem = Get-Item -LiteralPath $ScriptPath
            try {
                [System.IO.File]::SetLastWriteTimeUtc($cacheFile, $scriptItem.LastWriteTimeUtc)
            }
            catch {
                [System.IO.File]::SetLastWriteTime($cacheFile, $scriptItem.LastWriteTime)
            }
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
        }
    }
    elseif (-not $result.StdErr) {
        $result.StdErr = "Script exited with code $($execution.ExitCode)."
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
        Name values accept wildcards; when multiple scripts match the provided pattern, the first
        alphabetical match is displayed and can be inspected with -PassThru.

    .PARAMETER Name
        The name of the colorscript to display (without .ps1 extension). Supports wildcards for partial matches.

    .PARAMETER List
        Lists all available colorscripts.

    .PARAMETER Random
        Display a random colorscript (default behavior).

    .PARAMETER NoCache
        Bypass cache and execute script directly.
    .PARAMETER Category
        Filter the available script set by one or more categories before selection occurs.
    .PARAMETER Tag
        Filter the available script set by tag metadata (case-insensitive).
    .PARAMETER PassThru
        Return the selected script metadata in addition to rendering output.
    .PARAMETER ReturnText
        Emit the rendered colorscript as pipeline output instead of writing directly to the console.

    .EXAMPLE
        Show-ColorScript
        Displays a random colorscript.

    .EXAMPLE
        Show-ColorScript -Name "mandelbrot-zoom"
        Displays the mandelbrot-zoom colorscript.

    .EXAMPLE
        Show-ColorScript -Name "aurora-*"
        Displays the first colorscript (alphabetically) whose name matches the wildcard.

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
        [Parameter(ParameterSetName = 'Help')]
        [Alias('Help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Named', Position = 0)]
        [SupportsWildcards()]
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

        [Parameter(ParameterSetName = 'Named')]
        [Parameter(ParameterSetName = 'Random')]
        [switch]$PassThru,

        [Parameter()]
        [Alias('AsString')]
        [switch]$ReturnText
    )

    # Handle help request
    if ($h) {
        Get-Help Show-ColorScript -Full
        return
    }

    # Handle list request
    if ($List) {
        $listParams = @{}
        if ($Category) { $listParams.Category = $Category }
        if ($Tag) { $listParams.Tag = $Tag }
        Get-ColorScriptList @listParams
        return
    }

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag

    if (-not $records -or $records.Count -eq 0) {
        Write-Warning "No colorscripts found in $script:ScriptsPath"
        return
    }

    if ($Name) {
        $selectionResult = Select-RecordsByName -Records $records -Name $Name
        foreach ($pattern in $selectionResult.MissingPatterns) {
            Write-Warning "Colorscript '$pattern' not found with the specified filters."
        }

        $records = $selectionResult.Records
        if (-not $records -or $records.Count -eq 0) {
            return
        }
    }

    $useRandom = $Random -or $PSCmdlet.ParameterSetName -eq 'Random'

    $selection = $null

    if ($Name) {
        $orderedMatches = $records | Sort-Object Name
        if ($orderedMatches.Count -gt 1) {
            $matchedNames = $orderedMatches | Select-Object -ExpandProperty Name
            Write-Verbose "Multiple colorscripts matched the provided name pattern(s): $($matchedNames -join ', '). Displaying '$($orderedMatches[0].Name)'."
        }
        $selection = $orderedMatches | Select-Object -First 1
    }
    elseif ($useRandom) {
        $selection = $records | Get-Random
    }
    else {
        $selection = $records | Select-Object -First 1
    }

    $renderedOutput = $null

    if (-not $NoCache) {
        $cacheState = Get-CachedOutput -ScriptPath $selection.Path
        if ($cacheState.Available) {
            $renderedOutput = $cacheState.Content
        }
        else {
            $cacheResult = Build-ScriptCache -ScriptPath $selection.Path
            if (-not $cacheResult.Success) {
                if ($cacheResult.StdErr) {
                    Write-Warning "Cache build failed for $($selection.Name): $($cacheResult.StdErr.Trim())"
                }

                if ([string]::IsNullOrEmpty($cacheResult.StdOut)) {
                    throw "Failed to build cache for $($selection.Name)."
                }

                $renderedOutput = $cacheResult.StdOut
            }
            else {
                $renderedOutput = $cacheResult.StdOut
            }
        }
    }
    else {
        $executionResult = Invoke-ColorScriptProcess -ScriptPath $selection.Path
        if (-not $executionResult.Success) {
            $errorMessage = if ($executionResult.StdErr) { $executionResult.StdErr.Trim() } else { "Script exited with code $($executionResult.ExitCode)." }
            throw "Failed to execute colorscript '$($selection.Name)': $errorMessage"
        }

        $renderedOutput = $executionResult.StdOut
    }

    if ($null -eq $renderedOutput) {
        $renderedOutput = ''
    }

    $pipelineBoundParameters = $PSCmdlet.MyInvocation.BoundParameters
    $pipelineLength = $PSCmdlet.MyInvocation.PipelineLength
    $shouldEmitText = $ReturnText.IsPresent -or [Console]::IsOutputRedirected

    if (-not $shouldEmitText -and -not $PassThru) {
        if ($pipelineLength -gt 1 -or $pipelineBoundParameters.ContainsKey('OutVariable') -or $pipelineBoundParameters.ContainsKey('PipelineVariable')) {
            $shouldEmitText = $true
        }
    }

    Invoke-WithUtf8Encoding -ScriptBlock {
        param($text, $emitText)

        if ($emitText) {
            Write-Output $text
            return
        }

        Write-RenderedText -Text $text
    } -Arguments @($renderedOutput, $shouldEmitText)

    if ($PassThru) {
        return $selection
    }
}

<#
.SYNOPSIS
Returns metadata-rich information about available color scripts.
.DESCRIPTION
Loads script metadata and optionally filters by category or tag before returning structured objects or displaying a table view.
.PARAMETER AsObject
return raw record objects instead of rendering a formatted table.
.PARAMETER Detailed
Include tag and description columns when emitting the formatted table view.
.PARAMETER Name
Filter the colorscript list by one or more names. Wildcards are supported and unmatched patterns generate warnings.
.PARAMETER Category
Filter the list to scripts belonging to one or more categories (case-insensitive).
.PARAMETER Tag
Filter the list to scripts containing one or more metadata tags (case-insensitive).
#>
function Get-ColorScriptList {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Structured list is emitted for pipeline consumption.')]
    [CmdletBinding()]
    param(
        [Alias('Help')]
        [switch]$h,

        [switch]$AsObject,
        [switch]$Detailed,
        [SupportsWildcards()]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    if ($h) {
        Get-Help Get-ColorScriptList -Full
        return
    }

    $records = Get-ColorScriptEntry -Category $Category -Tag $Tag | Sort-Object Name

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        foreach ($pattern in $selection.MissingPatterns) {
            Write-Warning "Colorscript '$pattern' not found with the specified filters."
        }

        $records = $selection.Records
    }

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
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is a collective noun representing the exported dataset.')]
    [CmdletBinding()]
    param(
        [Alias('Help')]
        [switch]$h,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$IncludeFileInfo,

        [Parameter()]
        [switch]$IncludeCacheInfo,

        [Parameter()]
        [switch]$PassThru
    )

    if ($h) {
        Get-Help Export-ColorScriptMetadata -Full
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
                Write-Verbose "Unable to retrieve file info for '$($record.Name)': $($_.Exception.Message)"
            }
        }

        if ($IncludeCacheInfo) {
            $cacheFile = if ($script:CacheDir) { Join-Path -Path $script:CacheDir -ChildPath "$($record.Name).cache" } else { $null }
            $cacheExists = $false
            $cacheTimestamp = $null

            if ($cacheFile -and (Test-Path -LiteralPath $cacheFile)) {
                $cacheExists = $true
                try {
                    $cacheInfo = Get-Item -LiteralPath $cacheFile -ErrorAction Stop
                    $cacheTimestamp = $cacheInfo.LastWriteTimeUtc
                }
                catch {
                    Write-Verbose "Unable to read cache info for '$($record.Name)': $($_.Exception.Message)"
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
            throw "Unable to resolve output path '$Path'."
        }

        $outputDirectory = Split-Path -Path $resolvedPath -Parent
        if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
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

<#
.SYNOPSIS
Builds or refreshes the cache for one or more color scripts.
.DESCRIPTION
Uses cached path resolution to execute color scripts and persist their output, honoring Force, WhatIf, and ShouldProcess semantics.
 Accepts wildcard patterns so multiple scripts can be cached with a single command or streamed from the pipeline.
.PARAMETER Name
One or more colorscript names to cache. Supports wildcard patterns and pipeline input.
.PARAMETER All
Cache every available script. When omitted and no names are supplied, all scripts are cached by default.
.PARAMETER Force
Rebuild caches even when the existing cache file is newer than the script source.
.PARAMETER PassThru
Return detailed result objects for each cache operation. By default, only a summary is displayed.
.PARAMETER Category
Limit the selection to scripts that belong to the specified category (case-insensitive). Multiple values are treated as an OR filter.
.PARAMETER Tag
Limit the selection to scripts containing the specified metadata tags (case-insensitive). Multiple values are treated as an OR filter.
#>
function Build-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Alias('Help')]
        [switch]$h,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [switch]$PassThru,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag
    )

    begin {
        if ($h) {
            Get-Help Build-ColorScriptCache -Full
            return
        }

        $collectedNames = New-Object 'System.Collections.Generic.List[string]'
    }

    process {
        if ($Name) {
            foreach ($value in $Name) {
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    $null = $collectedNames.Add($value)
                }
            }
        }
    }

    end {
        $records = @()
        $selectedNames = $collectedNames.ToArray()
        $allExplicitlyDisabled = $PSBoundParameters.ContainsKey('All') -and -not $All
        $filteredRecords = Get-ColorScriptEntry -Category $Category -Tag $Tag

        if ($selectedNames.Count -gt 0) {
            $selection = Select-RecordsByName -Records $filteredRecords -Name $selectedNames
            foreach ($pattern in $selection.MissingPatterns) {
                Write-Warning "Script not found: $pattern"
            }
            $records = $selection.Records
        }
        elseif ($allExplicitlyDisabled) {
            throw "Specify -Name to select scripts when -All is explicitly disabled."
        }
        else {
            $records = $filteredRecords
        }

        if ($records -is [System.Collections.IEnumerable]) {
            $records = @($records | Where-Object { $_ })
        }
        elseif ($null -eq $records) {
            $records = @()
        }
        else {
            $records = @($records)
        }

        $recordCount = ($records | Measure-Object).Count

        if ($recordCount -eq 0) {
            Write-Warning "No scripts selected for cache build."
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        if (-not $PSCmdlet.ShouldProcess($script:CacheDir, "Build cache for $recordCount script(s)")) {
            return [System.Management.Automation.PSCustomObject[]]@()
        }

        $results = @()
        $totalCount = $recordCount
        $progressActivity = 'Building ColorScripts cache'

        for ($index = 0; $index -lt $totalCount; $index++) {
            $record = $records[$index]
            $scriptName = [string]$record.Name
            $cacheFile = Join-Path $script:CacheDir "$scriptName.cache"
            $percentComplete = if ($totalCount -eq 0) { 0 } else { [int](($index / [double]$totalCount) * 100) }
            $statusMessage = "Processing {0}/{1}: {2}" -f ($index + 1), $totalCount, $scriptName
            Write-Progress -Id 1 -Activity $progressActivity -Status $statusMessage -PercentComplete $percentComplete -CurrentOperation $scriptName

            $entry = $null
            $resultStatus = 'Updated'

            if (-not $Force -and (Test-Path -LiteralPath $cacheFile)) {
                $scriptItem = Get-Item -LiteralPath $record.Path
                $cacheItem = Get-Item -LiteralPath $cacheFile
                if ($cacheItem.LastWriteTimeUtc -ge $scriptItem.LastWriteTimeUtc) {
                    $resultStatus = 'SkippedUpToDate'
                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $cacheFile
                        ExitCode  = 0
                        StdOut    = ''
                        StdErr    = ''
                    }
                }
            }

            if (-not $entry) {
                if (-not $PSCmdlet.ShouldProcess($scriptName, 'Build cache')) {
                    $resultStatus = 'SkippedByUser'
                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $cacheFile
                        ExitCode  = $null
                        StdOut    = ''
                        StdErr    = ''
                    }
                }
                else {
                    $buildResult = Build-ScriptCache -ScriptPath $record.Path
                    $resultStatus = if ($buildResult.Success) { 'Updated' } else { 'Failed' }

                    if (-not $buildResult.Success -and $buildResult.StdErr) {
                        Write-Warning ("Failed to cache {0}: {1}" -f $scriptName, $buildResult.StdErr)
                    }

                    $entry = [pscustomobject]@{
                        Name      = $scriptName
                        Status    = $resultStatus
                        CacheFile = $buildResult.CacheFile
                        ExitCode  = $buildResult.ExitCode
                        StdOut    = $buildResult.StdOut
                        StdErr    = $buildResult.StdErr
                    }
                }
            }

            $results += $entry

            $completionPercent = if ($totalCount -eq 0) { 100 } else { [int]((($index + 1) / [double]$totalCount) * 100) }
            $statusSuffix = switch ($resultStatus) {
                'Updated' { 'Cached' }
                'SkippedUpToDate' { 'Skipped (up-to-date)' }
                'SkippedByUser' { 'Skipped by user' }
                'Failed' { 'Failed' }
                default { $resultStatus }
            }

            $completionMessage = "{0}/{1}: {2} - {3}" -f ($index + 1), $totalCount, $scriptName, $statusSuffix
            Write-Progress -Id 1 -Activity $progressActivity -Status $completionMessage -PercentComplete $completionPercent -CurrentOperation $scriptName
        }

        Write-Progress -Id 1 -Activity $progressActivity -Completed

        # Display summary if not using PassThru and there are results
        if (-not $PassThru -and $totalCount -gt 0) {
            $summary = $results | Group-Object -Property Status | ForEach-Object {
                [pscustomobject]@{
                    Status = $_.Name
                    Count  = $_.Count
                }
            }

            Write-Host "`nCache Build Summary:" -ForegroundColor Cyan
            Write-Host ("=" * 40) -ForegroundColor Cyan

            foreach ($item in $summary) {
                $color = switch ($item.Status) {
                    'Updated' { 'Green' }
                    'SkippedUpToDate' { 'Yellow' }
                    'Failed' { 'Red' }
                    'SkippedByUser' { 'Gray' }
                    default { 'White' }
                }
                $statusText = switch ($item.Status) {
                    'Updated' { 'Cached' }
                    'SkippedUpToDate' { 'Up-to-date (skipped)' }
                    'Failed' { 'Failed' }
                    'SkippedByUser' { 'Skipped by user' }
                    default { $item.Status }
                }
                Write-Host ("  {0,-25} {1}" -f $statusText, $item.Count) -ForegroundColor $color
            }

            $failed = $results | Where-Object { $_.Status -eq 'Failed' }
            if ($failed) {
                Write-Host "`nFailed scripts:" -ForegroundColor Red
                foreach ($failure in $failed) {
                    Write-Host "  - $($failure.Name): $($failure.StdErr)" -ForegroundColor Red
                }
            }

            Write-Host "`nTotal scripts processed: $totalCount" -ForegroundColor Cyan
            Write-Host "Use -PassThru to see detailed results`n" -ForegroundColor Gray
        }

        if ($PassThru) {
            return [pscustomobject[]]$results
        }

        return
    }
}

<#
.SYNOPSIS
Removes color script cache files with optional dry-run support.
.DESCRIPTION
Clears cached script output for specific scripts or the entire cache directory while providing structured, scriptable results.
 Supports wildcard name patterns for batch operations while reporting unmatched patterns.
.PARAMETER Name
Names or wildcard patterns identifying cache files to remove. Accepts pipeline input and property binding.
.PARAMETER All
Remove every cache file in the target directory.
.PARAMETER Path
Alternate cache directory to operate against.
.PARAMETER DryRun
Preview removal actions without deleting files.
.PARAMETER Category
Filter the target scripts by category before evaluating cache entries.
.PARAMETER Tag
Filter the target scripts by metadata tag before evaluating cache entries.
#>
function Clear-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache entry.')]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [Alias('Help')]
        [switch]$h,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]$Name,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$DryRun,

        [Parameter()]
        [string[]]$Category,

        [Parameter()]
        [string[]]$Tag
    )

    begin {
        if ($h) {
            Get-Help Clear-ColorScriptCache -Full
            return
        }

        $collectedNames = New-Object 'System.Collections.Generic.List[string]'
    }

    process {
        if ($Name) {
            foreach ($value in $Name) {
                if (-not [string]::IsNullOrWhiteSpace($value)) {
                    $null = $collectedNames.Add($value)
                }
            }
        }
    }

    end {
        $filtersSpecified = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0)

        $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($value in $collectedNames) {
            if (-not [string]::IsNullOrWhiteSpace($value)) {
                $null = $nameSet.Add($value)
            }
        }

        $filteredRecords = if ($filtersSpecified) { Get-ColorScriptEntry -Category $Category -Tag $Tag } else { @() }

        if ($filtersSpecified) {
            $filteredNameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($record in $filteredRecords) {
                if ($record -and $record.Name) {
                    $null = $filteredNameSet.Add($record.Name)
                }
            }

            if ($All -and $nameSet.Count -eq 0 -and $filteredNameSet.Count -gt 0) {
                foreach ($name in $filteredNameSet) {
                    $null = $nameSet.Add($name)
                }
            }
            elseif ($nameSet.Count -eq 0) {
                foreach ($name in $filteredNameSet) {
                    $null = $nameSet.Add($name)
                }
            }
            else {
                $skippedByFilter = New-Object 'System.Collections.Generic.List[string]'
                $namesSnapshot = @($nameSet)
                foreach ($name in $namesSnapshot) {
                    if (-not $filteredNameSet.Contains($name)) {
                        $null = $nameSet.Remove($name)
                        $null = $skippedByFilter.Add($name)
                    }
                }

                foreach ($skipped in $skippedByFilter) {
                    Write-Warning "Script '$skipped' does not satisfy the specified filters and will be skipped."
                }
            }
        }

        $selectedNames = @($nameSet)
        $operateOnAll = $All -and -not $filtersSpecified -and $selectedNames.Count -eq 0

        if (-not $operateOnAll -and $selectedNames.Count -eq 0) {
            if ($filtersSpecified) {
                Write-Warning "No scripts matched the specified filters."
                return [pscustomobject[]]@()
            }

            throw "Specify -All or -Name to clear cache entries."
        }

        $targetRoot = if ($Path) { $Path } else { $script:CacheDir }

        try {
            $targetRoot = (Resolve-Path -LiteralPath $targetRoot -ErrorAction Stop).ProviderPath
        }
        catch {
            Write-Warning "Cache path not found: $targetRoot"
            return [pscustomobject[]]@()
        }

        $results = @()

        if ($selectedNames.Count -gt 0) {
            $cacheFiles = Get-ChildItem -LiteralPath $targetRoot -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -eq '.cache' }
            $cacheRecords = @()
            if ($cacheFiles) {
                foreach ($file in $cacheFiles) {
                    $cacheRecords += [pscustomobject]@{
                        Name      = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                        CacheFile = $file.FullName
                    }
                }
            }

            $selection = Select-RecordsByName -Records $cacheRecords -Name $selectedNames
            $recordIndex = @{}
            foreach ($entry in $selection.Records) {
                $key = $entry.Name.ToLowerInvariant()
                if (-not $recordIndex.ContainsKey($key)) {
                    $recordIndex[$key] = $entry
                }
            }

            $processedNames = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

            foreach ($patternInfo in $selection.MatchMap) {
                if (-not $patternInfo.Matched) {
                    $results += [pscustomobject]@{
                        Name      = $patternInfo.Pattern
                        CacheFile = Join-Path -Path $targetRoot -ChildPath ("{0}.cache" -f $patternInfo.Pattern)
                        Status    = 'Missing'
                        Message   = 'Cache file not found.'
                    }
                    continue
                }

                foreach ($matchedName in $patternInfo.Matches) {
                    if (-not $processedNames.Add($matchedName)) {
                        continue
                    }

                    $lookupKey = $matchedName.ToLowerInvariant()
                    $entry = if ($recordIndex.ContainsKey($lookupKey)) { $recordIndex[$lookupKey] } else { $null }

                    if (-not $entry) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = Join-Path -Path $targetRoot -ChildPath ("{0}.cache" -f $matchedName)
                            Status    = 'Missing'
                            Message   = 'Cache file not found.'
                        }
                        continue
                    }

                    $cacheFile = $entry.CacheFile

                    if (-not (Test-Path -LiteralPath $cacheFile)) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Missing'
                            Message   = 'Cache file not found.'
                        }
                        continue
                    }

                    if (-not $PSCmdlet.ShouldProcess($cacheFile, 'Clear cache')) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'SkippedByUser'
                            Message   = ''
                        }
                        continue
                    }

                    if ($DryRun) {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'DryRun'
                            Message   = 'No changes applied.'
                        }
                        continue
                    }

                    try {
                        Remove-Item -LiteralPath $cacheFile -Force -ErrorAction Stop
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Removed'
                            Message   = ''
                        }
                    }
                    catch {
                        $results += [pscustomobject]@{
                            Name      = $matchedName
                            CacheFile = $cacheFile
                            Status    = 'Error'
                            Message   = $_.Exception.Message
                        }
                    }
                }
            }
        }
        else {
            $cacheFiles = Get-ChildItem -LiteralPath $targetRoot -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -eq '.cache' }
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
}

function New-ColorScript {
    <#
    .SYNOPSIS
    Scaffold a new colorscript file with a ready-to-edit template.
    .DESCRIPTION
    Creates a PowerShell colorscript skeleton in the target directory (defaulting to the module's Scripts folder).
    Optionally emits guidance for updating ScriptMetadata.psd1 with category and tag suggestions.
    .PARAMETER Name
    Name of the new colorscript. A `.ps1` extension is appended automatically.
    .PARAMETER OutputPath
    Destination directory for the new script. Defaults to the module's Scripts directory.
    .PARAMETER Force
    Overwrite an existing file with the same name.
    .PARAMETER Category
    Suggested primary category for metadata guidance.
    .PARAMETER Tag
    Suggested metadata tags for the new script.
    .PARAMETER GenerateMetadataSnippet
    Emit a guidance snippet describing how to update ScriptMetadata.psd1.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Alias('Help')]
        [switch]$h,

        [Parameter(Mandatory)]
        [ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9_-]*$')]
        [string]$Name,

        [Parameter()]
        [string]$OutputPath,

        [Parameter()]
        [switch]$Force,

        [Parameter()]
        [string]$Category,

        [Parameter()]
        [string[]]$Tag,

        [Parameter()]
        [switch]$GenerateMetadataSnippet
    )

    if ($h) {
        Get-Help New-ColorScript -Full
        return
    }

    $targetDirectory = $script:ScriptsPath
    if ($PSBoundParameters.ContainsKey('OutputPath')) {
        $resolvedOutput = Resolve-CachePath -Path $OutputPath
        if (-not $resolvedOutput) {
            throw "Unable to resolve output path '$OutputPath'."
        }
        $targetDirectory = $resolvedOutput
    }

    if (-not (Test-Path -LiteralPath $targetDirectory)) {
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
    }

    $targetPath = Join-Path -Path $targetDirectory -ChildPath ("{0}.ps1" -f $Name)

    if ((Test-Path -LiteralPath $targetPath) -and -not $Force) {
        throw "Script '$targetPath' already exists. Use -Force to overwrite."
    }

    $template = @'
# __NAME__ colorscript
param()

$esc = [char]27
$ansiLines = @(
    "$esc[38;2;255;145;0mReplace this array with your ANSI art for '__NAME__'.",
    "$esc[0mAdd additional lines as needed."
)

foreach ($line in $ansiLines) {
    Write-Host $line
}
'@

    $template = $template.Replace('__NAME__', $Name)

    if ($PSCmdlet.ShouldProcess($targetPath, 'Create colorscript skeleton')) {
        [System.IO.File]::WriteAllText($targetPath, $template, $script:Utf8NoBomEncoding)
    }

    $metadataSnippet = $null
    if ($GenerateMetadataSnippet) {
        $categoryHint = if (-not [string]::IsNullOrWhiteSpace($Category)) { $Category } else { 'YourCategory' }
        $tagList = @($Tag | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        if (-not $tagList) {
            $tagList = @('Custom')
        }

        $formattedTags = ($tagList | ForEach-Object { "'$_'" }) -join ', '
        $metadataSnippet = @"
# ScriptMetadata.psd1 guidance for '$Name'
#
# Categories:
#     '$categoryHint' = @(
#         # ...existing entries...
#         '$Name'
#     )
#
# Tags:
#     '$Name' = @($formattedTags)
"@
    }

    $result = [pscustomobject]@{
        Name               = $Name
        Path               = $targetPath
        CategorySuggestion = if ($Category) { $Category } else { $null }
        TagSuggestion      = if ($Tag) { [string[]]$Tag } else { @() }
        MetadataGuidance   = $metadataSnippet
    }

    if ($metadataSnippet) {
        Write-Verbose "Metadata guidance for '$Name':`n$metadataSnippet"
    }

    return $result
}

function Add-ColorScriptProfile {
    <#
    .EXTERNALHELP ColorScripts-Enhanced-help.xml
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Alias('Help')]
        [switch]$h,

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

    if ($h) {
        Get-Help Add-ColorScriptProfile -Full
        return
    }

    if ($null -ne $PSSenderInfo) {
        Write-Warning "Profile updates are not supported in remote sessions."
        return [pscustomobject]@{
            Path    = $null
            Changed = $false
            Message = 'Remote session detected.'
        }
    }

    $configuration = $null
    try {
        $configuration = Get-ColorScriptConfiguration
    }
    catch {
        Write-Verbose "Configuration unavailable: $($_.Exception.Message)"
    }

    $autoShow = $true
    $defaultStartupScript = $null

    if ($configuration -and $configuration.Startup) {
        if ($configuration.Startup.ContainsKey('ProfileAutoShow')) {
            $autoShow = [bool]$configuration.Startup.ProfileAutoShow
        }

        if ($configuration.Startup.ContainsKey('DefaultScript')) {
            $defaultStartupScript = $configuration.Startup.DefaultScript
        }
    }

    if ($PSBoundParameters.ContainsKey('SkipStartupScript')) {
        $autoShow = -not $SkipStartupScript.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Path')) {
        $profilePath = Resolve-CachePath -Path $Path
        if (-not $profilePath) {
            throw "Unable to resolve profile path '$Path'."
        }
    }
    else {
        $profilePath = $PROFILE.$Scope
        if ([string]::IsNullOrWhiteSpace($profilePath)) {
            throw "Profile path for scope '$Scope' is not defined."
        }

        $resolvedProfile = Resolve-CachePath -Path $profilePath
        if ($resolvedProfile) {
            $profilePath = $resolvedProfile
        }
        elseif (-not [System.IO.Path]::IsPathRooted($profilePath)) {
            $profilePath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $profilePath))
        }
    }

    $profileDirectory = Split-Path -Parent $profilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existingContent = ''
    if (Test-Path -LiteralPath $profilePath) {
        $existingContent = Get-Content -LiteralPath $profilePath -Raw
    }

    $newline = if ($existingContent -match "`r`n") {
        "`r`n"
    }
    elseif ($existingContent -match "`n") {
        "`n"
    }
    else {
        [Environment]::NewLine
    }
    $timestamp = (Get-Date).ToString('u')
    $snippetLines = @(
        "# Added by ColorScripts-Enhanced on $timestamp",
        'Import-Module ColorScripts-Enhanced'
    )

    if ($autoShow) {
        if (-not [string]::IsNullOrWhiteSpace($defaultStartupScript)) {
            $safeName = $defaultStartupScript -replace "'", "''"
            $snippetLines += "Show-ColorScript -Name '$safeName'"
        }
        else {
            $snippetLines += 'Show-ColorScript'
        }
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

# Internal helper to honor startup preferences post-import
function Invoke-ColorScriptsStartup {
    try {
        $configuration = Get-ColorScriptConfiguration
        if (-not $configuration.Startup.AutoShowOnImport) {
            return
        }

        if ($env:CI -eq 'true' -or $env:GITHUB_ACTIONS -eq 'true') {
            return
        }

        if ($Host.Name -eq 'ServerRemoteHost') {
            return
        }

        $outputRedirected = $false
        try {
            $outputRedirected = [Console]::IsOutputRedirected
        }
        catch {
            $outputRedirected = $false
        }

        if ($outputRedirected) {
            return
        }

        $defaultScript = if ($configuration.Startup.ContainsKey('DefaultScript')) { $configuration.Startup.DefaultScript } else { $null }

        if (-not [string]::IsNullOrWhiteSpace($defaultScript)) {
            Show-ColorScript -Name $defaultScript -ErrorAction SilentlyContinue | Out-Null
        }
        else {
            Show-ColorScript -ErrorAction SilentlyContinue | Out-Null
        }
    }
    catch {
        Write-Verbose "Auto-show on import skipped: $($_.Exception.Message)"
    }
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Show-ColorScript',
    'Get-ColorScriptList',
    'Build-ColorScriptCache',
    'Clear-ColorScriptCache',
    'Add-ColorScriptProfile',
    'Get-ColorScriptConfiguration',
    'Set-ColorScriptConfiguration',
    'Reset-ColorScriptConfiguration',
    'Export-ColorScriptMetadata',
    'New-ColorScript'
) -Alias @('scs')

# Module initialization message
Write-Verbose "ColorScripts-Enhanced module loaded. Cache location: $script:CacheDir"
Invoke-ColorScriptsStartup
