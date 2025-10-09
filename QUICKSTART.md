# ColorScripts-Enhanced - Quick Start Guide

## 🚀 Installation (30 seconds)

```powershell
# Navigate to the module directory
cd ColorScripts-Enhanced

# Run the installer
.\Install.ps1 -AddToProfile -BuildCache
```

That's it! The module is installed and ready to use.

## 🎨 Basic Usage

### Display a Random Colorscript
```powershell
Show-ColorScript
# or simply:
scs
```

### Display a Specific Colorscript
```powershell
scs mandelbrot-zoom
scs hearts
scs galaxy-spiral
```

### See All Available Scripts
```powershell
Get-ColorScriptList
```

## ⚡ First-Time Setup

After installation, build the cache for maximum performance:

```powershell
Build-ColorScriptCache -All
```

This takes a few minutes but makes all colorscripts load **6-19x faster**!

## 💡 Common Uses

### Add to Your PowerShell Profile
Display a random colorscript every time you open PowerShell:

```powershell
# The installer already added this if you used -AddToProfile:
Import-Module ColorScripts-Enhanced
Show-ColorScript
```

### Test the Performance
```powershell
# Time a script without cache
Measure-Command { scs bars -NoCache }

# Time the same script with cache
Measure-Command { scs bars }

# You should see a huge difference!
```

## 📊 Module Commands

| Command | Purpose |
|---------|---------|
| `Show-ColorScript` | Display colorscripts |
| `Get-ColorScriptList` | List all available scripts |
| `Build-ColorScriptCache` | Pre-build cache files |
| `Clear-ColorScriptCache` | Remove cache files |

## 🎯 Pro Tips

1. **Use the alias:** Type `scs` instead of `Show-ColorScript`
2. **Tab completion:** Type `scs man` and press Tab to autocomplete
3. **Build cache:** Run `Build-ColorScriptCache -All` for best performance
4. **Profile integration:** Add `scs` to your profile for startup color!

## 📁 Where Are Things Stored?

- **Module:** `$HOME\Documents\PowerShell\Modules\ColorScripts-Enhanced`
- **Cache:** `$env:APPDATA\ColorScripts-Enhanced\cache`
- **Scripts:** `[Module]\Scripts\*.ps1`

## 🆘 Troubleshooting

### "Module not found"
```powershell
# Verify installation
Get-Module ColorScripts-Enhanced -ListAvailable

# If not found, re-run the installer
.\Install.ps1
```

### "Script not found"
```powershell
# List all available scripts
Get-ColorScriptList

# Use the exact name shown
scs [exact-name]
```

### Cache not working
```powershell
# Rebuild cache
Build-ColorScriptCache -All -Force

# Check cache location
explorer "$env:APPDATA\ColorScripts-Enhanced\cache"
```

## 🎉 You're Ready!

Start exploring the 185 beautiful colorscripts:

```powershell
# Random fun
scs

# Specific favorites
scs mandelbrot-zoom
scs galaxy-spiral
scs rainbow-waves
scs space-invaders
scs kaleidoscope
```

Enjoy your colorful terminal! 🌈
