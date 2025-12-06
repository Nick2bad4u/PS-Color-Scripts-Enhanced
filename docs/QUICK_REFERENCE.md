# ColorScripts-Enhanced Quick Reference

## Installation

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
```

## Basic Commands

| Command                          | Alias | Description                          |
| -------------------------------- | ----- | ------------------------------------ |
| `Show-ColorScript`               | `scs` | Display colorscripts                 |
| `Get-ColorScriptList`            | -     | List available scripts               |
| `New-ColorScriptCache`           | -     | Pre-generate cache                   |
| `Clear-ColorScriptCache`         | -     | Remove cache files                   |
| `Add-ColorScriptProfile`         | -     | Append module import/startup snippet |
| `Get-ColorScriptConfiguration`   | -     | Inspect persisted defaults           |
| `Set-ColorScriptConfiguration`   | -     | Persist cache/startup preferences    |
| `Reset-ColorScriptConfiguration` | -     | Restore configuration defaults       |
| `Export-ColorScriptMetadata`     | -     | Export metadata and cache info       |
| `New-ColorScript`                | -     | Scaffold a new colorscript template  |

## Common Usage

### Display Random Colorscript

```powershell
Show-ColorScript
# or
scs
```

### Display Specific Script

```powershell
Show-ColorScript -Name hearts
scs mandelbrot-zoom
Show-ColorScript -IncludePokemon     # Random, including Pokémon scripts
```

### List All Scripts

```powershell
Show-ColorScript -List
Get-ColorScriptList

# Object output for automation
Get-ColorScriptList -AsObject | Select-Object Name, Category, Tags

# Filter by metadata
Get-ColorScriptList -Category Patterns -Detailed
Get-ColorScriptList -Tag Recommended
```

### Build Cache for Fast Loading

```powershell
# Cache all scripts
New-ColorScriptCache

# Cache specific scripts
New-ColorScriptCache -Name hearts,bars,arch

# Force rebuild
New-ColorScriptCache -Force
```

> Running `New-ColorScriptCache` without parameters caches the entire collection (the same as using `-All`).

### Clear Cache

```powershell
# Clear all cache
Clear-ColorScriptCache -All

# Clear specific cache
Clear-ColorScriptCache -Name hearts

# Preview without deleting
Clear-ColorScriptCache -All -WhatIf

# Dry run or alternate cache root
Clear-ColorScriptCache -Name hearts -DryRun
Clear-ColorScriptCache -Name hearts -Path 'C:/temp/colorscripts-cache'
```

### Persist Defaults with Configuration

```powershell
Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -ProfileAutoShow:$false
Reset-ColorScriptConfiguration
```

### Export Metadata

```powershell
Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
Export-ColorScriptMetadata -Path ./dist/colorscripts-metadata.json -IncludeFileInfo
```

### Scaffold a Colorscript

```powershell
$scaffold = New-ColorScript -Name 'my-custom-script' -GenerateMetadataSnippet -Category 'Patterns' -Tag 'Custom'
$scaffold.MetadataGuidance
```

### Run All Scripts

```powershell
# Sequential with metadata-rich results
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Filter 'bars' -Delay 0 -SkipErrors

# Parallel execution (PowerShell 7+)
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Parallel -SkipErrors -ThrottleLimit 4
```

### ANSI Toolkit

```powershell
# Convert ANSI to PowerShell script
node scripts/Convert-AnsiToColorScript.js .\art.ans

# Split a towering ANSI into smaller chunks (auto-detect gaps)
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --auto --dry-run

# Force manual breakpoints and emit ANSI slices instead of PowerShell
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --format=ansi --breaks=360,720

# Split an already converted colorscript
node scripts/Split-AnsiFile.js .\ColorScripts-Enhanced\Scripts\we-acidtrip.ps1 --input=ps1 --heights=320,320

