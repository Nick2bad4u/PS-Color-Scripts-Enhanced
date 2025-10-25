# ColorScripts-Enhanced PowerShell Module

> **Credits:** Built upon [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts) by Derek Taylor and [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts) by Scott McKendry. Enhanced with high-performance caching, configuration management, and full cross-platform support.

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/ColorScripts-Enhanced?logo=powershell)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced) [![Downloads](https://img.shields.io/powershellgallery/dt/ColorScripts-Enhanced?logo=powershell)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced) [![NuGet](https://img.shields.io/nuget/v/ColorScripts-Enhanced?logo=nuget)](https://www.nuget.org/packages/ColorScripts-Enhanced/) [![Tests](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml) [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE)

Display beautiful ANSI colorscripts in your terminal with intelligent caching for **6-19x faster load times**. Perfect for terminal customization and visual appeal!

## Features

- ✨ **<!-- COLOR_SCRIPT_COUNT_PLUS -->498+<!-- /COLOR_SCRIPT_COUNT_PLUS --> Colorscripts** - Extensive ANSI art collection across 15+ categories
- ⚡ **6-19x Faster** - Intelligent caching (5-20ms vs 50-300ms load times)
- 🌐 **Cross-Platform** - Fully tested on Windows, macOS, and Linux
- 🎯 **Simple API** - Easy cmdlets with full tab completion
- ⚙️ **Configurable** - Persist cache location, startup behavior, and defaults
- 📍 **Centralized Cache** - OS-wide in `AppData/ColorScripts-Enhanced/cache`
- 🔄 **Auto-Update** - Cache invalidates automatically when scripts change
- 📚 **Complete Help** - Full comment-based help for all 10 commands

## Quick Start

```powershell
# Install from PowerShell Gallery
Install-Module ColorScripts-Enhanced -Scope CurrentUser

# Import and display a random colorscript
Import-Module ColorScripts-Enhanced
Show-ColorScript  # Alias: scs

# Add to your PowerShell profile for automatic startup
Add-ColorScriptProfile
```

**Requires**: PowerShell 5.1+ or PowerShell 7.0+

## Basic Usage

```powershell
# Display a random colorscript
Show-ColorScript  # or alias: scs

# Display specific colorscript by name
Show-ColorScript -Name hearts
scs mandelbrot-zoom

# List all available colorscripts
Get-ColorScriptList

# Filter by category
Get-ColorScriptList -Category Geometric

# Show detailed metadata
Get-ColorScriptList -Detailed

# Build cache for faster loading (6-19x improvement)
Build-ColorScriptCache

# Build cache for specific scripts only
Build-ColorScriptCache -Name bars,hearts,arch

# Clear cache when needed
Clear-ColorScriptCache -All
```

## All Commands

| Command                          | Alias | Description                                   |
| -------------------------------- | ----- | --------------------------------------------- |
| `Show-ColorScript`               | `scs` | Display a colorscript (random or by name)     |
| `Get-ColorScriptList`            | -     | List all available colorscripts with metadata |
| `Build-ColorScriptCache`         | -     | Pre-generate cache files for faster loading   |
| `Clear-ColorScriptCache`         | -     | Remove cache files                            |
| `Add-ColorScriptProfile`         | -     | Add module import to your PowerShell profile  |
| `Get-ColorScriptConfiguration`   | -     | View current configuration settings           |
| `Set-ColorScriptConfiguration`   | -     | Update and persist configuration              |
| `Reset-ColorScriptConfiguration` | -     | Restore default configuration                 |
| `Export-ColorScriptMetadata`     | -     | Export script metadata as JSON                |
| `New-ColorScript`                | -     | Create a new colorscript template             |

## Configuration

Persist preferences across sessions:

```powershell
# View current configuration
Get-ColorScriptConfiguration

# Set custom cache path and disable auto-show
Set-ColorScriptConfiguration -CachePath 'D:\Cache\ColorScripts' -ProfileAutoShow:$false

# Set default colorscript for startup
Set-ColorScriptConfiguration -DefaultScript 'galaxy-spiral'

# Reset to defaults
Reset-ColorScriptConfiguration
```

Configuration stored in `AppData/ColorScripts-Enhanced/config.json`.

## Getting Help

PowerShell uses the `Get-Help` cmdlet (not `--help` flags):

```powershell
# Get detailed help with examples
Get-Help Show-ColorScript -Full

# View just the examples
Get-Help Show-ColorScript -Examples

# Get help for a specific parameter
Get-Help Show-ColorScript -Parameter Name

# View the about topic for module overview
Get-Help about_ColorScripts-Enhanced
```

## Performance

Experience dramatic speed improvements:

- **First run (no cache)**: 50-300ms - Executes script and builds cache
- **Cached run**: 5-20ms - Loads pre-rendered output instantly
- **Improvement**: 6-19x faster!
- **Cache location**: `$env:APPDATA\ColorScripts-Enhanced\cache` (Windows)
  - macOS: `~/Library/Application Support/ColorScripts-Enhanced/cache`
  - Linux: `~/.cache/ColorScripts-Enhanced`

## Profile Integration

Add colorscripts to your PowerShell profile:

```powershell
# Add with automatic random colorscript on startup
Add-ColorScriptProfile

# Import only (no automatic display)
Add-ColorScriptProfile -SkipStartupScript

# Target a specific profile scope
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# Use custom profile path
Add-ColorScriptProfile -Path $PROFILE.CurrentUserAllHosts
```

## Advanced Features

### Export Metadata

```powershell
# Export all metadata with file and cache info
Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo

# Save to file for external automation
Export-ColorScriptMetadata -Path ./metadata.json
```

### Create Custom Colorscripts

```powershell
# Scaffold a new colorscript with metadata
$scaffold = New-ColorScript -Name 'my-art' -Category 'Custom' -GenerateMetadataSnippet

# Open in your editor
code $scaffold.Path
```

### Force Fresh Execution

```powershell
# Bypass cache for testing
Show-ColorScript -Name hearts -NoCache
```

## Requirements

- **PowerShell**: 5.1+ (Desktop) or 7.0+ (Core)
- **Platforms**: Windows, macOS, Linux
- **Terminal**: Any terminal with ANSI escape code support
- **Optional**: Nerd Font for icon-heavy scripts (nerd-font-test, dev-workspace)

## Links & Resources

**Full Documentation**: https://github.com/Nick2bad4u/ps-color-scripts-enhanced

- [Quick Reference Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/QUICK_REFERENCE.md)
- [ANSI Conversion Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ANSI-CONVERSION-GUIDE.md)
- [Development Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/Development.md)
- [Issue Tracker](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues)

## Contributing

Contributions welcome! Submit colorscripts, report bugs, or suggest features.

[CONTRIBUTING.md](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CONTRIBUTING.md)

## License

MIT - See [LICENSE](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE)

---

**Tip**: Run `Get-ColorScriptList | Select-Object -First 10` to preview your first 10 scripts!
