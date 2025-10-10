# PowerShell Version Support Strategy

## Overview

This module supports both **Windows PowerShell 5.1** and **PowerShell 7.x** across multiple platforms.

---

## PowerShell Versions Explained

### Windows PowerShell 5.1 (Desktop Edition)
- **Platform:** Windows ONLY
- **Shipping:** Built into Windows 10/11
- **Runtime:** .NET Framework 4.x
- **Status:** Maintenance mode (no new features)
- **Use Case:** Legacy Windows systems, enterprise environments

### PowerShell 7.x (Core Edition)
- **Platforms:** Windows, macOS, Linux
- **Runtime:** .NET Core / .NET 5+
- **Status:** Active development
- **Cross-platform:** True cross-platform support
- **Use Case:** Modern, cross-platform scenarios

---

## CI/CD Test Matrix

### ✅ What We Test

| Platform | PowerShell Version | Reason |
|----------|-------------------|--------|
| Windows  | 5.1 (Desktop)     | Legacy Windows support |
| Windows  | 7.5 (Core)        | Modern Windows |
| macOS    | 7.5 (Core)        | Mac support |
| Linux    | 7.5 (Core)        | Linux support |

### ❌ What We DON'T Test

| Platform | PowerShell Version | Reason |
|----------|-------------------|--------|
| macOS    | 5.1 (Desktop)     | **Doesn't exist** - Windows PowerShell is Windows-only |
| Linux    | 5.1 (Desktop)     | **Doesn't exist** - Windows PowerShell is Windows-only |

---

## Key Differences

### Platform Detection Variables

**PowerShell 7.x only:**
```powershell
$IsWindows  # True on Windows
$IsMacOS    # True on macOS
$IsLinux    # True on Linux
```

**PowerShell 5.1 fallback:**
```powershell
if ($PSVersionTable.PSVersion.Major -le 5) {
    # This is PowerShell 5.1 on Windows
}
```

### Join-Path Behavior

**PowerShell 5.1:**
```powershell
# ❌ This fails in 5.1
$path = Join-Path $root "folder1" "folder2"

# ✅ This works in 5.1
$path = Join-Path -Path $root -ChildPath "folder1"
$path = Join-Path -Path $path -ChildPath "folder2"
```

**PowerShell 7.x:**
```powershell
# ✅ Both work in 7.x
$path = Join-Path $root "folder1" "folder2"
$path = Join-Path -Path $root -ChildPath "folder1" -AdditionalChildPath "folder2"
```

---

## Module Compatibility Strategy

### 1. Version Detection
```powershell
if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
    # Windows (any PowerShell version)
}
elseif ($IsMacOS) {
    # macOS (PowerShell 7.x only)
}
else {
    # Linux (PowerShell 7.x only)
}
```

### 2. Path Operations
Always use sequential `Join-Path` calls for maximum compatibility:
```powershell
$path = Join-Path -Path $base -ChildPath "subfolder"
$path = Join-Path -Path $path -ChildPath "file.txt"
```

### 3. Environment Variables
Use platform-appropriate variables:
```powershell
# Windows
$cacheDir = Join-Path -Path $env:APPDATA -ChildPath "AppName"

# macOS
$cacheDir = Join-Path -Path $HOME -ChildPath "Library/Application Support/AppName"

# Linux
$cacheDir = if ($env:XDG_CACHE_HOME) {
    Join-Path -Path $env:XDG_CACHE_HOME -ChildPath "AppName"
} else {
    Join-Path -Path $HOME -ChildPath ".cache/AppName"
}
```

---

## Testing Strategy

### Local Testing
```powershell
# Test on Windows PowerShell 5.1
powershell.exe -Command "& .\Test-Module.ps1"

# Test on PowerShell 7.x
pwsh -Command "& .\Test-Module.ps1"
```

### CI/CD Testing
- **Windows runners:** Test both 5.1 and 7.x
- **macOS runners:** Test 7.x only (5.1 not available)
- **Linux runners:** Test 7.x only (5.1 not available)

---

## PSScriptAnalyzer Handling

### Scripts Folder Exclusion
The `Scripts/` folder contains colorscripts with artistic formatting that intentionally violates style guidelines. We exclude it from linting:

```powershell
# Get module files only (exclude colorscripts)
$files = Get-ChildItem -Path './ColorScripts-Enhanced' -File -Recurse -Include *.ps1, *.psm1, *.psd1 |
    Where-Object { $_.FullName -notlike '*Scripts*' }

# Lint only module files
foreach ($file in $files) {
    Invoke-ScriptAnalyzer -Path $file.FullName -Settings './PSScriptAnalyzerSettings.psd1'
}
```

---

## Summary

✅ **DO:**
- Test PowerShell 5.1 on Windows
- Test PowerShell 7.x on all platforms (Windows, macOS, Linux)
- Use sequential Join-Path for compatibility
- Detect platform with version checks

❌ **DON'T:**
- Try to test PowerShell 5.1 on macOS/Linux (impossible)
- Use multiple arguments with Join-Path
- Assume platform variables exist in 5.1
- Lint colorscripts in Scripts folder

---

## References

- [PowerShell Version Support](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle)
- [PowerShell 7.x vs Windows PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell)
- [Cross-platform PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
