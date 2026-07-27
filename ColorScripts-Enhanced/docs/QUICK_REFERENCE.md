# ColorScripts-Enhanced Quick Reference

## Install and Import

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced
```

PowerShell 5.1 and PowerShell 7+ are supported. Use an ANSI-capable terminal; a Nerd Font is optional and only needed for scripts that use its glyphs.

## Commands and Aliases

| Command                          | Alias                                         | Purpose                                      |
| -------------------------------- | --------------------------------------------- | -------------------------------------------- |
| `Show-ColorScript`               | `scs`                                         | Render, list, or browse colorscripts         |
| `Get-ColorScriptList`            | -                                             | Query colorscript inventory records          |
| `New-ColorScriptCache`           | `Update-ColorScriptCache`, `Build-ColorScriptCache` | Build policy-selected cache entries |
| `Clear-ColorScriptCache`         | -                                             | Remove selected cache entries                |
| `Add-ColorScriptProfile`         | -                                             | Add a managed import/startup profile block   |
| `Get-ColorScriptConfiguration`   | -                                             | Read effective configuration                 |
| `Set-ColorScriptConfiguration`   | -                                             | Persist cache and startup preferences        |
| `Reset-ColorScriptConfiguration` | -                                             | Restore built-in configuration defaults      |
| `Export-ColorScriptMetadata`     | -                                             | Return metadata objects or write JSON        |
| `New-ColorScript`                | -                                             | Scaffold a UTF-8 colorscript file            |

Every command also accepts `-h` (alias `-help`) for its concise module help.

## Display and Discover

```powershell
# Random script from the full collection, including Pokémon.
Show-ColorScript

# Exact name.
Show-ColorScript -Name hearts

# Random selection with filters. Multiple values match any requested value.
Show-ColorScript -Category Geometric,Nature -Tag Recommended

# Exclude Pokémon and shiny-Pokémon scripts.
Show-ColorScript -ExcludeCategory Pokemon,ShinyPokemon

# Browse sequentially. -NoClear preserves earlier output.
Show-ColorScript -All -WaitForInput -NoClear

# Print the selected script name and full path after rendering.
Show-ColorScript -ShowInfo

# Get rendered text instead of writing it to the host.
$text = Show-ColorScript -Name bars -ReturnText

# Return selection metadata in Named or Random mode.
$result = Show-ColorScript -Name bars -PassThru
```

`-ShowInfo` writes its identification line to PowerShell's information stream.
`-Quiet` suppresses that line, `-ReturnText` remains clean rendered text, and
`-PassThru` continues to return structured metadata.

`Show-ColorScript -List` writes a compact name/category view. Use `Get-ColorScriptList` for reusable inventory objects:

```powershell
Get-ColorScriptList
Get-ColorScriptList -Name 'galaxy*' -AsObject -Quiet
Get-ColorScriptList -Category Patterns -Detailed
Get-ColorScriptList -Tag Recommended -AsObject |
    Select-Object Name, Category, Tags
```

The inventory's current category names are `Abstract`, `Artistic`, `ASCIIArt`, `Custom`, `Default`, `Gaming`, `Geometric`, `Logos`, `Mathematical`, `Nature`, `Patterns`, `Physics`, `Pokemon`, `RGB`, `ShinyPokemon`, `Skull`, `System`, `TerminalThemes`, and `Welcome`.

## Cache Management

Only renderers that require execution-generated output need persistent cache entries. Deterministic bundled output is statically extracted and rendered in-process without executing script code.

```powershell
# Build the small set selected by CachePolicy.psd1.
New-ColorScriptCache

# Explicit names, wildcard names, or metadata filters.
New-ColorScriptCache -Name Galaxy,perlin-clouds
New-ColorScriptCache -Name 'rose-*' -Force -PassThru
New-ColorScriptCache -Category Mathematical

# PowerShell 7+ parallel execution. -Threads is an alias.
New-ColorScriptCache -All -Parallel -ThrottleLimit 4

