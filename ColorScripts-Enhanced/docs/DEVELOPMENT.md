# Development Guide

This guide describes the current repository workflow. `package.json`, the module manifest, policy data files, tests, and GitHub Actions workflows are the executable sources of truth.

## Repository Layout

```text
ColorScripts-Enhanced/
├── ColorScripts-Enhanced.psd1       # Manifest and exported surface
├── ColorScripts-Enhanced.psm1       # Module bootstrap
├── Public/                          # 10 exported functions
├── Private/                         # Internal helpers
├── Scripts/                         # Bundled colorscripts
├── ScriptMetadata.psd1              # Inventory metadata
├── CachePolicy.psd1                 # Expensive dynamic renderers eligible for cache
├── DynamicRenderPolicy.psd1         # Intentionally variable renderers
├── ThirdPartyNotices/               # Preserved licensing/permission evidence
└── <culture>/                       # Messages, Markdown help, MAML, HelpInfo, about topic
audit/                               # Repository-only curation evidence
├── ArtworkProvenance.psd1           # Per-script provenance for curated imports
└── Ansi*.json                       # Checkpoints, review ledgers, and manifests
Tests/                               # Pester and Node tests
scripts/                             # Build, lint, conversion, help, and release utilities
assets/ansi-files/                   # Source ANSI assets retained for conversion/provenance
docs/                                # Repository documentation
```

## Prerequisites

- PowerShell 7 for normal development; Windows PowerShell 5.1 remains a supported runtime and CI target.
- The Node.js version in `.node-version` (currently 26.5.1).
- npm dependencies installed from `package-lock.json`.
- Pester 6.0.1 and PSScriptAnalyzer 1.25.0 for local PowerShell validation.
- Microsoft.PowerShell.PlatyPS 1.0.3 when regenerating help.

These are repository development tools, not module runtime dependencies. Check the current PowerShell Gallery releases with `Find-PSResource -Name Pester, PSScriptAnalyzer, Microsoft.PowerShell.PlatyPS -Repository PSGallery`, then update the exact version pins in the workflows and build/test configuration together. The module manifest intentionally has no `RequiredModules` or `ExternalModuleDependencies` entries.

Install dependencies and run the primary gates:

```powershell
npm ci
npm run verify
npm test
```

Use `npm ci --force` only where the checked-in workflow requires it; do not casually regenerate the lockfile.

## Branches and Scope

Create focused branches using `type/description`, for example:

```powershell
git switch -c docs/help-contracts
```

Preserve unrelated work in a dirty tree. Generated files belong in the same logical change as their editable source when the repository checks them in.

## Module Changes

Public functions live under `ColorScripts-Enhanced/Public/`; internal helpers live under `Private/`. The module bootstrap dot-sources them and the manifest explicitly declares exported functions and aliases.

When changing a public command:

1. Design parameter sets, positional behavior, aliases, pipeline binding, `SupportsShouldProcess`, and output records deliberately.
2. Keep Windows PowerShell 5.1 syntax compatibility unless the code is explicitly gated to PowerShell 7.
3. Add focused Pester coverage for success, no-op, error, pipeline, `-WhatIf`, and cross-platform paths as applicable.
4. Update the English and translated Markdown help contracts.
5. Run `npm run build:help` and review all generated MAML/HelpInfo changes.
6. Verify the manifest and exported aliases remain synchronized.

External help is authoritative for public commands. Public function source should use `.EXTERNALHELP ColorScripts-Enhanced-help.xml`; do not maintain a second divergent comment-help narrative.

## Colorscript Execution Model

The collection has three routes:

1. deterministic bundled scripts are statically extracted without executing their PowerShell;
2. names in `DynamicRenderPolicy.psd1` are allowed to execute because their output genuinely varies; and
3. only expensive dynamic names in `CachePolicy.psd1` persist output caches.

Do not add deterministic art to either policy merely because its AST is complicated. Use the repository conversion/audit utilities and update `Tests/Fixtures/FlattenedColorScriptBaselines.psd1` when a verified deterministic conversion requires it.

