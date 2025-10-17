# ColorScripts-Enhanced PowerShell Module

> **Credits:** This project owes its existence to the foundational work of two developers. The beautiful ANSI art scripts were originally created and/or sourced by Derek Taylor (DistroTube) in his project [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts). The collection was then ported to PowerShell by Scott McKendry as [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts). `ColorScripts-Enhanced` builds upon their efforts by introducing a high-performance caching system, PowerShell Cross-Platform support on Linux and Mac, an expanded command set, and a formal module structure.

<!-- Download & Version Badges -->

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/ColorScripts-Enhanced?logo=powershell&label=PSGallery)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/ColorScripts-Enhanced?logo=powershell&label=Downloads)](https://www.powershellgallery.com/packages/ColorScripts-Enhanced)
[![NuGet Version](https://img.shields.io/nuget/v/ColorScripts-Enhanced?logo=nuget&label=NuGet)](https://www.nuget.org/packages/ColorScripts-Enhanced/)
[![NuGet Downloads](https://img.shields.io/nuget/dt/ColorScripts-Enhanced?logo=nuget&label=Downloads)](https://www.nuget.org/packages/ColorScripts-Enhanced/)
[![GitHub Release](https://img.shields.io/github/v/release/Nick2bad4u/ps-color-scripts-enhanced?logo=github&label=Release)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/releases/latest)

<!-- CI/CD & Quality Badges -->

[![Tests](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml)
[![Publish](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/badge)](https://scorecard.dev/viewer/?uri=github.com/Nick2bad4u/PS-Color-Scripts-Enhanced)
[![Dependency Review](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/actions/workflows/dependency-review.yml)

<!-- Platform & Compatibility -->

[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-blue?logo=windows-terminal)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B%20%7C%207.0%2B-blue.svg?logo=powershell)](https://github.com/PowerShell/PowerShell)
[![Code Size](https://img.shields.io/github/languages/code-size/Nick2bad4u/ps-color-scripts-enhanced?logo=github)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
[![Repo Stars](https://img.shields.io/github/stars/Nick2bad4u/ps-color-scripts-enhanced?style=social)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/stargazers)

<!-- License & Contributing -->

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A high-performance PowerShell module for displaying beautiful ANSI colorscripts in your terminal with intelligent caching for 6-19x faster load times.

## Table of Contents

- [Features](#features)
- [Demo](#demo)
- [Quick Start](#quick-start-less-than-a-minute)
- [PowerShell Support](#powershell-support)
- [Install a Nerd Font](#install-a-nerd-font-for-custom-glyphs)
- [Installation](#installation)
- [Usage](#usage)
- [Performance](#performance)
- [Available Colorscripts](#available-colorscripts)
- [Commands](#commands)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Features

✨ **<!-- COLOR_SCRIPT_COUNT_PLUS -->327+<!-- /COLOR_SCRIPT_COUNT_PLUS --> Beautiful Colorscripts** - Extensive collection of ANSI art

⚡ **Intelligent Caching** - 6-19x performance improvement (5-20ms load times)

🌐 **OS-Wide Cache** - Consistent caching across all terminal sessions

🎯 **Simple API** - Easy-to-use cmdlets with tab completion

⚙️ **Configurable Defaults** - Persist cache locations and startup behaviour via module configuration

🔄 **Auto-Update** - Cache automatically invalidates when scripts change

📍 **Centralized Storage** - Cache stored in `%APPDATA%\ColorScripts-Enhanced\cache`

## Demo

ColorScripts-Enhanced Demo: <https://i.imgur.com/FCjqkxn.mp4>

**Open in new tab since video is too large for github**

![ColorScripts-Example-1](https://raw.githubusercontent.com/Nick2bad4u/PS-Color-Scripts-Enhanced/refs/heads/main/assets/ColorScript-example-1.png) ![ColorScripts-Example-2](https://raw.githubusercontent.com/Nick2bad4u/PS-Color-Scripts-Enhanced/refs/heads/main/assets/ColorScript-example-2.png) ![ColorScripts-Example-3](https://raw.githubusercontent.com/Nick2bad4u/PS-Color-Scripts-Enhanced/refs/heads/main/assets/ColorScript-example-3.png)

**+ <!-- COLOR_SCRIPT_COUNT_MINUS_IMAGES -->324<!-- /COLOR_SCRIPT_COUNT_MINUS_IMAGES --> more colorscripts available!**

## Quick Start (Less Than a Minute)

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
Add-ColorScriptProfile              # Optional: add to profile immediately
Show-ColorScript
```

> Requires PowerShell 5.1 or later. PowerShell 7.4+ recommended for best performance and PSResourceGet support.

## PowerShell Support

We test every change across Windows, macOS, and Linux. See the full matrix in [docs/POWERSHELL-VERSIONS.md](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/POWERSHELL-VERSIONS.md).

| Platform | PowerShell 5.1                   | PowerShell 7.x                                 |
| -------- | -------------------------------- | ---------------------------------------------- |
| Windows  | ✅ Unit tests, module validation | ✅ Unit tests, ScriptAnalyzer, help validation |
| macOS    | ❌ Not available                 | ✅ Unit tests, ScriptAnalyzer                  |
| Linux    | ❌ Not available                 | ✅ Unit tests, ScriptAnalyzer                  |

> We intentionally run ScriptAnalyzer only on PowerShell 7.x because the 5.1 engine applies different rules that conflict with modern cross-platform patterns.

## Install a Nerd Font for Custom Glyphs

Several scripts display Nerd Font icons (powerline separators, dev icons, logos). Without a Nerd Font, those glyphs render as blank boxes. Pick one of the patched fonts from [nerdfonts.com](https://www.nerdfonts.com/) and set it as your terminal font:

1. **Download** a font (e.g., _Cascadia Code_, _FiraCode_, _JetBrainsMono_) from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).
2. **Install on Windows**: extract the `.zip`, select the `.ttf` files, right-click → **Install for all users**. **macOS**: `brew install --cask font-caskaydia-cove-nerd-font` (or double-click in Font Book). **Linux**: copy the `.ttf` files to `~/.local/share/fonts` (or `/usr/local/share/fonts`), then run `fc-cache -fv`.
3. **Update your terminal** (Windows Terminal, VS Code, Alacritty, etc.) to use the installed Nerd Font for each profile.
4. **Verify** by running:

```powershell
Show-ColorScript -Name nerd-font-test
```

The script will render checkmarks and dev icons when the font is configured correctly.

## Installation

### Option 1: PowerShell Gallery (Recommended)

The module is published to the PowerShell Gallery, making installation a single command:

```powershell
# PowerShellGet (Windows PowerShell 5.1 / PowerShell 7)
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser

# PSResourceGet (PowerShell 7.4+)
Install-PSResource -Name ColorScripts-Enhanced -Scope CurrentUser

# Update to latest release later
Update-Module ColorScripts-Enhanced
```

> 💡 Tip: Set `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` if your environment restricts script execution during installation.

### Option 2: GitHub Packages (Optional)

If you prefer GitHub Packages (for private mirrors or enterprise environments):

```powershell
$owner  = 'Nick2bad4u'
$source = "https://nuget.pkg.github.com/$owner/index.json"

Register-PSRepository -Name ColorScriptsEnhanced-GitHub -SourceLocation $source -PublishLocation $source -InstallationPolicy Trusted -PackageManagementProvider NuGet
Install-Module -Name ColorScripts-Enhanced -Repository ColorScriptsEnhanced-GitHub -Scope CurrentUser
```

Authenticate with a GitHub PAT (Package Read scope) if prompted.

### Option 3: Manual Installation

1. Copy the `ColorScripts-Enhanced` folder to one of your PowerShell module paths:

```powershell
# See available module paths
$env:PSModulePath -split ';'

# Recommended location (user-specific)
$modulePath = "$env:USERPROFILE\Documents\PowerShell\Modules\ColorScripts-Enhanced"

# Copy the module folder to the destination
Copy-Item -Path ".\ColorScripts-Enhanced" -Destination $modulePath -Recurse -Force
```

1. Import the module:

```powershell
Import-Module ColorScripts-Enhanced
```

1. (Optional) Add to your PowerShell profile for automatic loading:

```powershell
Add-Content -Path $PROFILE.CurrentUserAllHosts -Value "Import-Module ColorScripts-Enhanced"
```

Alternatively, run `Add-ColorScriptProfile -Scope CurrentUserAllHosts -SkipStartupScript` after importing the module.

### Option 4: Quick Test (Without Installation)

```powershell
Import-Module ".\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
```

### (Optional) Add to Your PowerShell Profile

Use the built-in helper to import the module (and optionally display a random colorscript) at shell startup:

```powershell
Add-ColorScriptProfile
```

Key options:

- `Add-ColorScriptProfile -SkipStartupScript` -- import the module without showing a script on launch.
- `Add-ColorScriptProfile -Scope CurrentUserCurrentHost` -- limit to the current host (e.g., just VS Code).
- `Add-ColorScriptProfile -Path .\MyCustomProfile.ps1` -- target an explicit profile file.

## Usage

### Display a Random Colorscript

```powershell
Show-ColorScript
# or use the alias
scs
```

### Display a Specific Colorscript

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
# or
scs mandelbrot-zoom
```

```powershell
# Use wildcards to target a family of scripts
Show-ColorScript -Name "aurora-*"
```

### List All Available Colorscripts

```powershell
Show-ColorScript -List
# or
Get-ColorScriptList
```

```powershell
# Return objects for automation
$scripts = Get-ColorScriptList -AsObject
$scripts | Select-Object Name, Category, Tags | Format-Table

# Show additional metadata in the table view
Get-ColorScriptList -Detailed
```

### Filter by Category or Tag

```powershell
# All pattern-based scripts
Get-ColorScriptList -Category Patterns

# Recommended scripts surfaced by metadata
Get-ColorScriptList -Tag Recommended -Detailed

# Display a random recommended script and return its metadata
Show-ColorScript -Tag Recommended -PassThru
```

### Build Cache for Faster Performance

```powershell
# Cache all colorscripts (recommended)
Build-ColorScriptCache

# Cache specific colorscripts
Build-ColorScriptCache -Name "bars","hearts","arch"

# Force rebuild cache
Build-ColorScriptCache -Force

# Cache every script whose name starts with "aurora-"
Build-ColorScriptCache -Name "aurora-*"
```

> `Build-ColorScriptCache` caches the entire library by default, so specifying `-All` is optional. Use `-PassThru` when you need per-script status objects. Without it you'll just see the concise on-screen summary.

### Clear Cache

```powershell
# Clear all cache files
Clear-ColorScriptCache -All

# Clear specific cache
Clear-ColorScriptCache -Name "mandelbrot-zoom"

# Preview what would be deleted (no files removed)
Clear-ColorScriptCache -Name "mandelbrot-zoom" -DryRun

# Clear caches in an alternate location
Clear-ColorScriptCache -Name "mandelbrot-zoom" -Path 'C:/temp/colorscripts-cache'

# Remove all caches that match a wildcard pattern
Clear-ColorScriptCache -Name "aurora-*" -Confirm:$false
```

> Tip: Set `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` to redirect cache files to a custom directory for CI or ephemeral test runs.

### Persist Defaults with Configuration

```powershell
# Inspect current configuration (cache path, startup behaviour)
Get-ColorScriptConfiguration

# Persist a custom cache path and disable automatic profile startup
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -ProfileAutoShow:$false

# Reset everything to defaults
Reset-ColorScriptConfiguration
```

Configuration is stored in `%APPDATA%/ColorScripts-Enhanced/config.json` (or the equivalent on macOS/Linux). Set `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` to redirect the configuration location for portable or CI scenarios.

### Export Metadata for External Tools

```powershell
# Emit metadata objects to the pipeline
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo

# Persist a JSON snapshot for front-end tooling
Export-ColorScriptMetadata -Path ./dist/colorscripts-metadata.json -IncludeFileInfo
```

Metadata includes categories, tags, descriptions, script paths, and optional cache details--perfect for building dashboards, search interfaces, or gallery listings.

### Scaffold a New Colorscript

```powershell
# Create a new colorscript skeleton in the Scripts directory
$scaffold = New-ColorScript -Name 'my-awesome-script' -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'

# Inspect metadata guidance for ScriptMetadata.psd1 updates
$scaffold.MetadataGuidance
```

The scaffolded script includes a UTF-8 template with placeholders so you can paste ANSI art directly. The optional metadata guidance hints at how to categorise the new script in `ScriptMetadata.psd1`.

### Bypass Cache (Force Fresh Execution)

```powershell
Show-ColorScript -Name "bars" -NoCache
```

### Test the Entire Collection

```powershell
# Sequential run with metadata-rich summary results
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Filter 'bars' -Delay 0 -SkipErrors

# Parallel run (PowerShell 7+) for faster CI coverage
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1 -Parallel -SkipErrors -ThrottleLimit 4
```

### Lint with PowerShell 7

```powershell
.\scripts\Lint-PS7.ps1
```

## Commands

| Command                          | Alias | Description                                                                        |
| -------------------------------- | ----- | ---------------------------------------------------------------------------------- |
| `Show-ColorScript`               | `scs` | Display a colorscript                                                              |
| `Get-ColorScriptList`            | -     | List all available colorscripts                                                    |
| `Build-ColorScriptCache`         | -     | Pre-generate cache files                                                           |
| `Clear-ColorScriptCache`         | -     | Remove cache files                                                                 |
| `Add-ColorScriptProfile`         | -     | Append module startup snippet to your profile                                      |
| `Get-ColorScriptConfiguration`   | -     | Inspect persisted defaults (cache path, startup behaviour)                         |
| `Set-ColorScriptConfiguration`   | -     | Update configuration values and immediately persist them                           |
| `Reset-ColorScriptConfiguration` | -     | Restore configuration to factory defaults                                          |
| `Export-ColorScriptMetadata`     | -     | Export metadata and cache info as JSON for external tooling                        |
| `New-ColorScript`                | -     | Scaffold a new colorscript skeleton with metadata guidance                         |
| `Install.ps1`                    | -     | Optional local installer with `-AddToProfile`, `-SkipStartupScript`, `-BuildCache` |

### Getting Help

PowerShell uses the `Get-Help` cmdlet for command documentation. Traditional CLI flags like `--help` or `-h` will not work.

```powershell
# Get basic help
Get-Help Show-ColorScript

# Get detailed help with examples
Get-Help Show-ColorScript -Full

# Get only examples
Get-Help Show-ColorScript -Examples

# Get help for a specific parameter
Get-Help Show-ColorScript -Parameter Name

# Module help
Get-Help about_ColorScripts-Enhanced
```

## Documentation

### User Documentation

- [Quick Start & Reference](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/QUICK_REFERENCE.md)
- [ANSI Color Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ANSI-COLOR-GUIDE.md)
- [ANSI Conversion Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ANSI-CONVERSION-GUIDE.md)
- [ANSI Conversion Examples](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/examples/ansi-conversion/README.md)
- [Module Summary](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/MODULE_SUMMARY.md)

### Developer Documentation

- [Development Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/Development.md)
- [Testing Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/TESTING.md)
- [Linting Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/LINTING.md)
- [npm Scripts Reference](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/NPM_SCRIPTS.md)
- [Publishing Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/Publishing.md)
- [Release Checklist](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ReleaseChecklist.md)

### Project Information

- [Support Policy](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/SUPPORT.md)
- [Code of Conduct](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CODE_OF_CONDUCT.md)
- [Security Policy](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/SECURITY.md)
- [Project Roadmap](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ROADMAP.md)
- [Documentation Index](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/DOCUMENTATION_INDEX.md)

## Contributing

We welcome contributions! Please review [CONTRIBUTING.md](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CONTRIBUTING.md) for:

- Development setup and workflow
- Coding standards and best practices
- How to submit pull requests
- Testing requirements

For development-specific tasks, see the [Developer Documentation](#developer-documentation) section above.

## Performance

### Before Caching

- Simple scripts: 30-50ms
- Complex scripts: 200-400ms

### After Caching

- All scripts: 5-20ms
- **Improvement: 6-19x faster!**

### Example Performance Gains

| Script          | Without Cache | With Cache | Speedup |
| --------------- | ------------- | ---------- | ------- |
| bars            | 31ms          | 5ms        | **6x**  |
| gradient-bars   | 65ms          | 8ms        | **8x**  |
| mandelbrot-zoom | 365ms         | 19ms       | **19x** |

## Cache System

### How It Works

1. **First Run**: Script executes normally and output is cached
2. **Subsequent Runs**: Cached output is displayed instantly
3. **Auto-Invalidation**: Cache updates when source script changes
4. **OS-Wide**: Single cache location works from any directory

### Cache Location

The module stores cached output in platform-specific directories:

**Windows:**

```
C:\Users\[Username]\AppData\Roaming\ColorScripts-Enhanced\cache\
```

**macOS:**

```
~/Library/Application Support/ColorScripts-Enhanced/cache/
```

**Linux:**

```
~/.cache/ColorScripts-Enhanced/
```

To find your cache location programmatically:

```powershell
# Windows
$env:APPDATA\ColorScripts-Enhanced\cache

# macOS
~/Library/Application Support/ColorScripts-Enhanced/cache

# Linux
~/.cache/ColorScripts-Enhanced
```

### Cache Files

- One `.cache` file per colorscript
- Contains pre-rendered ANSI output
- Average size: ~20KB per file
- Total size: ~4.9MB for <!-- COLOR_SCRIPT_COUNT_PLUS -->327+<!-- /COLOR_SCRIPT_COUNT_PLUS --> scripts

## Examples

### Add to PowerShell Profile

Display a random colorscript every time you open PowerShell:

```powershell
# Edit your profile
notepad $PROFILE.CurrentUserAllHosts

# Add this line:
Import-Module ColorScripts-Enhanced
Show-ColorScript
```

### Create Custom Alias

```powershell
# Add to profile
Set-Alias -Name cs -Value Show-ColorScript
```

### Build Cache on Module Import

```powershell
# Add to profile after Import-Module
Import-Module ColorScripts-Enhanced
Build-ColorScriptCache
```

## Available Colorscripts

The module includes <!-- COLOR_SCRIPT_COUNT_PLUS -->327+<!-- /COLOR_SCRIPT_COUNT_PLUS --> colorscripts including:

- **Fractals**: mandelbrot-zoom, julia-morphing, barnsley-fern, koch-snowflake
- **Patterns**: kaleidoscope, wave-pattern, rainbow-waves, gradient-bars
- **Characters**: pacman, space-invaders, tux, darthvader
- **Nature**: galaxy-spiral, aurora-storm, crystal-grid, nebula
- **Mathematical**: fibonacci-spiral, penrose-quasicrystal, hilbert-spectrum
- And many more!

Use `Show-ColorScript -List` to see all available scripts.

## Troubleshooting

### Cache Not Working

```powershell
# Rebuild cache
Build-ColorScriptCache -Force

# Check cache location
explorer "$env:APPDATA\ColorScripts-Enhanced\cache"
```

### Cache Files Locked or Refusing to Delete

```powershell
# Preview what would be removed without touching the filesystem
Clear-ColorScriptCache -Name 'bars' -DryRun

# Force deletion after closing terminals that might hold locks
Clear-ColorScriptCache -Name 'bars' -Confirm:$false
```

If a cache file stays locked, close any terminals showing the script, then retry the commands above. As a last resort, specify `-Path` with a custom cache root and move the cache elsewhere.

### Module Not Found

```powershell
# Verify module path
Get-Module ColorScripts-Enhanced -ListAvailable

# Check PSModulePath
$env:PSModulePath -split ';'
```

### Colorscript Not Displaying

```powershell
# Try without cache
Show-ColorScript -Name "scriptname" -NoCache

# Check if script exists
Get-ColorScriptList
```

### Icons or glyphs show as squares

```powershell
# Confirm Nerd Font installation
Show-ColorScript -Name nerd-font-test

# If icons are missing:
# 1\. Install a Nerd Font from https://www.nerdfonts.com/
# 2\. Set your terminal profile to use the installed font
# 3\. Restart the terminal session
```

## Requirements

- **PowerShell:** 5.1 or higher (PowerShell 7+ recommended)
- **Operating System:**
  - Windows 10/11
  - macOS 10.13+
  - Linux (Ubuntu, Debian, Fedora, etc.)

- **Terminal:** ANSI-capable terminal
  - Windows: Windows Terminal, VS Code Terminal, ConEmu
  - macOS: Terminal.app, iTerm2, VS Code Terminal
  - Linux: GNOME Terminal, Konsole, xterm, VS Code Terminal

- **Optional:** Nerd Font for glyph-heavy scripts like `nerd-font-test`

## Architecture

```
ColorScripts-Enhanced/
├── ColorScripts-Enhanced.psd1    # Module manifest
├── ColorScripts-Enhanced.psm1    # Main module file
├── Scripts/                       # Colorscript files
│   ├── bars.ps1
│   ├── hearts.ps1
│   ├── mandelbrot-zoom.ps1
│   └── ... (<!-- COLOR_CACHE_TOTAL -->327+<!-- /COLOR_CACHE_TOTAL --> total)
└── README.md                      # This file

%APPDATA%/ColorScripts-Enhanced/
└── cache/                         # Cache files
    ├── bars.cache
    ├── hearts.cache
    └── ... (<!-- COLOR_CACHE_TOTAL -->327+<!-- /COLOR_CACHE_TOTAL --> total)
```

## Contributing

Contributions welcome! When adding new colorscripts:

1. Place `.ps1` file in `Scripts/` directory
2. Use ANSI escape codes for colors
3. Keep output concise (fits in standard terminal)
4. Test with `Show-ColorScript -Name "yourscript" -NoCache`
5. Build cache with `Build-ColorScriptCache -Name "yourscript"`

## License

MIT License – see [LICENSE](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE) file for details

## Version History

See [CHANGELOG.md](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CHANGELOG.md) for detailed version history and release notes.

### Latest Release

**2025.10.12** - Cross-platform support, enhanced caching, and <!-- COLOR_SCRIPT_COUNT_PLUS -->327+<!-- /COLOR_SCRIPT_COUNT_PLUS --> colorscripts

## Documentation

- 📖 [Quick Start & Reference](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/QUICK_REFERENCE.md)
- 🌈 [ANSI Color Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ANSI-COLOR-GUIDE.md)
- 🧰 [ANSI Conversion Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ANSI-CONVERSION-GUIDE.md)
- 📋 [Module Summary](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/MODULE_SUMMARY.md)
- 🔧 [Development Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/Development.md)
- 📦 [Publishing Guide](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/Publishing.md)
- ✅ [Release Checklist](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ReleaseChecklist.md)
- 🤝 [Contributing Guidelines](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CONTRIBUTING.md)
- 🛡️ [Security Policy](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/SECURITY.md)
- 🙌 [Code of Conduct](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CODE_OF_CONDUCT.md)
- 🧭 [Project Roadmap](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/ROADMAP.md)
- 💬 [Support Policy](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/SUPPORT.md)
- 🔄 [Changelog](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CHANGELOG.md)

## CI/CD & Workflows

- ⚙️ [Test Workflow](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/.github/workflows/test.yml)
- 📦 [Publish Workflow](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/.github/workflows/publish.yml)
- 🤖 [Dependabot Updates](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/.github/dependabot.yml)

## Support

For support options, response targets, and contact channels, review the [Support Policy](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/docs/SUPPORT.md). Bug reports and feature ideas live in the [issue tracker](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues).

---

**Enjoy the colors and scripts!** 🌈✨

**ANSI art sourced from:**

- [DistroTube's shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts)

- [Scott McKendry's ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts)

- [16colo.rs](https://16colo.rs/)

- [ArtScene Textfiles](http://artscene.textfiles.com/artpacks/)

- [r/ANSIart](https://www.reddit.com/r/ANSIart/)

- [Sixteen Colors Facebook](https://www.facebook.com/sixteencolors/)

