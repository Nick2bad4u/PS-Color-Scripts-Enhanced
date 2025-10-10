# ColorScripts-Enhanced Quick Reference

## Installation

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
```

## Basic Commands

| Command                  | Alias | Description                          |
| ------------------------ | ----- | ------------------------------------ |
| `Show-ColorScript`       | `scs` | Display colorscripts                 |
| `Get-ColorScriptList`    | -     | List available scripts               |
| `Build-ColorScriptCache` | -     | Pre-generate cache                   |
| `Clear-ColorScriptCache` | -     | Remove cache files                   |
| `Add-ColorScriptProfile` | -     | Append module import/startup snippet |

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
Build-ColorScriptCache -All

# Cache specific scripts
Build-ColorScriptCache -Name hearts,bars,arch

# Force rebuild
Build-ColorScriptCache -All -Force
```

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

### Run All Scripts

```powershell
# Sequential with metadata-rich results
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Filter 'bars' -Delay 0 -SkipErrors

# Parallel execution (PowerShell 7+)
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Parallel -SkipErrors -ThrottleLimit 4
```

## Linting & Tests

```powershell
pwsh -NoProfile -Command "& .\Test-Module.ps1"              # Smoke tests + lint gate
Invoke-Pester -Path ./Tests                                   # Full test suite
pwsh -NoProfile -Command "& .\Lint-Module.ps1"              # Standard lint
pwsh -NoProfile -Command "& .\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors
pwsh -NoProfile -Command "& .\Lint-Module.ps1" -Fix         # Apply auto-fixes, then re-run lint
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
- **Pre-build cache**: `Build-ColorScriptCache -All`
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

### Build-ColorScriptCache

```powershell
Build-ColorScriptCache
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
Build-ColorScriptCache -All
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
Build-ColorScriptCache -Name bars -Force
```

### Performance issues

```powershell
# Pre-build all caches (one-time)
Build-ColorScriptCache -All

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

Current: 2025.10.09.2115

---

_For detailed documentation, use: `Get-Help about_ColorScripts-Enhanced`_