Query the real cache directory:

```powershell
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
```

For isolated development, set `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` before import. Use `Show-ColorScript -ValidateCache` or `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE=1` only when on-demand validation is needed.

## Adding ANSI Artwork

Read [ANSI-CONVERSION-GUIDE.md](ANSI-CONVERSION-GUIDE.md) and [ARTWORK\_SOURCES.md](ARTWORK_SOURCES.md) before importing third-party art.

A new import must have:

- a canonical source and pinned revision/archive hash;
- source-file hash, encoding, artist/pack attribution, and license or permission;
- preserved evidence under `ColorScripts-Enhanced/ThirdPartyNotices/`;
- a provenance mapping in `audit/ArtworkProvenance.psd1`;
- duplicate, dimension, encoding, deterministic-conversion, metadata, and rendering validation.

Typical commands:

```powershell
node scripts/Convert-AnsiToColorScript.js --provenance-record=./temp/art-provenance.json ./art.ans ./ColorScripts-Enhanced/Scripts/16c-example-art.ps1
node scripts/Split-AnsiFile.js ./art.ans --auto --dry-run
node scripts/Split-AnsiFile.js ./art.ans --breaks=40,80 --output-base=16c-example-art --provenance-record=./temp/art-provenance.json
npm run ansi:audit -- --source=16colors --pack=mist0624
npm run ansi:audit:offline -- --cache-dir=./temp/ansi-archive-audit
npm run ansi:audit:offline -- --year=2016 --decisions=./temp/ansi-archive-audit/decisions.json --exclude-existing-manifest=./temp/ansi-archive-audit/import-manifest.json
npm run ansi:checkpoint:check
npm run ansi:checkpoint:update
npm run artwork:provenance:headers:check
npm run artwork:provenance:web:update
npm run artwork:provenance:web:check
npm run ansi:verify-conversion -- --source=./art.ans --prefix=16c-example
node ./scripts/Analyze-ColorScripts.mjs --type=tiny-tail-part --type=dense-split-boundary --type=continuous-split-review
npm run ansi:gallery-analysis:check
npm run scripts:check-dupes
npm run test:conversion
```

Archival conversion uses a JSON object whose keys are canonical
`ArtworkProvenance.psd1` property names. At minimum, supply `Collection`,
`SourceFile`, `SourceUrl`, `SourceRevision`, `Artist` or `Attribution`, and
`SourceModification`. The converter independently derives and validates the
source hash, filename, format, encoding, conversion mode, SAUCE/iCE fields, and
source coordinates. The splitter writes one complete external record per
part or panel. Both tools update the PSD1 and generated scripts as one
rollback-safe transaction. Do not combine `--provenance-record` with the
legacy `--source-*` comment options.

```json
{
  "Collection": "16colors-permitted",
  "SourceFile": "mist0624/ZII-LAHO.ANS",
  "SourceUrl": "https://16colo.rs/pack/mist0624/raw/ZII-LAHO.ANS",
  "SourceRevision": "archive-sha256:7e2642f67629daefe8d04ebedd2e233be2e8a74b2dea50eb02da49be24298927",
  "Artist": "Zeus II",
  "Group": "Mistigris",
  "Pack": "mist0624",
  "Attribution": "ZII-LAHO.ANS by Zeus II (Mistigris); released in mist0624 and preserved by 16colors.",
  "SourceModification": "Decoded as CP437 and serialized without reflow, scaling, narrowing, or background-space stripping."
}
```

Use `--exclude-existing-manifest=<path>` when reproducibly rebuilding a year
whose scripts are already in the gallery. It removes only the named manifest's
scripts from the existing-gallery source and rendered-cell indexes, allowing
the audit to reconsider that same import without treating it as its own
duplicate. The option is repeatable and fails closed for empty, repeated,
malformed, stale, or hash-mismatched manifests; it does not suppress unrelated
gallery duplicates.