# Split every 120 lines automatically
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --every=120
```

Use `--heights=h1,h2,...` for sequential segment sizes, `--every=<n>` for uniform slices, or `--breaks=row,row,...` for absolute cut points. Combine with `--strip-space-bg` (ANSI input only) to match our converter's treatment of space backgrounds.

## Linting & Tests

```powershell
pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"              # Smoke tests + lint gate
Invoke-Pester -Path ./Tests                                   # Full test suite
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1"              # Standard lint
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -Fix         # Apply auto-fixes, then re-run lint
pwsh -NoProfile -Command "& .\scripts\Lint-PS7.ps1"         # PowerShell 7-only analyzer with auto-fix
```

## Help System

```powershell
# Get command help
Get-Help Show-ColorScript
Get-Help Show-ColorScript -Full
Get-Help Show-ColorScript -Examples

# Module help
Get-Help about_ColorScripts-Enhanced

# List all help topics
Get-Help *ColorScript*
```

## Profile Integration

Add to your PowerShell profile (`$PROFILE`):

```powershell
Add-ColorScriptProfile                     # Import + Show-ColorScript
Add-ColorScriptProfile -SkipStartupScript  # Import only
Add-ColorScriptProfile -Scope CurrentUserCurrentHost
```

## Nerd Font Glyphs

- Install a patched font from [nerdfonts.com](https://www.nerdfonts.com/).
- Windows: unzip → select `.ttf` files → right-click → **Install for all users**.
- macOS: `brew install --cask font-caskaydia-cove-nerd-font` or add via Font Book.
- Linux: copy `.ttf` to `~/.local/share/fonts` (or `/usr/local/share/fonts`) and run `fc-cache -fv`.
- Set your terminal profile font to the Nerd Font and verify with `Show-ColorScript -Name nerd-font-test`.

## Performance Tips

- **First Run**: \~50-300ms (builds cache)
- **Cached Run**: \~8-16ms (6-19x faster!)
- **Pre-build cache**: `New-ColorScriptCache`
- **Cache location**: `$env:APPDATA\ColorScripts-Enhanced\cache`

## Script Categories

| Category      | Examples                                         |
| ------------- | ------------------------------------------------ |
| **Geometric** | mandelbrot-zoom, sierpinski-carpet, fractal-tree |
| **Nature**    | galaxy-spiral, aurora-bands, crystal-drift       |
| **Artistic**  | kaleidoscope, rainbow-waves, color-morphing      |
| **Gaming**    | doom-original, pacman, space-invaders            |
| **System**    | colortest, nerd-font-test, terminal-benchmark    |
| **Logos**     | arch, debian, ubuntu, windows                    |
| **NerdFont**  | dev-workspace, cloud-services, data-science      |
| **Patterns**  | bars, gradient-bars, hex-blocks                  |

## Parameters Reference

### Show-ColorScript

```powershell
Show-ColorScript
  [-Name <String>]      # Script name (without .ps1)
  [-List]               # List all scripts
  [-Random]             # Random selection (default)
  [-Category <String[]>]
  [-Tag <String[]>]
  [-NoCache]            # Bypass cache
  [-PassThru]           # Return metadata object
```

### Get-ColorScriptList

```powershell
Get-ColorScriptList
  [-Category <String[]>]
  [-Tag <String[]>]
  [-AsObject]
  [-Detailed]
```

### New-ColorScriptCache

```powershell
New-ColorScriptCache
  [-Name <String[]>]    # Specific scripts
  [-All]                # All scripts
  [-Force]              # Rebuild existing cache
  [-PassThru]           # Return detailed results
  [-Quiet]              # Suppress summary output
  [-NoAnsiOutput]       # Disable ANSI in summary
```

### Clear-ColorScriptCache

```powershell
Clear-ColorScriptCache
  [-Name <String[]>]    # Specific scripts
  [-All]                # All cache files
  [-Path <String>]      # Alternate cache root
  [-DryRun]             # Preview deletions
  [-PassThru]           # Return detailed results
  [-Quiet]              # Suppress summary output
  [-NoAnsiOutput]       # Disable ANSI in summary
  [-WhatIf]
  [-Confirm]
```

### Add-ColorScriptProfile

```powershell
Add-ColorScriptProfile
  [-Scope <String>]           # Profile scope (default CurrentUserAllHosts)
  [-Path <String>]            # Explicit profile path
  [-SkipStartupScript]        # Only add Import-Module line
  [-Force]                    # Append even if import already exists
  [-WhatIf]
  [-Confirm]
