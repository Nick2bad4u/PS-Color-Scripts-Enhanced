# ANSI to ColorScript Conversion Guide

> Looking for turnkey demos? See `docs/examples/ansi-conversion/` for scripts that wrap the commands below.

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

### Preserve an Already-Formatted ANSI Stream

Use passthrough only when the decoded source already contains its final sequential SGR and line-ending stream and does not rely on cursor movement or terminal emulation:

```powershell
.\Convert-AnsiToColorScript-Advanced.ps1 -AnsiFile "plant.ansi" -Encoding utf8 -Passthrough
```

Passthrough preserves the decoded source byte-for-byte inside one safe PowerShell literal and emits it with `Write-Host -NoNewline`. This retains exact color transitions, CRLF geometry, and trailing line endings. Artwork containing cursor positioning, erase commands, overstrikes, or terminal-width wrapping must use terminal emulation instead.

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

## Before (single-line with positioning)

```text
ESC[1;1HRed TextESC[2;1HGreen TextESC[3;1HBlue Text
```

## After (multi-line with newlines)

```text
Red Text
Green Text
Blue Text
```

## Supported cursor commands

- `ESC[row;colH` or `ESC[row;colf` - Move cursor to position
- `ESC[nB` - Move cursor down n lines
- `ESC[nC` - Move cursor forward n columns

### Format 2: 80-Column Wrapped

Files where all content is on one long line meant to wrap every 80 visible characters:

## Before (single long line)

```text
████████...████ ▄▄ ▄▄▄...▄▄ ██ ██ ▀ ▄...▄ ▀ ██...
```

## After (split at 80 columns)

```text
████████...████
██ ▄▄ ▄▄▄...▄▄ ██
██ ▀ ▄...▄ ▀ ██
```

### Format 3: Mixed Format (Some Lines Need Wrapping)

Files with multiple lines where **some** individual lines exceed 80 characters:

## Before (mixed line lengths)

```text
Normal line (75 chars)
Very long line exceeding 80 chars that needs wrapping... (160 chars)
Another normal line (60 chars)
```

## After (long lines split at 80)

```text
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
# Traditional .ANS files normally use CP437, not the platform's default text encoding.
$bytes = [System.IO.File]::ReadAllBytes((Resolve-Path "art.ans"))
$cp437 = [System.Text.Encoding]::GetEncoding(437)
$cp437.GetString($bytes) | Write-Host

# If it looks good, convert it
.\Convert-AnsiToColorScript.ps1 -AnsiFile "art.ans"
```

## Tips

1. **Choose the source encoding deliberately** - Traditional DOS/BBS `.ANS` art normally uses CP437. Use UTF-8 only when the source is known to be Unicode.
2. **Use the advanced converter when needed** - `Convert-AnsiToColorScript-Advanced.ps1` defaults to `-Encoding cp437` and accepts `-Encoding utf8` for known UTF-8 input.
3. **Inspect generated code** - Review a generated `.ps1` before executing art obtained from an untrusted source.
4. **File Naming** - The converter normalizes names to lowercase PowerShell script names.
5. **Generated Encoding** - Generated `.ps1` files use UTF-8 with a BOM so non-ASCII art is decoded correctly by Windows PowerShell 5.1. This is separate from the encoding of the source `.ANS` file.

## Troubleshooting

### Characters Display as ?? or �

This happens when ANSI files using CP437 (DOS) encoding are incorrectly read as UTF-8. The fix is to re-convert the file:

```powershell
# Re-convert with proper encoding support (included in latest version)
.\Convert-AnsiToColorScript.ps1 -AnsiFile "yourfile.ans" -OutputFile "yourfile.ps1"
```

## Why this happens

- Traditional ANSI art uses **Code Page 437 (CP437)** encoding
- CP437 includes special box-drawing characters in bytes 128-255
- These characters must be properly converted to Unicode for PowerShell
- The standard converter always decodes source bytes as CP437
- The advanced converter lets you select `cp437` or `utf8` explicitly

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

