# Testing Guide

This guide covers testing procedures for ColorScripts-Enhanced module development.

## Running Tests

### Smoke Tests

Run the smoke test harness which includes ScriptAnalyzer validation:

```powershell
pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"
```

Or using npm:

```powershell
npm test
```

### Full Pester Test Suite

Run the comprehensive Pester test suite:

```powershell
Invoke-Pester -Path ./Tests
```

Or using npm:

```powershell
npm run test:pester
```

### Combined Testing

Run both smoke tests and Pester suite with strict linting:

```powershell
npm run verify
```

## Continuous Integration

The project uses GitHub Actions for automated testing across multiple platforms and PowerShell versions:

- **Windows PowerShell 5.1** - Legacy Windows PowerShell compatibility
- **PowerShell 7.x** - Cross-platform testing on Windows, Linux, and macOS
- **PowerShell 7.5 Preview** - Future compatibility validation
- **Markdown Link Validation** - Ensures documentation links are not broken

See [`.github/workflows/test.yml`](../.github/workflows/test.yml) for the complete CI configuration.

## Test Organization

### Smoke Tests (`scripts/Test-Module.ps1`)

Quick validation that covers:

- Module loading and imports
- Command exports and aliases
- Basic functionality of each command
- Cache operations
- Profile integration
- Help topic availability
- ScriptAnalyzer compliance

**When to use:** Before commits, quick validation during development.

### Pester Tests (`Tests/`)

Comprehensive test suite that validates:

- All module commands with various parameters
- Edge cases and error handling
- Cache behavior and invalidation
- Configuration persistence
- Metadata operations
- Script execution across all colorscripts

**When to use:** Before pull requests, major changes, releases.

## Running Specific Tests

### Test a Single Command

```powershell
Invoke-Pester -Path ./Tests -Tag "Show-ColorScript"
```

### Test Cache Functionality

```powershell
Invoke-Pester -Path ./Tests -Tag "Cache"
```

### Run Tests with Coverage

```powershell
$configuration = New-PesterConfiguration
$configuration.Run.Path = './Tests'
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.Path = './ColorScripts-Enhanced/*.ps*1'
Invoke-Pester -Configuration $configuration
```

## PowerShell Version Testing

### Test on PowerShell 5.1 (Windows)

```powershell
powershell.exe -Command "& .\scripts\Test-Module.ps1"
```

### Test on PowerShell 7+

```powershell
pwsh -Command "& .\scripts\Test-Module.ps1"
```

### Test All Colorscripts

Run every colorscript to ensure they execute without errors:

```powershell
.\ColorScripts-Enhanced\Test-AllColorScripts.ps1
```

Or using npm:

```powershell
npm run scripts:test-all
```

## Linting

See [LINTING.md](LINTING.md) for code quality and linting procedures.

## Test Requirements

- **Pester** 5.4.0 or later
- **PSScriptAnalyzer** for code analysis
- PowerShell 5.1+ or PowerShell 7.0+

Install requirements:

```powershell
Install-Module -Name Pester -MinimumVersion 5.4.0 -Force -SkipPublisherCheck
Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck
```

## Writing New Tests

When adding new functionality:

1. Add smoke tests to `scripts/Test-Module.ps1` for basic validation
2. Add comprehensive Pester tests to `Tests/ColorScripts-Enhanced.Tests.ps1`
3. Use descriptive test names and proper It/Describe blocks
4. Test both success and failure scenarios
5. Clean up test artifacts (temp files, cache entries)

Example Pester test structure:

```powershell
Describe 'New-Command' {
    It 'Should do something successfully' {
        $result = New-Command -Parameter Value
        $result | Should -Not -BeNullOrEmpty
    }

    It 'Should throw when parameter is invalid' {
        { New-Command -Parameter InvalidValue } | Should -Throw
    }
}
```

## See Also

- [Development Guide](Development.md) - Complete development workflow
- [Linting Guide](LINTING.md) - Code quality standards
- [Contributing Guidelines](../CONTRIBUTING.md) - How to contribute
