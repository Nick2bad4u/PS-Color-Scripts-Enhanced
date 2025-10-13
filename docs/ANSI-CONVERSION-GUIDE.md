# ANSI to ColorScript Conversion Guide

> Looking for turnkey demos? See `examples/ansi-conversion/` for scripts that wrap the commands below.

## Quick Start

Convert a single ANSI file:

```powershell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "myart.ans"
```

## Batch Conversion

Convert all .ans files in a directory:

```powershell
Get-ChildItem -Path "C:\ANSI-Art" -Filter "*.ans" | .\Convert-AnsiToColorScript.ps1
```

## Advanced Options

### Custom Output Name

```powershell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans" -OutputFile "my-custom-script.ps1"
```

### Add Header Comments

```powershell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans" -AddComment
```

### Verbose Mode

```powershell
# See detailed information about conversion process
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans" -Verbose

# Example outputs:
# VERBOSE: Detected single-line ANSI file with cursor positioning - converting to multi-line format
# VERBOSE: Detected 80-column wrapped ANSI file - splitting into multiple lines
# VERBOSE: Detected multi-line ANSI file with some long lines - wrapping at 80 columns
```

### Custom Output Directory

```powershell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans" -OutputDirectory ".\CustomScripts"
```

## How It Works

1. **Reads the ANSI file** - Uses CP437 (DOS/OEM) encoding to properly handle box-drawing and extended ASCII characters
2. **Converts to Unicode** - Preserves all ANSI escape sequences and special characters
3. **Wraps in PowerShell** - Creates a script using `Write-Host @"..."@` syntax
4. **Saves to Scripts folder** - Automatically places in ColorScripts-Enhanced/Scripts
5. **Auto-naming** - Converts filename to lowercase with hyphens (PowerShell convention)

## ANSI File Format

The converter supports standard ANSI art files (.ans) which contain:

- ANSI escape sequences for colors (e.g., `\x1b[31m` for red)
- Box-drawing characters
- Extended ASCII/CP437 characters
- Cursor positioning codes

### Single-Line ANSI Files

Some ANSI files don't use traditional newlines. The converter automatically detects and converts these formats:

#### Format 1: Cursor Positioning

Files that use cursor positioning commands instead of newlines:

**Before (single-line with positioning):**

```
ESC[1;1HRed TextESC[2;1HGreen TextESC[3;1HBlue Text
```

**After (multi-line with newlines):**

```
Red Text
Green Text
Blue Text
```

**Supported cursor commands:**

- `ESC[row;colH` or `ESC[row;colf` - Move cursor to position
- `ESC[nB` - Move cursor down n lines
- `ESC[nC` - Move cursor forward n columns

#### Format 2: 80-Column Wrapped

Files where all content is on one long line meant to wrap every 80 visible characters:

**Before (single long line):**

```
████████...████ ▄▄ ▄▄▄...▄▄ ██ ██ ▀ ▄...▄ ▀ ██...
```

**After (split at 80 columns):**

```
████████...████
██ ▄▄ ▄▄▄...▄▄ ██
██ ▀ ▄...▄ ▀ ██
```

#### Format 3: Mixed Format (Some Lines Need Wrapping)

Files with multiple lines where **some** individual lines exceed 80 characters:

**Before (mixed line lengths):**

```
Normal line (75 chars)
Very long line exceeding 80 chars that needs wrapping... (160 chars)
Another normal line (60 chars)
```

**After (long lines split at 80):**

```
Normal line (75 chars)
Very long line exceeding 80 chars that needs wrapping... (first 80)
(continuation of long line)
Another normal line (60 chars)
```

**Detection:** The converter checks each line and wraps any line with >100 visible characters.

The converter counts only **visible characters** - ANSI escape codes don't count toward the 80-character width.

## Examples

### Example 1: Simple Conversion

```powershell
# Input: dragon.ans
# Output: dragon.ps1 (in ColorScripts-Enhanced/Scripts)
.\Convert-AnsiToColorScript.ps1 -AnsiFile "dragon.ans"
```

### Example 2: Batch with Comments

```powershell
Get-ChildItem "*.ans" | ForEach-Object {
    .\Convert-AnsiToColorScript.ps1 -AnsiFile $_.FullName -AddComment
}
```

### Example 3: Preview Before Converting

```powershell
# View the ANSI file first (in PowerShell 7+)
Get-Content "art.ans" -Raw | Write-Host

# If it looks good, convert it
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans"
```

## Tips

1. **Preview ANSI files** - Use `Get-Content -Raw | Write-Host` to preview first
2. **UTF-8 Encoding** - Make sure your ANSI files are UTF-8 encoded
3. **File Naming** - The script auto-converts names to PowerShell conventions
4. **Batch Processing** - Use pipeline for converting multiple files
5. **Test Output** - Run the generated .ps1 file to verify it looks correct

## Troubleshooting

### Characters Display as ?? or �

This happens when ANSI files using CP437 (DOS) encoding are incorrectly read as UTF-8. The fix is to re-convert the file:

```powershell
# Re-convert with proper encoding support (included in latest version)
.\Convert-AnsiToColorScript.ps1 -AnsiFile "yourfile.ans" -OutputFile "yourfile.ps1"
```

**Why this happens:**

- Traditional ANSI art uses **Code Page 437 (CP437)** encoding
- CP437 includes special box-drawing characters in bytes 128-255
- These characters must be properly converted to Unicode for PowerShell
- The converter now automatically handles this conversion

### Colors Look Wrong

- Ensure the ANSI file uses standard escape sequences
- Check that your terminal supports 256-color or true color
- Try viewing in Windows Terminal for best results

### Characters Display Incorrectly

- If you see `�` or `??`: Re-convert the file (see above)
- Verify your terminal font supports Unicode box-drawing characters
- Recommended fonts: CascadiaCode Nerd Font, FiraCode Nerd Font, JetBrains Mono Nerd Font

### Empty Output

- Check if the source .ans file contains actual content
- Some ANSI files may have non-printing control characters only

## Where to Find ANSI Art

Popular sources for ANSI art files:

- 16colo.rs - Large collection of ANSI/ASCII art
- textfiles.com - Vintage BBS art archives
- ANSI art communities and forums
- Convert your own images using tools like:
  - img2txt (libcaca)
  - jp2a
  - ascii-image-converter

## After Conversion

Once converted, your scripts will:

1. Be automatically discovered by `Get-ColorScriptList`
2. Work with `Show-ColorScript -Name your-script`
3. Be cached for fast loading with `Build-ColorScriptCache`
4. Support all ColorScripts-Enhanced features

## Example Workflow

```powershell
# 1. Download or create ANSI art
# 2. Convert to PowerShell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "cool-art.ans" -AddComment

# 3. Test it
Show-ColorScript -Name cool-art

# 4. Build cache for performance
Build-ColorScriptCache -Name cool-art

# 5. List all your scripts
Get-ColorScriptList -Name cool-art
```

## Integration with Module

The converted scripts work seamlessly with ColorScripts-Enhanced:

```powershell
# Import the module
Import-Module ColorScripts-Enhanced

# Your converted ANSI art is now available
Show-ColorScript -Name dragon

# Add to your profile for startup
Add-ColorScriptProfile -ScriptName dragon
```