# Clear by name, category, or tag.
Clear-ColorScriptCache -Name Galaxy
Clear-ColorScriptCache -Category Mathematical
Clear-ColorScriptCache -Tag Recommended

# Clear every entry, or preview the operation.
Clear-ColorScriptCache -All
Clear-ColorScriptCache -All -WhatIf
Clear-ColorScriptCache -All -DryRun -PassThru
```

`-All` selects all applicable records after filters; it does not mean that every static script requires a cache. Pokémon entries follow the same cache policy as every other script.

Use the platform-correct effective cache path instead of constructing an AppData path:

```powershell
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
Get-ChildItem -LiteralPath $cachePath
```

Set `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` before importing the module to override that path for the process. `Clear-ColorScriptCache -Path` targets an alternate directory for one invocation.

## Configuration

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Path
$config.Cache.EffectivePath
$config.Startup.AutoShowOnImport
$config.Startup.ProfileAutoShow
$config.Startup.DefaultScript

Set-ColorScriptConfiguration `
    -CachePath 'D:/Temp/ColorScriptsCache' `
    -AutoShowOnImport:$false `
    -ProfileAutoShow:$true `
    -DefaultScript bars `
    -PassThru

# Empty CachePath or DefaultScript values clear those persisted overrides.
Set-ColorScriptConfiguration -CachePath '' -DefaultScript ''

Reset-ColorScriptConfiguration -PassThru
```

Configuration is user-scoped and platform-appropriate. Set `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` before import when an isolated or portable configuration root is required.

## Profile Integration

```powershell
# Managed import block plus the configured startup script behavior.
Add-ColorScriptProfile

# Import only.
Add-ColorScriptProfile -SkipStartupScript

# Explicit profile file and startup script.
Add-ColorScriptProfile `
    -ProfilePath $PROFILE.CurrentUserCurrentHost `
    -DefaultStartupScript bars `
    -AutoShow

# Skip the optional cache warm-up.
Add-ColorScriptProfile -SkipCacheBuild
```

New managed profile blocks never prompt about Pokémon and never emit `-IncludePokemon`.

`-ProfilePath` has the alias `-Path`. When omitted, the command uses `$PROFILE.CurrentUserAllHosts` when available and otherwise the first defined profile path. `-Force` replaces the module's managed or legacy block while preserving unrelated profile content; it does not deliberately append duplicates.

## Metadata Export

```powershell
# Objects: Name, Category, Categories, Tags, Description.
$metadata = Export-ColorScriptMetadata

# Add ScriptPath, ScriptSizeBytes, and ScriptLastWriteTimeUtc.
Export-ColorScriptMetadata -IncludeFileInfo

# Add CachePath, CacheExists, and CacheLastWriteTimeUtc.
Export-ColorScriptMetadata -IncludeCacheInfo

# Write JSON; -PassThru also returns the in-memory objects.
Export-ColorScriptMetadata `
    -Path ./dist/colorscripts-metadata.json `
    -IncludeFileInfo `
    -IncludeCacheInfo `
    -PassThru
```

## Scaffold a Colorscript

`-Name` and `-OutputPath` are mandatory in the scaffold parameter set. `OutputPath` is a directory; the command creates `<Name>.ps1` within it.

```powershell
$scaffold = New-ColorScript `
    -Name 'my-custom-script' `
    -OutputPath ./ColorScripts-Enhanced/Scripts `
    -GenerateMetadataSnippet `
    -Category Patterns `
    -Tag Custom