- [16colo.rs](https://16colo.rs/) - Large historical ANSI/ASCII art archive
- [textfiles.com](http://artscene.textfiles.com/artpacks/) - Vintage BBS art packs
- [botany](https://github.com/jifunks/botany) - ISC-licensed terminal plant scenes
- [os-ansi](https://codeberg.org/NNB/os-ansi) - ISC-licensed operating-system ANSI art
- [Roy/SAC ANSI gallery](https://www.roysac.com/roy_ansishow.html) - Roy-authored ANSI art with separate public-domain evidence
- ANSI art communities and forums
- Convert your own images using tools like:
  - img2txt (libcaca)
  - jp2a
  - ascii-image-converter

Archive availability does not imply that every work is public domain or compatible with this project's license. Record the source URL, artist/pack attribution, and applicable license or permission for every imported file.

### Reviewed Collections

The collection now contains curated subsets from these sources. See [Artwork Sources and Provenance](ARTWORK_SOURCES.md) for browse/download links, inclusion counts, exact licensing evidence, and the excluded Roy/SAC other-artists gallery.

| Collection | Approximate size | Repository license | Integration note |
| ---------- | ---------------- | ------------------ | ---------------- |
| [jifunks/botany](https://github.com/jifunks/botany) | 72 files reviewed | ISC | 17 sequential ANSI streams imported with byte-preserving passthrough conversion. |
| [NNB/os-ansi](https://codeberg.org/NNB/os-ansi) | 36 files reviewed | ISC | 8 files imported; much of the art credits jschx/ufetch. |
| [Roy/SAC ANSI gallery](https://www.roysac.com/roy_ansishow.html) | 183 files reviewed | Roy-authored works placed in the public domain | 5 Roy-authored works imported; other artists' gallery is excluded. |
| [HyFetch](https://github.com/hykilpikonna/hyfetch) | Many distro logos | MIT | Uses application-specific templates/placeholders, so it needs a purpose-built importer rather than raw `.ANS` conversion. |

## After Conversion

Once converted, your scripts will:

1. Be automatically discovered by `Get-ColorScriptList`
2. Work with `Show-ColorScript -Name your-script`
3. Follow the deterministic bundled static-extraction path without executing script code
4. Support discovery, metadata, filtering, and display through ColorScripts-Enhanced

Only expensive renderers explicitly listed in `CachePolicy.psd1` use output caching. Do not add a static converted artwork to that policy merely because it is frequently displayed.

## Example Workflow

```powershell
# 1. Download or create ANSI art
# 2. Convert to PowerShell
.\Convert-AnsiToColorScript.ps1 -AnsiFile "cool-art.ans" -AddComment

# 3. Test it
Show-ColorScript -Name cool-art

# 4. List your script
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
Add-ColorScriptProfile -DefaultStartupScript dragon
```

## Advanced Utilities

### Split Super-Tall ANSI Art

For ANSI files that are too tall to display comfortably, use `Split-AnsiFile.js`:

```powershell
# Preview suggested splits without writing files (looks for 4+ blank rows)
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --auto --dry-run

# Generate three 300-line chunks as PowerShell scripts
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --heights=300,300,300

# Emit ANSI slices instead of .ps1 wrappers
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --format=ansi --breaks=420,840

# Split an already converted colorscript
node scripts/Split-AnsiFile.js .\ColorScripts-Enhanced\Scripts\we-acidtrip.ps1 --input=ps1 --heights=320,320

# Split every 160 lines automatically
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --every=160
```

## Options

- `--auto` - Adds breaks where large blank gaps exist
- `--heights` / `--breaks` - Enforce manual cut points
- `--every=<n>` - Evenly divides the render
- `--strip-space-bg` - (ANSI input only) Clears background colors on plain spaces
- `--dry-run` - Preview without writing files

Each output chunk is normalized with a trailing `ESC[0m` so the terminal resets cleanly after display.

### Other Developer Utilities

The repository includes additional helpers for developers:

- **`npm run release:notes`** - Invokes git-cliff directly to build PowerShell Gallery release notes
- **`Validate-Changelog.ps1`** - Checks CHANGELOG.md matches manifest version
- **`Invoke-MarkdownLinkCheck.ps1`** - Validates all markdown links

See the [npm Scripts Reference](NPM_SCRIPTS.md) for complete details on development utilities.
