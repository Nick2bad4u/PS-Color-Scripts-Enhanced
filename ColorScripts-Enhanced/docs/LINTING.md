# Linting Guide

This guide covers code quality standards and linting procedures for ColorScripts-Enhanced module development.

## Running the Linter

### Standard Linting

Lint the module files only:

```powershell
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1"
```

Or using npm:

```powershell
npm run lint
```

### Strict Linting

Include test files and treat warnings as errors:

```powershell
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors
```

Or using npm:

```powershell
npm run lint:strict
```

### Auto-Fix Linting Issues

Apply ScriptAnalyzer auto-fixes where possible:

```powershell
pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -Fix
```

Or using npm:

```powershell
npm run lint:fix
```

## Linting with PowerShell 7

For PowerShell 7 specific linting:

```powershell
.\scripts\Lint-PS7.ps1
```

## PSScriptAnalyzer Settings

The project uses custom ScriptAnalyzer rules defined in [`PSScriptAnalyzerSettings.psd1`](../PSScriptAnalyzerSettings.psd1).

### Key Rules

- **PSAvoidUsingCmdletAliases** - Use full cmdlet names, not aliases
- **PSAvoidUsingWriteHost** - Prefer `Write-Output` or streams
- **PSPlaceOpenBrace** - Opening braces on same line
- **PSPlaceCloseBrace** - Closing braces on new line
- **PSUseConsistentIndentation** - 4 spaces, no tabs
- **PSUseConsistentWhitespace** - Consistent spacing around operators

See the [PSScriptAnalyzerSettings.psd1](../PSScriptAnalyzerSettings.psd1) file for the complete ruleset.

## What Gets Linted

### Module Files

- `ColorScripts-Enhanced.psm1` - Main module file
- `ColorScripts-Enhanced.psd1` - Module manifest
- `Install.ps1` - Installation script

### Script Files (when `-IncludeTests` is used)

- All files in `scripts/` directory
- All files in `Tests/` directory

### Excluded

- Colorscript files in `ColorScripts-Enhanced/Scripts/` (these are data files, not code)

## Common Linting Issues

### Using Aliases

❌ **Wrong:**

```powershell
gci -Path $path | % { Write-Host $_.Name }
```

✅ **Correct:**

```powershell
Get-ChildItem -Path $path | ForEach-Object { Write-Output $_.Name }
```

### Brace Placement

❌ **Wrong:**

```powershell
if ($condition)
{
    # Code
}
```

✅ **Correct:**

```powershell
if ($condition) {
    # Code
}
```

### Indentation

❌ **Wrong:**

```powershell
function Test {
  Write-Output "Bad indentation"
}
```

✅ **Correct:**

```powershell
function Test {
    Write-Output "Proper indentation"
}
```

### Using Write-Host

❌ **Wrong:**

```powershell
Write-Host "Processing $item"
```

✅ **Correct:**

```powershell
Write-Verbose "Processing $item"
# Or for user-facing output:
Write-Output "Processing $item"
```

## Suppressing Rules

In rare cases where a rule must be suppressed:

```powershell
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '')]
param()

Write-Host "This is intentionally user-facing output"
```

**Note:** Suppressions should be rare and well-documented.

## Integration with CI/CD

Linting is automatically run in GitHub Actions:

1. **Test Workflow** - Runs `Invoke-ScriptAnalyzer` on module files
2. **Strict Mode** - Treats warnings as errors in CI
3. **Cross-Platform** - Validates on Windows, Linux, and macOS

See [`.github/workflows/test.yml`](../.github/workflows/test.yml) for CI configuration.

## Pre-Commit Linting

Consider adding linting to your pre-commit workflow:

```powershell
# In .git/hooks/pre-commit
pwsh -NoProfile -File ./scripts/Lint-Module.ps1 -IncludeTests -TreatWarningsAsErrors
if ($LASTEXITCODE -ne 0) {
    Write-Host "Linting failed. Please fix issues before committing."
    exit 1
}
```

## Installing PSScriptAnalyzer

If you don't have PSScriptAnalyzer installed:

```powershell
Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck
```

## Continuous Improvement

The linting rules may evolve as the project grows. When updating rules:

1. Update `PSScriptAnalyzerSettings.psd1`
2. Run `npm run lint:fix` to auto-fix where possible
3. Manually fix remaining issues
4. Update this guide if new patterns emerge

## See Also

- [Testing Guide](TESTING.md) - Testing procedures
- [Development Guide](Development.md) - Complete development workflow
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute
- [PSScriptAnalyzer Documentation](https://github.com/PowerShell/PSScriptAnalyzer) - Official docs
