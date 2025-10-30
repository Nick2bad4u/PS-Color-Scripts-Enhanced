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
| `New-ColorScriptCache`         | -     | Pre-generate cache                   |
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

- **First Run**: ~50-300ms (builds cache)
- **Cached Run**: ~8-16ms (6-19x faster!)
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
```

### Clear-ColorScriptCache

```powershell
Clear-ColorScriptCache
  [-Name <String[]>]    # Specific scripts
  [-All]                # All cache files
  [-Path <String>]      # Alternate cache root
  [-DryRun]             # Preview deletions
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

## Links

- **GitHub**: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
- **Issues**: https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues
- **License**: MIT

## Version

```powershell
Get-Module ColorScripts-Enhanced | Select-Object Version
```

Current: 2025.10.13

---

_For detailed documentation, use: `Get-Help about_ColorScripts-Enhanced`_