$scaffold.Name
$scaffold.Path
$scaffold.MetadataGuidance
$scaffold.Categories
$scaffold.Tags
```

The generated file is UTF-8 without BOM. `-Force` overwrites an existing target, and `-OpenInEditor` opens it through the platform's registered handler after creation.

## Parameter Summary

### `Show-ColorScript`

- Selection: `-Name`, `-Random`, `-List`, or `-All`
- Filters: `-Category`, `-Tag`, `-ExcludeCategory`
- Compatibility: `-IncludePokemon` is a silent, deprecated no-op for one release
- All-mode controls: `-WaitForInput`, `-NoClear`
- Rendering/output: `-NoCache`, `-PassThru`, `-ReturnText` (alias `-AsString`), `-ShowInfo`, `-Quiet`, `-NoAnsiOutput` (alias `-NoColor`), `-ValidateCache`

### `Get-ColorScriptList`

- Filters: `-Name`, `-Category`, `-Tag`
- Output: `-AsObject`, `-Detailed`, `-Quiet`, `-NoAnsiOutput`

The command always emits inventory records. Without `-AsObject`, it also writes a host-facing table unless `-Quiet` is set.

### `New-ColorScriptCache`

- Selection: `-Name`, `-All`, `-Category`, `-Tag`
- Compatibility: `-IncludePokemon` is a silent, deprecated no-op for one release
- Execution: `-Force`, `-Parallel`, `-ThrottleLimit` (alias `-Threads`)
- Output: `-PassThru`, `-Quiet`, `-NoAnsiOutput` (alias `-NoColor`)
- Safety: `-WhatIf`, `-Confirm`

With `-PassThru`, records contain `Name`, `ScriptPath`, `CacheFile`, `Status`, `Message`, `CacheExists`, `ExitCode`, `StdOut`, and `StdErr`.

### `Clear-ColorScriptCache`

- Selection: `-Name`, `-All`, `-Category`, `-Tag`
- Location: `-Path`
- Output/safety: `-DryRun`, `-PassThru`, `-Quiet`, `-NoAnsiOutput`, `-WhatIf`, `-Confirm`

With `-PassThru`, records contain `Name`, `CacheFile`, `Status`, and `Message`.

### `Add-ColorScriptProfile`

- Target/startup: `-ProfilePath`, `-DefaultStartupScript`, `-AutoShow`, `-SkipStartupScript`
- Cache warm-up: `-SkipCacheBuild`
- Compatibility: `-IncludePokemon`, `-SkipPokemonPrompt`, and `-PokemonPromptResponse Y|N` are silent, deprecated no-ops for one release
- Update/safety: `-Force`, `-WhatIf`, `-Confirm`

### Configuration and authoring commands

- `Set-ColorScriptConfiguration`: `-AutoShowOnImport`, `-ProfileAutoShow`, `-CachePath`, `-DefaultScript`, `-PassThru`, `-WhatIf`, `-Confirm`
- `Reset-ColorScriptConfiguration`: `-PassThru`, `-WhatIf`, `-Confirm`
- `Export-ColorScriptMetadata`: `-Path`, `-IncludeFileInfo`, `-IncludeCacheInfo`, `-PassThru`, `-WhatIf`, `-Confirm`
- `New-ColorScript`: `-Name`, `-OutputPath`, `-Force`, `-GenerateMetadataSnippet`, `-Category`, `-Tag`, `-OpenInEditor`, `-WhatIf`, `-Confirm`

## ANSI Conversion Tools

```powershell
# Convert ANSI to a PowerShell colorscript.
node scripts/Convert-AnsiToColorScript.js ./art.ans

# Preview automatic blank-gap splitting.
node scripts/Split-AnsiFile.js ./art.ans --auto --dry-run

# Explicit absolute breakpoints or uniform slices.
node scripts/Split-AnsiFile.js ./art.ans --breaks=360,720
node scripts/Split-AnsiFile.js ./art.ans --every=120
```

See [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md) for encoding, sizing, splitting, and metadata guidance.

## Help and Validation

```powershell
Get-Help Show-ColorScript -Full
Get-Help about_ColorScripts-Enhanced

npm run build:help
npm run markdown:check
npm run verify
npm run test
```

For implementation and contribution workflows, see [DEVELOPMENT.md](DEVELOPMENT.md) and [TESTING.md](TESTING.md).

---

**Last reviewed:** July 21, 2026
