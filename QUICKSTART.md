# ColorScripts-Enhanced - Quick Start Guide

## 🚀 Installation (30 seconds)

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
Add-ColorScriptProfile # Optional: add to profile immediately
```

Offline? Clone the repository and run `.\Install.ps1 -AddToProfile -BuildCache -SkipStartupScript`.

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

## �️ Enable Nerd Font Glyphs

Some scripts use Nerd Font icons (powerline separators, developer glyphs). Without a Nerd Font, those characters appear as empty squares.

1. Grab a patched font from [nerdfonts.com](https://www.nerdfonts.com/) (popular choices: Cascadia Code, JetBrainsMono, FiraCode).
2. Install it:
   - **Windows**: extract the `.zip`, select the `.ttf` files, right-click → **Install for all users**.
   - **macOS**: `brew install --cask font-caskaydia-cove-nerd-font` or add via Font Book.
   - **Linux**: copy the `.ttf` files to `~/.local/share/fonts` (or `/usr/local/share/fonts`) and run `fc-cache -fv`.
3. Open your terminal settings and switch the profile font to the installed Nerd Font.
4. Confirm glyphs render correctly:

```powershell
Show-ColorScript -Name nerd-font-test
```

You should see icons and checkmarks instead of fallback boxes.

## �💡 Common Uses

### Add to Your PowerShell Profile

Display a random colorscript every time you open PowerShell:

```powershell
Add-ColorScriptProfile                 # Import + Show-ColorScript on startup
Add-ColorScriptProfile -SkipStartupScript  # Import only
Add-ColorScriptProfile -Scope CurrentUserCurrentHost  # Current host only
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

| Command                  | Purpose                              |
| ------------------------ | ------------------------------------ |
| `Show-ColorScript`       | Display colorscripts                 |
| `Get-ColorScriptList`    | List all available scripts           |
| `Build-ColorScriptCache` | Pre-build cache files                |
| `Clear-ColorScriptCache` | Remove cache files                   |
| `Add-ColorScriptProfile` | Append module import/startup snippet |

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

# If not found, install from the gallery
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
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

Start exploring the 195 beautiful colorscripts:

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