When archive metadata has an incomplete artist or group credit, keep the
verified file-scoped attribution in the resumable decision record rather than
editing a generated report:

```json
{
 "decisions": {
  "16colors:pack/ART.ANS": {
   "disposition": "accepted",
   "note": "Attribution verified against the pack documentation.",
   "artists": ["Verified Artist", "Joint Artist"],
   "groups": ["Verified Group"]
  }
 }
}
```

`artists` and `groups` are optional non-empty string arrays. The audit trims
names and rejects blank or case-insensitive duplicate entries so a malformed
override cannot silently replace archive attribution.

Traditional DOS/BBS art is commonly CP437. Do not assume UTF-8 and do not infer redistribution rights from archive availability. Archival imports must keep background-colored spaces and source margins; use `--strip-space-bg` only for a source whose review explicitly proves those cells are disposable.

Treat SAUCE dimensions as declared provenance, not as permission to synthesize
unused cells. In particular, `tInfo2` may exceed the ANSI stream's rendered row
extent. Preserve blank rows produced by source data or cursor movement, but
compare the stream render with the official preview before treating a shorter
render as data loss.

## Creating a Project-Authored Script

```powershell
$scaffold = New-ColorScript `
    -Name my-awesome-script `
    -OutputPath ./ColorScripts-Enhanced/Scripts `
    -GenerateMetadataSnippet `
    -Category Custom `
    -Tag Custom
```

Replace the placeholder art, add deliberate metadata to `ScriptMetadata.psd1`, and test direct and module rendering. The scaffold is UTF-8 without BOM. A BOM is still appropriate for a hand-authored Windows PowerShell 5.1 script only when its source contains non-ASCII text that 5.1 must decode reliably.

## Help and Localization

Editable sources are the culture Markdown topics and `Messages.psd1` files. Generated outputs are the culture MAML and HelpInfo XML files.

```powershell
npm run build:help
npm run markdown:check
```

All runtime resource files must have exact key parity with `en-US/Messages.psd1` and compatible composite-format placeholders. Keep syntax, command/parameter names, literal accepted values, output property names, and environment-variable names unlocalized.

See [LOCALIZATION\_GUIDE.md](LOCALIZATION_GUIDE.md) for fallback modes and translation review requirements.

## Validation Commands

```powershell
# Fast non-mutating checks
npm run verify

# Strict PowerShell analysis, including tests
npm run verify:strict

# Node conversion, custom harness, and Pester
npm test

# Help and documentation
npm run build:help
npm run docs:update-counts
npm run markdown:check

# Release alignment
npm run release:verify
```

See [NPM\_SCRIPTS.md](NPM_SCRIPTS.md) for the complete command inventory. `npm run build` is an aggregate command that updates generated outputs; review its diff.

## Coding Standards

- Use approved PowerShell verbs and singular nouns unless an intentional analyzer suppression explains the public contract.
- Prefer `-LiteralPath` for already-resolved paths.
- Use terminating errors with stable error IDs for command failures.
- Use `Write-Verbose`, `Write-Warning`, and the module's information helpers appropriately; reserve direct host rendering for visual output.
- Respect `ShouldProcess` for persistent changes and test `-WhatIf`.
- Return stable structured records for automation.
- Use UTF-8 intentionally and preserve cross-edition behavior.
- Keep scripts deterministic, idempotent, and scoped to their documented targets.
- Do not weaken lint or tests to make a change pass.

## Pull Request Checklist

- [ ] Scope is focused and unrelated work is preserved.
- [ ] Behavior and edge cases have tests.
- [ ] Public help, localized structure, and output properties match the implementation.
- [ ] Generated help/counts are current.
- [ ] Provenance/notices are complete for imported art.
- [ ] `npm run verify:strict`, relevant tests, and `git diff --check` pass.
- [ ] Version/changelog changes are included only when the release workflow requires them.

---

_Last reviewed: July 21, 2026_
