# ColorScripts-Enhanced PowerShell Module

> **Credits:** Built upon [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts) by Derek Taylor and [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts) by Scott McKendry. Enhanced with selective output caching, configuration management, and cross-platform support.

[![PowerShell Gallery.](https://img.shields.io/powershellgallery/v/ColorScripts-Enhanced?logo=powershell)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced) [![Downloads.](https://img.shields.io/powershellgallery/dt/ColorScripts-Enhanced?logo=powershell)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced) [![NuGet.](https://img.shields.io/nuget/v/ColorScripts-Enhanced?logo=nuget)](https://www.nuget.org/packages/ColorScripts-Enhanced/) [![Tests.](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml) [![License.](https://img.shields.io/badge/License-Unlicense-yellow.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE)

Discover and display ANSI colorscripts in PowerShell. Static scripts execute directly, while policy-selected computational renderers can reuse validated output.

## Features

- 🎨 **<!-- COLOR_SCRIPT_COUNT_PLUS -->3156+<!-- /COLOR_SCRIPT_COUNT_PLUS --> Colorscripts** — Fractals, patterns, characters, nature scenes, and more
- ⚡ **Selective Caching** — Reuses output for the 15 expensive renderers listed in `CachePolicy.psd1`
- 🌐 **Cross-Platform** — Works on Windows, macOS, and Linux
- ⚙️ **Configurable** — Persist cache location, startup behavior, and defaults
- **Rich Metadata** — Filter by name, category, and tag or export structured catalog data
- 🐾 **2500~ Pokémon ColorScripts** — Opt-in Pokémon-themed colorscripts
  * Note: Pokémon art is filtered by default to keep load times fast. Opt in with `-IncludePokemon` on relevant commands.
- 🌍 **10 Languages** — English, German, Spanish, French, Italian, Japanese, Dutch, Portuguese, Russian, Chinese
- 🗄️ **Platform-Aware Storage** — Query or configure the effective cache path
- 🔄 **Auto-Update** — Cache invalidates automatically when scripts change

## Quick Start

```powershell
Install-Module ColorScripts-Enhanced -Scope CurrentUser

Import-Module ColorScripts-Enhanced
Show-ColorScript # Shows a random colorscript
scs -IncludePokemon # Alias: scs with Pokémon art

Add-ColorScriptProfile
Add-ColorScriptProfile -IncludePokemon -SkipPokemonPrompt
```

## Basic Usage

```powershell
Show-ColorScript  # or alias: scs

Show-ColorScript -Name hearts
scs mandelbrot-zoom

Get-ColorScriptList

Get-ColorScriptList -Category Geometric

New-ColorScriptCache

Show-ColorScript -IncludePokemon

Clear-ColorScriptCache -All
```

## All Commands

| Command                          | Alias | Description                                   |
| -------------------------------- | ----- | --------------------------------------------- |
| `Show-ColorScript`               | `scs` | Display a colorscript (random or by name)     |
| `Get-ColorScriptList`            | -     | List all available colorscripts with metadata |
| `New-ColorScriptCache`           | -     | Build caches for policy-selected renderers    |
| `Clear-ColorScriptCache`         | -     | Remove cache files                            |
| `Add-ColorScriptProfile`         | -     | Add module import to your PowerShell profile  |
| `Get-ColorScriptConfiguration`   | -     | View current configuration settings           |
| `Set-ColorScriptConfiguration`   | -     | Update and persist configuration              |
| `Reset-ColorScriptConfiguration` | -     | Restore default configuration                 |
| `Export-ColorScriptMetadata`     | -     | Export script metadata as JSON                |
| `New-ColorScript`                | -     | Create a new colorscript template             |

## Getting Help

PowerShell uses `Get-Help` for detailed help. Every exported command also accepts `-h` (alias `-help`) for a concise view:

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

Caching is deliberately narrow:

- Static output scripts execute directly without creating cache files.
- The 15 renderers in `CachePolicy.psd1` are eligible for output caching.
- Cache entries are invalidated when relevant source or policy metadata changes.
- Performance depends on the renderer, host, filesystem, and terminal; no fixed multiplier is guaranteed.
- Query `(Get-ColorScriptConfiguration).Cache.EffectivePath` for the effective cache location.

## Profile Integration

Add colorscripts to your PowerShell profile:

```powershell
# Add with automatic random colorscript on startup
Add-ColorScriptProfile

# Import only (no automatic display)
Add-ColorScriptProfile -SkipStartupScript

# Target a specific profile file
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

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
- [Development Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/DEVELOPMENT.md)
- [Issue Tracker](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues)

## Contributing

Submit colorscripts, report bugs, or suggest features.

[CONTRIBUTING.md](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CONTRIBUTING.md)

## License

Project-authored code uses the [Unlicense](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE). Incorporated third-party art remains subject to its original authors' rights and source terms.
