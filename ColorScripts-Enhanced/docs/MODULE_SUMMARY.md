# ColorScripts-Enhanced Module Summary

ColorScripts-Enhanced is a cross-platform PowerShell module for discovering, displaying, creating, and managing ANSI colorscripts. The checked-in module targets Windows PowerShell 5.1 and PowerShell 7.x on Windows, macOS, and Linux.

## Current Checkout

| Property | Value |
| -------- | ----- |
| Manifest version | `2026.7.20.35` |
| Colorscript files | <!-- COLOR_SCRIPT_COUNT -->3156<!-- /COLOR_SCRIPT_COUNT --> |
| Dynamic renderers | 17 entries in `DynamicRenderPolicy.psd1` |
| Cacheable renderers | <!-- COLOR_CACHE_TOTAL -->15<!-- /COLOR_CACHE_TOTAL --> entries in `CachePolicy.psd1` |
| Exported functions | 10 |
| Primary alias | `scs` -> `Show-ColorScript` |
| Minimum PowerShell | 5.1 |

The manifest and policy data files are the authoritative sources for version and policy counts. Run `npm run docs:update-counts` after changing the script inventory or cache policy.

## Public Commands

| Command | Purpose |
| ------- | ------- |
| `Show-ColorScript` | Display a random or named colorscript, list names, and optionally bypass or validate cache state. |
| `Get-ColorScriptList` | Query scripts by name, category, or tag. |
| `New-ColorScriptCache` | Build output caches only for renderers selected by `CachePolicy.psd1`. |
| `Clear-ColorScriptCache` | Remove named cache entries or all module cache data. |
| `Add-ColorScriptProfile` | Add an idempotent module startup block to a selected PowerShell profile. |
| `Get-ColorScriptConfiguration` | Read the effective persistent configuration. |
| `Set-ColorScriptConfiguration` | Persist supported configuration values. |
| `Reset-ColorScriptConfiguration` | Restore the default persistent configuration. |
| `Export-ColorScriptMetadata` | Export catalog metadata, optionally including file or cache information. |
| `New-ColorScript` | Create a UTF-8 colorscript scaffold and optional metadata guidance. |

Every exported command accepts `-h` (alias `-help`) for concise command help. Use `Get-Help <command> -Full` for the complete localized help topic.

## Quick Start

```powershell
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser
Import-Module ColorScripts-Enhanced

# Display a random script.
Show-ColorScript

# Display a named script.
Show-ColorScript -Name bars

# Browse the catalog.
Get-ColorScriptList -Category Patterns

# Opt in to Pokemon-themed scripts during random selection.
Show-ColorScript -IncludePokemon
```

Pokémon-themed scripts are excluded from random selection by default. A directly requested Pokémon script name still works without `-IncludePokemon`.

## Selective Cache Model

Most of the catalog is static output and executes directly. Caching every static file would add invalidation, storage, and synchronization cost without a meaningful benefit.

The module therefore uses explicit policies:

- `DynamicRenderPolicy.psd1` identifies scripts whose output intentionally varies.
- `CachePolicy.psd1` selects the expensive renderers whose output is suitable for reuse.
- deterministic generated renderers should be flattened with `scripts/Convert-DeterministicColorScripts.ps1` instead of added to the runtime cache.
- live or intentionally variable renderers remain uncached when reuse would defeat their purpose.

Common cache operations:

```powershell
# Build every policy-selected cache entry.
New-ColorScriptCache -All

# Build one eligible entry.
New-ColorScriptCache -Name Galaxy

# A static script reports that caching is not required.
New-ColorScriptCache -Name bars -PassThru

# Remove all cache data.
Clear-ColorScriptCache -All
```

Cache locations are platform-specific. Query the effective path instead of assuming `%APPDATA%`:

```powershell
Get-ColorScriptConfiguration | Select-Object CachePath
```

## Configuration

```powershell
# Inspect effective settings.
Get-ColorScriptConfiguration

# Persist selected defaults.
Set-ColorScriptConfiguration `
    -CachePath 'D:\ColorScriptsCache' `
    -ProfileAutoShow:$false `
    -DefaultScript bars

# Restore defaults.
Reset-ColorScriptConfiguration
```

Configuration is stored under the platform-appropriate user data directory. Set `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` before importing the module to relocate configuration for portable or isolated scenarios.

Advanced compatibility controls include:

- `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE=1` to request cache validation.
- `COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE` with `auto`, `full`, or `embedded`.
- `COLOR_SCRIPTS_ENHANCED_PREFER_EMBEDDED_MESSAGES` for legacy compatibility; the consolidated localization mode supersedes it.

## Metadata and Script Creation

```powershell
# Export catalog metadata to JSON.
Export-ColorScriptMetadata `
    -Path ./dist/colorscripts-metadata.json `
    -IncludeFileInfo `
    -IncludeCacheInfo

# Create a script and metadata guidance.
$script = New-ColorScript `
    -Name my-awesome-script `
    -Category Artistic `
    -Tag Custom,Demo `
    -GenerateMetadataSnippet

$script.Path
$script.MetadataGuidance
```

Generated `.ps1` files use UTF-8 with a BOM for Windows PowerShell 5.1 compatibility. Traditional source `.ANS` files are commonly CP437, so source decoding and generated-file encoding must be handled separately. See [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md).

## Repository Layout

```text
ColorScripts-Enhanced/
|-- ColorScripts-Enhanced.psd1       # Manifest and public exports
|-- ColorScripts-Enhanced.psm1       # Module loader
|-- CachePolicy.psd1                 # Output-cache allowlist
|-- DynamicRenderPolicy.psd1         # Intentionally variable renderers
|-- ScriptMetadata.psd1              # Catalog metadata
|-- Public/                          # Exported command implementations
|-- Private/                         # Internal helpers
|-- Scripts/                         # Colorscript files
|-- en-US/, de/, es/, fr/, it/, ...  # Localized help and messages
`-- docs/                             # Packaged documentation
```

Generated MAML help is committed alongside its Markdown source. Update both with:

```powershell
pwsh -NoProfile -File ./scripts/Build-Help.ps1 -UpdateMarkdown
```

The help build requires `Microsoft.PowerShell.PlatyPS`; missing tooling or metadata synchronization failures are terminating errors.

## Validation

Use the repository gates rather than relying on old benchmark or test-count claims:

```powershell
npm run verify
npm run test:pester
npm run lint:strict
npm run docs:validate-links
```

The CI strategy covers Windows PowerShell 5.1, the runner-provided current PowerShell 7.x on Windows/macOS/Linux, and the current PowerShell preview on Linux. See [POWERSHELL-VERSIONS.md](POWERSHELL-VERSIONS.md).

## Licensing and Provenance

Project-authored code is provided under the repository [Unlicense](../../LICENSE). Incorporated ANSI art may have different authors and source terms; availability in an archive does not make a work public domain. Preserve source, author/pack attribution, and license or permission records for new imports.

For usage details, start with the [README](../../README.md), [Quick Reference](QUICK_REFERENCE.md), and the command's `Get-Help` topic.
