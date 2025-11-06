# Development Guide

This document outlines local development practices for the **ColorScripts-Enhanced** PowerShell module.

## Repository Layout

```
ColorScripts-Enhanced/    # Module root (manifest + .psm1 + scripts)
Scripts/                  # <!-- COLOR_SCRIPT_COUNT_PLUS -->498+<!-- /COLOR_SCRIPT_COUNT_PLUS --> colorscript files
Tests/                    # Pester test suite
Build-Help.ps1            # Optional help generator (comment-based help already available)
build.ps1                 # Module build helper
PSScriptAnalyzerSettings.psd1  # Script analyzer ruleset
Test-Module.ps1           # Smoke-test harness used during development
```

## Local Development Setup

### Prerequisites

- **PowerShell 7.4+** recommended (5.1 supported for testing)
- **Node.js 18+** (for ANSI conversion scripts)
- **Nerd Font** (for testing glyph-heavy scripts)
- **Git** for version control

### Quick Setup

```powershell
# Clone the repository
git clone https://github.com/Nick2bad4u/ps-color-scripts-enhanced.git
cd ps-color-scripts-enhanced

# Install dependencies
npm install

# Run initial tests
npm run build
npm test
```

### Development Workflow

```powershell
# 1. Create feature branch
git checkout -b feature/your-feature

# 2. Make changes and test
npm run lint
npm test

# 3. Update documentation
npm run docs:update-counts

# 4. Commit with conventional commits
git commit -m "feat: add new colorscript"
git push origin feature/your-feature

# 5. Create pull request
```

## Adding New Colorscripts

### Step 1: Create the Script File

```powershell
# File: ColorScripts-Enhanced/Scripts/my-awesome-script.ps1
$esc = [char]27
$reset = "$esc[0m"
$red = "$esc[38;2;238;0;0m"

Write-Host "${red}Your ASCII art here$reset"
```

### Step 2: Update Metadata

Edit `ColorScripts-Enhanced/ScriptMetadata.psd1`:

```powershell
@{
    'my-awesome-script' = @{
        Category = 'Artistic'
        Tags = @('Custom', 'Demo', 'Colorful')
        Description = 'Beautiful artistic composition'
    }
}
```

### Step 3: Test

```powershell
# Direct test
& .\ColorScripts-Enhanced\Scripts\my-awesome-script.ps1

# Via module
Show-ColorScript -Name my-awesome-script

# With caching
New-ColorScriptCache -Name my-awesome-script
Show-ColorScript -Name my-awesome-script
```

## Editing Module Code

### Structure Overview

