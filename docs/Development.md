# Development Guide

This document outlines local development practices for the **ColorScripts-Enhanced** PowerShell module.

## Repository Layout

```
ColorScripts-Enhanced/    # Module root (manifest + .psm1 + scripts)
Scripts/                  # <!-- COLOR_SCRIPT_COUNT_PLUS -->245+<!-- /COLOR_SCRIPT_COUNT_PLUS --> colorscript files
Tests/                    # Pester test suite
Build-Help.ps1            # Optional help generator (comment-based help already available)
build.ps1                 # Module build helper
PSScriptAnalyzerSettings.psd1  # Script analyzer ruleset
Test-Module.ps1           # Smoke-test harness used during development
```

## Tooling

- **PowerShell 7.4** (recommended) and **PowerShell 5.1** (supported)
- **Pester 5.4+** for testing
- **PSScriptAnalyzer** for linting (`Lint-Module.ps1` helper script)
- **PowerShell 7 ScriptAnalyzer Helper** (`scripts/Lint-PS7.ps1` runs analyzer with auto-fix exclusively on PS7+)
- **PSResourceGet** or **PowerShellGet** for dependency management
- **Nerd Font** (e.g., Cascadia Code NF) for validating glyph-heavy scripts like `nerd-font-test`

## npm Scripts

We publish a set of convenience commands in `package.json` so you can run common workflows without memorising long PowerShell invocations. Each command accepts the usual `--` syntax for additional arguments.

| Command                                     | Purpose                                                                          |
| ------------------------------------------- | -------------------------------------------------------------------------------- |
| `npm run build`                             | Execute `build.ps1` to regenerate the manifest and refresh documentation counts. |
| `npm run lint`                              | Run ScriptAnalyzer across the module.                                            |
| `npm run lint:strict`                       | Run lint with `-IncludeTests` and `-TreatWarningsAsErrors`.                      |
| `npm run lint:fix`                          | Attempt auto-fixes, then rerun lint.                                             |
| `npm test`                                  | Execute the smoke-test harness (`Test-Module.ps1`).                              |
| `npm run test:pester`                       | Run the full Pester suite from `./Tests`.                                        |
| `npm run docs:update-counts`                | Call `Update-DocumentationCounts.ps1` to sync README markers.                    |
| `npm run scripts:convert -- <ansi-file>`    | Convert ANSI artwork via the Node-based converter.                               |
| `npm run scripts:split -- <file> [options]` | Split tall ANSI or PowerShell scripts into manageable slices.                    |
| `npm run scripts:test-all`                  | Run `Test-AllColorScripts.ps1` across the entire library.                        |
| `npm run verify`                            | Chain strict linting and smoke tests (`lint:strict` + `test`).                   |

## Common Tasks

### Install Dependencies

```powershell
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module Pester -MinimumVersion 5.4.0 -Force
Install-Module PSScriptAnalyzer -Force
```

### Run Tests

```powershell
pwsh -NoProfile -Command "& .\Test-Module.ps1"
Invoke-Pester -Path ./Tests
```

`Test-Module.ps1` now validates exported commands, runs ScriptAnalyzer (warnings treated as failures), and exercises profile helpers.

### Lint Source

```powershell
pwsh -NoProfile -Command "& .\Lint-Module.ps1"
pwsh -NoProfile -Command "& .\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors
pwsh -NoProfile -Command "& .\Lint-Module.ps1" -Fix
pwsh -NoProfile -Command "& .\scripts\Lint-PS7.ps1"  # PowerShell 7 only
```

### Build Manifest

```powershell
# Timestamp version automatically
.\build.ps1

# Semantic version
.\build.ps1 -Version 1.2.0 -Verbose
```

### Generate Help (Optional)

```powershell
.\Build-Help.ps1
```

### Add a New Colorscript

1. Create `ColorScripts-Enhanced/Scripts/<name>.ps1`
2. Use UTF-8 encoding without BOM
3. Test via `Show-ColorScript -Name <name>`
4. Add to `ScriptMetadata.psd1` if needed (category/difficulty)
5. Update docs/tests as appropriate and run lint/tests before committing

> Tip: Reuse `Add-ColorScriptProfile` when scripts need to manipulate PowerShell profiles to avoid duplicating logic.

### Work with External ANSI Art

```powershell
# Convert an ANSI file to a colorscript
node Convert-AnsiToColorScript.js .\art.ans

# Split extremely tall ANSI art into multiple chunks
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --auto --heights=320,320

# Or split a converted colorscript directly
node scripts/Split-AnsiFile.js .\ColorScripts-Enhanced\Scripts\we-acidtrip.ps1 --input=ps1 --breaks=360,720

# Uniform slices every 120 rows
node scripts/Split-AnsiFile.js .\we-ACiDTrip.ANS --every=120
```

`Split-AnsiFile.js` accepts `--breaks` for absolute cut rows, `--heights` for sequential segment sizes, `--every` for evenly spaced slices, `--auto` to detect large blank bands, and `--format=ansi` when you want raw `.ANS` slices instead of `.ps1` wrappers. Use `--input=ps1` when splitting an existing colorscript; `--strip-space-bg` only applies when the input is an ANSI file.

### Verify Nerd Font Rendering

```powershell
Show-ColorScript -Name nerd-font-test
```

Expect to see icons, checkmarks, and box-drawing characters. If they appear as squares, install a Nerd Font and set it as your terminal font (see README or Quick Reference for OS-specific steps).

## Coding Standards

- Follow PowerShell naming conventions (Verb-Noun)
- Export functions explicitly in the manifest and via `Export-ModuleMember`
- Always include comment-based help for public functions
- Prefer `Write-Verbose`/`Write-Warning` over `Write-Host` except when rendering colorscripts
- Respect the caching mechanism (do not bypass unless necessary)
- Keep scripts idempotent and avoid side effects outside terminal output

## Testing Strategy

- Unit tests validate exported commands and manifest integrity
- Smoke tests ensure caching pipeline works end-to-end
- GitHub Actions runs tests on Windows PowerShell 5.1 and PowerShell 7.4 across OSes
- Script analyzer enforces formatting and style guidelines

## Working with the Cache

- Cache location: `$env:APPDATA\ColorScripts-Enhanced\cache`
- Override cache location for testing/CI with `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`
- Use `Build-ColorScriptCache` to warm caches during development
- Use `Clear-ColorScriptCache` to troubleshoot stale outputs

## Branch Policy

- `main` — stable branch, protected by CI
- `dev` — optional integration branch for new features
- Feature branches should include tests and documentation updates

## Commit Guidelines

- Conventional style preferred (`feat:`, `fix:`, `chore:`, `docs:`)
- Include issue references where applicable
- Keep commits focused and reversible

## Helpful Links

- [Publishing Guide](Publishing.md)
- [Release Checklist](ReleaseChecklist.md)
- [Contributing Guidelines](../CONTRIBUTING.md)
- [PowerShell Module Best Practices](https://learn.microsoft.com/powershell/scripting/dev-cross-plat/performance/module-authoring-best-practices)