```

## Examples

### Daily Different Colorscript

```powershell
# In your profile
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript
```

### Show All Scripts Sequentially

```powershell
Get-ColorScriptList | Out-String -Stream |
  Where-Object { $_.Trim() } |
  ForEach-Object {
    $name = $_.Trim().Split()[0]
    Show-ColorScript -Name $name
    Start-Sleep -Seconds 2
  }
```

### Find Scripts by Pattern

```powershell
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*galaxy*.cache" |
  ForEach-Object {
    Show-ColorScript -Name $_.BaseName
  }
```

### Cache Statistics

```powershell
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$caches = Get-ChildItem $cacheDir -Filter *.cache
Write-Host "Cached scripts: $($caches.Count)"
Write-Host "Total cache size: $([math]::Round(($caches | Measure-Object Length -Sum).Sum / 1MB, 2)) MB"
```

## Troubleshooting

### Scripts not displaying

```powershell
# Ensure UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Clear and rebuild cache
Clear-ColorScriptCache -All
New-ColorScriptCache
```

### Cache not working

```powershell
# Check cache location
# Windows:
Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache"

# macOS:
Test-Path "~/Library/Application Support/ColorScripts-Enhanced/cache"

# Linux:
Test-Path "~/.cache/ColorScripts-Enhanced"

# Rebuild specific cache
New-ColorScriptCache -Name bars -Force
```

### Performance issues

```powershell
# Pre-build all caches (one-time)
New-ColorScriptCache

# Verify cache exists
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" | Measure-Object
```

## Advanced Usage

### Performance Monitoring

```powershell
# Measure cache benefit
$uncached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom -NoCache }
$cached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom }
Write-Host "Improvement: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

### Batch Automation

```powershell
# Process all recommended scripts
Get-ColorScriptList -Tag Recommended -AsObject | ForEach-Object {
    Show-ColorScript -Name $_.Name
    Start-Sleep -Seconds 1
}

# Export to JSON for external tools
Export-ColorScriptMetadata -Path "./scripts.json" -IncludeFileInfo
```

### CI/CD Integration

```powershell
# Pre-build cache for container deployment
New-ColorScriptCache -Force

# Verify all scripts are cached
$cached = @(Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter *.cache)
Write-Host "✓ Cached: $($cached.Count) scripts"
```

### Environment Detection

```powershell
# Conditional display based on environment
if ($env:CI) {
    Show-ColorScript -NoCache  # Avoid file I/O in ephemeral environments
} else {
    Show-ColorScript  # Use cache for faster performance
}
```

### Data Analysis

```powershell
# Category distribution
Get-ColorScriptList -AsObject |
    Group-Object Category |
    ForEach-Object { Write-Host "$($_.Name): $($_.Count) scripts" }

# Find scripts by pattern
Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains 'Animated' } |
    Select-Object Name, Category
```

## Best Practices

### Installation (2)

- [ ] Use `Install-Module` from PowerShell Gallery when available
- [ ] Use `-Scope CurrentUser` for user-only installation
- [ ] Run `New-ColorScriptCache` after installation for optimal performance

### Daily Use

- [ ] Add `Show-ColorScript` to your profile for a colorful greeting
- [ ] Use aliases: `scs` instead of `Show-ColorScript`
- [ ] Try `-Random` mode to discover different scripts

### Configuration

- [ ] Run `Add-ColorScriptProfile` to add startup integration
- [ ] Use `Get-ColorScriptConfiguration` to verify settings
- [ ] Backup configuration with `Export-ColorScriptMetadata`

### Performance

- [ ] Pre-build cache with `New-ColorScriptCache` after updates
- [ ] Use `-NoCache` only for script development/testing
- [ ] Monitor cache size: `$env:APPDATA\ColorScripts-Enhanced\cache`

### Troubleshooting (2)

- [ ] Verify UTF-8 encoding: `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8`
- [ ] Check module loads: `Get-Module ColorScripts-Enhanced`
- [ ] Test cache: `Clear-ColorScriptCache -All; New-ColorScriptCache`
- [ ] Review help: `Get-Help about_ColorScripts-Enhanced`

## Quick Troubleshooting Matrix

