## Credits

Based on the PowerShell port [ps-color-scripts](https://github.com/scottmckendry/ps-color-scripts) by Scott McKendry, which is itself based on the excellent [shell-color-scripts](https://gitlab.com/dwt1/shell-color-scripts) by Derek Taylor.

# ColorScripts-Enhanced PowerShell Module

A high-performance PowerShell module for displaying beautiful ANSI colorscripts in your terminal with intelligent caching for 6-19x faster load times.

## Features

✨ **185+ Beautiful Colorscripts** - Extensive collection of ANSI art

⚡ **Intelligent Caching** - 6-19x performance improvement (5-20ms load times)

🌐 **OS-Wide Cache** - Consistent caching across all terminal sessions

🎯 **Simple API** - Easy-to-use cmdlets with tab completion

🔄 **Auto-Update** - Cache automatically invalidates when scripts change

📍 **Centralized Storage** - Cache stored in `%APPDATA%\ColorScripts-Enhanced\cache`

## Demo

![ColorScripts-Enhanced Demo](./FCjqkxn.mp4)

## Installation

### Option 1: Manual Installation

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

### Option 2: Quick Test (Without Installation)

```powershell
Import-Module ".\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
```

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

| Command | Alias | Description |
|---------|-------|-------------|
| `Show-ColorScript` | `scs` | Display a colorscript |
| `Get-ColorScriptList` | - | List all available colorscripts |
| `Build-ColorScriptCache` | - | Pre-generate cache files |
| `Clear-ColorScriptCache` | - | Remove cache files |

## Performance

### Before Caching
- Simple scripts: 30-50ms
- Complex scripts: 200-400ms

### After Caching
- All scripts: 5-20ms
- **Improvement: 6-19x faster!**

### Example Performance Gains

| Script | Without Cache | With Cache | Speedup |
|--------|--------------|------------|---------|
| bars | 31ms | 5ms | **6x** |
| gradient-bars | 65ms | 8ms | **8x** |
| mandelbrot-zoom | 365ms | 19ms | **19x** |

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

## Requirements

- PowerShell 5.1 or higher
- Windows (tested on Windows 10/11)
- ANSI-capable terminal (Windows Terminal, VS Code, etc.)

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