- **ColorScripts-Enhanced.psd1** - Module manifest (metadata)
- **ColorScripts-Enhanced.psm1** - Main module implementation
- **Install.ps1** - Installation helper
- **Tests/** - Pester test suite
- **scripts/** - Development utilities

### Making Changes

1. **Edit the main module** (`ColorScripts-Enhanced.psm1`)
2. **Add function help** (comment-based help in code)
3. **Update version** in `.psd1` manifest
4. **Run linting**:
   ```powershell
   npm run lint
   npm run lint:fix  # Apply auto-fixes
   ```
5. **Run tests**:
   ```powershell
   npm test
   npm run test:pester
   ```

### Code Style Guidelines

- **Naming**: Use PascalCase for functions, camelCase for variables
- **Indentation**: 4 spaces (no tabs)
- **Comments**: XML comment-based help on all public functions
- **Errors**: Use proper try/catch with specific error messages
- **Type**: Use type annotations where appropriate

Example:

```powershell
<#
.SYNOPSIS
    Brief description

.DESCRIPTION
    Detailed description

.PARAMETER Name
    Parameter description

.EXAMPLE
    Show-ColorScript -Name "bars"

.LINK
    Get-Help about_ColorScripts-Enhanced
#>
function Show-ColorScript {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string]$Name
    )

    process {
        # Implementation here
    }
}
```

## Advanced Development Topics

### Cache System Architecture

The caching system works by:

1. **Execution**: Script runs in isolated PowerShell process
2. **Capture**: Output captured to cache file
3. **Storage**: Cache stored in AppData with timestamp
4. **Validation**: Compares script mtime with cache mtime
5. **Retrieval**: Direct file read on subsequent calls

```powershell
# Study the cache implementation
code ColorScripts-Enhanced/ColorScripts-Enhanced.psm1
# Search for: function New-ColorScriptCache
```

### Performance Optimization

Measure script performance:

```powershell
# Profile a colorscript
Measure-Command { & .\ColorScripts-Enhanced\Scripts\mandelbrot-zoom.ps1 }

# Compare cached vs uncached
$uncached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom -NoCache }
$cached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom }
Write-Host "Improvement: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

### Debugging Tips

```powershell
# Enable verbose output
$VerbosePreference = 'Continue'
Show-ColorScript -Verbose

# Debug cache operations
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" | Format-Table

# Test configuration
Get-ColorScriptConfiguration | ConvertTo-Json

# Trace script execution
Set-PSDebug -Trace 1
& .\ColorScripts-Enhanced\Scripts\my-script.ps1
Set-PSDebug -Trace 0
```

## Testing Strategy

### Test Categories

1. **Smoke Tests** - Quick module validation
2. **Unit Tests** - Individual function testing
3. **Integration Tests** - Multi-component workflows
4. **Performance Tests** - Cache effectiveness
5. **Compatibility Tests** - Cross-platform validation

### Writing Tests

```powershell
# File: Tests/Show-ColorScript.Tests.ps1
Describe 'Show-ColorScript' {
    BeforeAll {
        Import-Module .\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1 -Force
    }

    Context 'Basic Functionality' {
        It 'should display random colorscript' {
            { Show-ColorScript } | Should -Not -Throw
        }

        It 'should display specific colorscript' {
            { Show-ColorScript -Name 'bars' } | Should -Not -Throw
        }
    }

    Context 'Caching' {
        It 'should create cache file' {
            New-ColorScriptCache -Name 'test-script' -Force
            Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\test-script.cache" | Should -Be $true
        }
    }
}
```

### Running Tests

```powershell
# Run all tests
npm run test:pester

# Run specific test file
Invoke-Pester -Path ./Tests/Show-ColorScript.Tests.ps1

# With coverage report
Invoke-Pester -Path ./Tests -CodeCoverage ColorScripts-Enhanced/ColorScripts-Enhanced.psm1
```

## CI/CD Insights

### GitHub Actions Workflow

The project uses automated testing across:

- **Windows PowerShell 5.1** - Legacy compatibility
- **PowerShell 7.x** - Cross-platform
- **PowerShell 7.5 Preview** - Future compatibility

See `.github/workflows/` for implementation details.

### Local CI Simulation

```powershell
# Run the same tests as CI
npm run verify

# Or individually:
npm run lint:strict
npm test
npm run test:pester
```

## Performance Considerations

### Optimization Areas

1. **Cache Building** - Parallelize if building 500+ scripts
2. **Module Loading** - Lazy-load large collections
3. **String Handling** - Use here-strings for large outputs
4. **File I/O** - Buffer cache reads for faster access

### Benchmarking

```powershell
# Create performance baseline
$baseline = @()
Get-ChildItem .\ColorScripts-Enhanced\Scripts -Filter *.ps1 | ForEach-Object {
    $time = Measure-Command { & $_.FullName } | Select-Object -ExpandProperty TotalMilliseconds
    $baseline += @{ Script = $_.BaseName; Time = $time }
}

# Compare after changes
$baseline | Where-Object { $_.Time -gt 100 } | Format-Table  # Scripts taking >100ms
```

## Troubleshooting Development Issues

### Module Won't Load

```powershell
# Check for syntax errors
[System.Management.Automation.PSParser]::Tokenize((Get-Content .\ColorScripts-Enhanced.psm1), [ref]$null)

# Reload module
Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
Import-Module .\ColorScripts-Enhanced -Verbose
```

### Tests Failing

```powershell
# Check test environment
Get-Module ColorScripts-Enhanced
Get-ExecutionPolicy
$PSVersionTable

# Run single test in verbose mode
Invoke-Pester -Path ./Tests/Show-ColorScript.Tests.ps1 -Verbose
```

### Cache Issues

```powershell
# Clear all cache
Clear-ColorScriptCache -All -Confirm:$false

# Rebuild
New-ColorScriptCache -Force

# Verify
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" | Measure-Object
```

## Contributing Checklist

Before submitting a pull request:

- [ ] All tests pass: `npm run verify`
- [ ] Linting clean: `npm run lint`
- [ ] Help documentation updated
- [ ] Version bumped if necessary
- [ ] CHANGELOG.md updated
- [ ] Documentation counts refreshed: `npm run docs:update-counts`
- [ ] Commit messages follow conventional commits
- [ ] Changes tested locally on multiple platforms

## Resources

- [PowerShell Docs](https://docs.microsoft.com/powershell/)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
- [Pester Testing](https://pester.dev/)
- [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)

## Repository Layout

```
ColorScripts-Enhanced/
├── ColorScripts-Enhanced.psd1     # Module manifest
├── ColorScripts-Enhanced.psm1     # Main implementation
├── Install.ps1                    # Installation helper
├── README.md                      # Main documentation
├── ScriptMetadata.psd1           # Metadata for all colorscripts
├── Scripts/                       # <!-- COLOR_SCRIPT_COUNT_PLUS -->498+<!-- /COLOR_SCRIPT_COUNT_PLUS --> colorscript files
├── Tests/                         # Pester test suite
├── docs/                          # Extended documentation
├── scripts/                       # Development utilities
└── .github/                       # GitHub Actions workflows
```

---

**Last Updated**: October 30, 2025
| `npm run lint:strict` | Run lint with `-IncludeTests` and `-TreatWarningsAsErrors`. |
| `npm run lint:fix` | Attempt auto-fixes, then rerun lint. |
| `npm test` | Execute the smoke-test harness (`Test-Module.ps1`). |
| `npm run test:pester` | Run the full Pester suite from `./Tests`. |
| `npm run docs:update-counts` | Call `Update-DocumentationCounts.ps1` to sync README markers. |
| `npm run package:metadata -- --PackagePath <nupkg>` | Run `Update-NuGetPackageMetadata.ps1` to embed README/license/icon before pushing. |
| `npm run scripts:convert -- <ansi-file>` | Convert ANSI artwork via the Node-based converter. |
| `npm run scripts:convert:ps -- <ansi-file>` | Convert ANSI artwork using the PowerShell helper script. |
| `npm run scripts:convert:advanced` | Launch the advanced ANSI conversion workflow in PowerShell. |
| `npm run scripts:split -- <file> [options]` | Split tall ANSI or PowerShell scripts into manageable slices. |
| `npm run scripts:test-all` | Run `Test-AllColorScripts.ps1` across the entire library. |
| `npm run scripts:format` | Run Invoke-Formatter across every colorscript in `ColorScripts-Enhanced/Scripts`. |
| `npm run release:notes` | Generate unreleased release notes using git-cliff (PowerShell Gallery snippet). |
| `npm run release:notes:latest` | Generate release notes for the most recent tag. |
| `npm run release:verify` | Ensure CHANGELOG.md aligns with the manifest version and git-cliff output. |
| `npm run markdown:check` | Run markdown-link-check across every `.md` file in the repo. |
| `npm run verify` | Run strict lint, link checks, smoke tests, and the full Pester suite. |

> `npm run release:*` commands require the [git-cliff](https://github.com/orhun/git-cliff) CLI in your `PATH`.

## Common Tasks

### Install Dependencies

```powershell
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module Pester -MinimumVersion 5.4.0 -Force
Install-Module PSScriptAnalyzer -Force
```

### Run Tests

```powershell
pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"
Invoke-Pester -Path ./Tests
```

`Test-Module.ps1` now validates exported commands, runs ScriptAnalyzer (warnings treated as failures), and exercises profile helpers.

### Lint Source

```powershell
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1"
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -Fix
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
node scripts/Convert-AnsiToColorScript.js .\art.ans

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
- Use `New-ColorScriptCache` to warm caches during development
- Use `Clear-ColorScriptCache` to troubleshoot stale outputs
- Force validation when diagnosing cache issues with `Show-ColorScript -ValidateCache` or by setting `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE=1`
- Force ANSI informational summaries in hosts that strip escape sequences by setting `COLOR_SCRIPTS_ENHANCED_FORCE_ANSI=1`; commands still honour `-NoAnsiOutput` when you need plain text

## Localization Controls

- Auto mode prefers PSD1 resources when available; adjust behavior with `COLOR_SCRIPTS_ENHANCED_LOCALIZATION_MODE` (`auto`, `full`, `embedded`)
- Legacy toggle `COLOR_SCRIPTS_ENHANCED_PREFER_EMBEDDED_MESSAGES` remains supported for compatibility, but prefer the consolidated mode variable going forward

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
- [PowerShell Module Best Practices](https://learn.microsoft.com/en-us/powershell/gallery/concepts/publishing-guidelines?view=powershellget-3.x)