| Issue               | Check             | Solution                                                   |
| ------------------- | ----------------- | ---------------------------------------------------------- |
| Scripts not showing | Terminal encoding | `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` |
| Slow first run      | Cache missing     | `New-ColorScriptCache -Force`                              |
| Garbled characters  | Font support      | Install Nerd Font or try different script                  |
| Module not found    | Module path       | `$env:PSModulePath -split ';'`                             |
| Cache errors        | Disk space        | `Clear-ColorScriptCache -All`                              |
| Startup delays      | Profile heavy     | Use `-SkipStartupScript` option                            |

## Comparison: Commands vs Parameters

### Display Methods

| Goal            | Command            | Parameters           |
| --------------- | ------------------ | -------------------- |
| Random display  | `Show-ColorScript` | (none)               |
| Specific script | `Show-ColorScript` | `-Name "bars"`       |
| With caching    | `Show-ColorScript` | (default)            |
| Skip cache      | `Show-ColorScript` | `-NoCache`           |
| Get metadata    | `Show-ColorScript` | `-PassThru`          |
| List view       | `Show-ColorScript` | `-List`              |
| Browse all      | `Show-ColorScript` | `-All -WaitForInput` |

### Filtering Methods

| Goal                | Command               | Parameters                   |
| ------------------- | --------------------- | ---------------------------- |
| All scripts         | `Get-ColorScriptList` | (none)                       |
| One category        | `Get-ColorScriptList` | `-Category Geometric`        |
| Multiple categories | `Get-ColorScriptList` | `-Category Geometric,Nature` |
| By tag              | `Get-ColorScriptList` | `-Tag Recommended`           |
| Object format       | `Get-ColorScriptList` | `-AsObject`                  |
| Rich details        | `Get-ColorScriptList` | `-Detailed`                  |

## Learning Paths

### Path 1: First Time User (10 min)

1. Install: `Install-Module -Name ColorScripts-Enhanced`
2. Import: `Import-Module ColorScripts-Enhanced`
3. Try it: `Show-ColorScript`
4. Explore: `Get-ColorScriptList`
5. Setup: `Add-ColorScriptProfile`

### Path 2: Daily Power User (30 min)

1. Read Basic Commands section
2. Try Examples section (each example)
3. Setup profile integration
4. Explore categories and tags
5. Test performance improvements

### Path 3: Advanced User (1 hour)

1. Read Advanced Usage section
2. Study Best Practices
3. Try Performance Monitoring
4. Explore Batch Automation
5. Review CI/CD Integration examples

### Path 4: Integration & Automation (2 hours)

1. Study all Advanced Usage examples
2. Review Environment Detection patterns
3. Study Data Analysis workflows
4. Plan custom automation
5. Review ANSI-CONVERSION-GUIDE for custom scripts

## Keyboard Shortcuts & Aliases

```powershell
# Define custom aliases for faster access
Set-Alias -Name cs -Value Show-ColorScript
Set-Alias -Name csl -Value Get-ColorScriptList
Set-Alias -Name csb -Value New-ColorScriptCache
Set-Alias -Name csc -Value Clear-ColorScriptCache
```

## Environment Variables

```powershell
# Override cache location
$env:COLORSCRIPTS_CACHE = "D:\MyCache\ColorScripts"

# Set in profile for persistence
$env:PSModulePath += ";C:\CustomModulePath"
```

## For More Information

- **Full Help**: `Get-Help about_ColorScripts-Enhanced`
- **Command Help**: `Get-Help Show-ColorScript -Full`
- **Examples**: `Get-Help Show-ColorScript -Examples`
- **GitHub**: <https://github.com/Nick2bad4u/ps-color-scripts-enhanced>
- **Issues**: <https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues>
- **Documentation**: `./docs/` folder in repository

## Links

- **GitHub**: <https://github.com/Nick2bad4u/ps-color-scripts-enhanced>
- **Issues**: <https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues>
- **License**: MIT

## Version

```powershell
Get-Module ColorScripts-Enhanced | Select-Object Version
```

Current: 2025.11.05

---

**Tip:** For detailed documentation, use: `Get-Help about_ColorScripts-Enhanced`

**Last Updated**: October 30, 2025
**Status**: ✅ Production Ready
