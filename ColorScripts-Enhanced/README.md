## Credits

Based on the PowerShell port [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts) by Scott McKendry, which is itself based on the excellent [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts) by Derek Taylor.

# ColorScripts-Enhanced PowerShell Module

[![Tests](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/test.yml)
[![Publish](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml/badge.svg)](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/actions/workflows/publish.yml)

A high-performance PowerShell module for displaying beautiful ANSI colorscripts in your terminal with intelligent caching for 6-19x faster load times.

## Features

✨ **185+ Beautiful Colorscripts** - Extensive collection of ANSI art

⚡ **Intelligent Caching** - 6-19x performance improvement (5-20ms load times)

🌐 **OS-Wide Cache** - Consistent caching across all terminal sessions

🎯 **Simple API** - Easy-to-use cmdlets with tab completion

🔄 **Auto-Update** - Cache automatically invalidates when scripts change

📍 **Centralized Storage** - Cache stored in `%APPDATA%\ColorScripts-Enhanced\cache`

## Demo

ColorScripts-Enhanced Demo: https://i.imgur.com/FCjqkxn.mp4

**Open in new tab since video is too large for github**

<img width="780" height="797" alt="image" src="https://github.com/user-attachments/assets/1d05d7b0-e648-47dc-a53f-d6d3f539f562" />
<img width="525" height="563" alt="image" src="https://github.com/user-attachments/assets/4c0dbf5e-f697-4ae6-8e2b-57e5052cb4c2" />
<img width="607" height="854" alt="image" src="https://github.com/user-attachments/assets/95953355-1ad3-4d71-a56e-9e36a67671bd" />

**+ 170~ more**

## Quick Start (Less Than a Minute)

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
Add-ColorScriptProfile              # Optional: add to profile immediately
Show-ColorScript
```

> Requires PowerShell 5.1 or later. PowerShell 7.4+ recommended for best performance and PSResourceGet support.

## Install a Nerd Font for Custom Glyphs

Several scripts display Nerd Font icons (powerline separators, dev icons, logos). Without a Nerd Font, those glyphs render as blank boxes. Pick one of the patched fonts from [nerdfonts.com](https://www.nerdfonts.com/) and set it as your terminal font:

1. **Download** a font (e.g., _Cascadia Code_, _FiraCode_, _JetBrainsMono_) from the [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases).
2. **Install on Windows**: extract the `.zip`, select the `.ttf` files, right-click → **Install for all users**.
   **macOS**: `brew install --cask font-caskaydia-cove-nerd-font` (or double-click in Font Book).
   **Linux**: copy the `.ttf` files to `~/.local/share/fonts` (or `/usr/local/share/fonts`), then run `fc-cache -fv`.
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

2. Import the module:

   ```powershell
   Import-Module ColorScripts-Enhanced
   ```

3. (Optional) Add to your PowerShell profile for automatic loading:

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

- `Add-ColorScriptProfile -SkipStartupScript` — import the module without showing a script on launch.
- `Add-ColorScriptProfile -Scope CurrentUserCurrentHost` — limit to the current host (e.g., just VS Code).
- `Add-ColorScriptProfile -Path .\MyCustomProfile.ps1` — target an explicit profile file.

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

### List All Available Colorscripts

```powershell
Show-ColorScript -List
# or
Get-ColorScriptList
```

### Build Cache for Faster Performance

```powershell
# Cache all colorscripts (recommended)
Build-ColorScriptCache -All

# Cache specific colorscripts
Build-ColorScriptCache -Name "bars","hearts","arch"

# Force rebuild cache
Build-ColorScriptCache -All -Force
```

### Clear Cache

```powershell
# Clear all cache files
Clear-ColorScriptCache -All

# Clear specific cache
Clear-ColorScriptCache -Name "mandelbrot-zoom"
```

### Bypass Cache (Force Fresh Execution)

```powershell
Show-ColorScript -Name "bars" -NoCache
```

## Commands

| Command                  | Alias | Description                                                                        |
| ------------------------ | ----- | ---------------------------------------------------------------------------------- |
| `Show-ColorScript`       | `scs` | Display a colorscript                                                              |
| `Get-ColorScriptList`    | -     | List all available colorscripts                                                    |
| `Build-ColorScriptCache` | -     | Pre-generate cache files                                                           |
| `Clear-ColorScriptCache` | -     | Remove cache files                                                                 |
| `Add-ColorScriptProfile` | -     | Append module startup snippet to your profile                                      |
| `Install.ps1`            | -     | Optional local installer with `-AddToProfile`, `-SkipStartupScript`, `-BuildCache` |

## Documentation

- [Quick Start](QUICKSTART.md)
- [Quick Reference](QUICKREFERENCE.md)
- [Module Summary](MODULE_SUMMARY.md)
- [Development Guide](docs/Development.md)
- [Publishing Guide](docs/Publishing.md)
- [Release Checklist](docs/ReleaseChecklist.md)

## Quality & Testing

- Smoke tests (includes ScriptAnalyzer): `pwsh -NoProfile -Command "& .\Test-Module.ps1"`
- Full test suite: `Invoke-Pester -Path ./Tests`
- Linting (module only): `pwsh -NoProfile -Command "& .\Lint-Module.ps1"`
- Linting (treat warnings as errors and include tests): `pwsh -NoProfile -Command "& .\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors`
- Lint auto-fix (apply ScriptAnalyzer fixes, then re-run lint): `pwsh -NoProfile -Command "& .\Lint-Module.ps1" -Fix`
- Continuous integration: [`test.yml`](.github/workflows/test.yml) runs on Windows PowerShell 5.1 and PowerShell 7.4 across Windows, Linux, and macOS runners.

## Release & Publishing

- Automated publishing workflow: [`publish.yml`](.github/workflows/publish.yml)
- Local helper script: `build.ps1`
- Optional help generation: `Build-Help.ps1`
- Documentation: [Publishing Guide](docs/Publishing.md) & [Release Checklist](docs/ReleaseChecklist.md)

## Additional Package Feeds

- PowerShell Gallery / NuGet.org (primary distribution)
- GitHub Packages (optional; instructions in [Publishing Guide](docs/Publishing.md))
- Azure Artifacts or other NuGet-compatible feeds for enterprise deployment

## Contributing

Please review [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines, coding standards, and how to submit pull requests.

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

```
C:\Users\[Username]\AppData\Roaming\ColorScripts-Enhanced\cache\
```

### Cache Files

- One `.cache` file per colorscript
- Contains pre-rendered ANSI output
- Average size: ~20KB per file
- Total size: ~3.7MB for all 185 scripts

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
Build-ColorScriptCache -All
```

## Available Colorscripts

The module includes 185 colorscripts including:

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
Build-ColorScriptCache -All -Force

# Check cache location
explorer "$env:APPDATA\ColorScripts-Enhanced\cache"
```

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
# 1. Install a Nerd Font from https://www.nerdfonts.com/
# 2. Set your terminal profile to use the installed font
# 3. Restart the terminal session
```

## Requirements

- PowerShell 5.1 or higher
- Windows (tested on Windows 10/11)
- ANSI-capable terminal (Windows Terminal, VS Code, etc.)
- Nerd Font (optional but recommended for glyph-heavy scripts like `nerd-font-test`)

## Architecture

```
ColorScripts-Enhanced/
├── ColorScripts-Enhanced.psd1    # Module manifest
├── ColorScripts-Enhanced.psm1    # Main module file
├── Scripts/                       # Colorscript files
│   ├── bars.ps1
│   ├── hearts.ps1
│   ├── mandelbrot-zoom.ps1
│   └── ... (173 more)
└── README.md                      # This file

%APPDATA%/ColorScripts-Enhanced/
└── cache/                         # Cache files
    ├── bars.cache
    ├── hearts.cache
    └── ... (185 total)
```

## Contributing

Contributions welcome! When adding new colorscripts:

1. Place `.ps1` file in `Scripts/` directory
2. Use ANSI escape codes for colors
3. Keep output concise (fits in standard terminal)
4. Test with `Show-ColorScript -Name "yourscript" -NoCache`
5. Build cache with `Build-ColorScriptCache -Name "yourscript"`

## License

MIT License - See LICENSE file for details

## Version History

### 1.0.0 (2025-09-30)

- Initial release
- 185 colorscripts included
- High-performance caching system
- OS-wide cache in AppData
- Complete PowerShell module structure
- 6-19x performance improvement

## Support

For issues, questions, or contributions, please visit the GitHub repository.

---

**Enjoy your colorful terminal! 🌈**
