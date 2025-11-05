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

## Test Execution Order

### Development Workflow

1. **Smoke Tests** (Quick validation)

   ```powershell
   npm test
   ```

2. **Linting** (Code quality)

   ```powershell
   npm run lint
   npm run lint:fix  # Auto-fix issues
   ```

3. **Full Test Suite** (Comprehensive)

   ```powershell
   npm run test:pester
   ```

4. **Complete Verification** (Pre-commit)
   ```powershell
   npm run verify
   ```

## Test File Organization

### Structure

```
Tests/
├── ColorScripts-Enhanced.Tests.ps1                      # Core functionality
├── ColorScripts-Enhanced.Internal.Tests.ps1             # Internal functions
├── ColorScripts-Enhanced.CoverageCompletion.Tests.ps1   # Code coverage
├── ColorScripts-Enhanced.AdditionalCoverage.Tests.ps1   # Extra coverage
├── ColorScripts-Enhanced.TargetedCoverage.Tests.ps1     # Specific features
└── ... (additional test files)
```

### Test Categories by File

| File                                               | Coverage           | Purpose             |
| -------------------------------------------------- | ------------------ | ------------------- |
| ColorScripts-Enhanced.Tests.ps1                    | Main commands      | Basic functionality |
| ColorScripts-Enhanced.Internal.Tests.ps1           | Helper functions   | Internal logic      |
| ColorScripts-Enhanced.CoverageCompletion.Tests.ps1 | Edge cases         | Complete coverage   |
| ColorScripts-Enhanced.AdditionalCoverage.Tests.ps1 | Advanced scenarios | Extra validation    |

## Writing Custom Tests

### Basic Test Structure

```powershell
# File: Tests/MyFeature.Tests.ps1
Describe 'MyFeature' -Tag 'MyTag' {
    BeforeAll {
        # Setup before all tests
        Import-Module .\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1 -Force
        $testScriptName = 'bars'
    }

    Context 'When testing basic functionality' {
        It 'should not throw an error' {
            { Show-ColorScript -Name $testScriptName } | Should -Not -Throw
        }

        It 'should return output' {
            $result = Show-ColorScript -Name $testScriptName -ReturnText
            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When caching is enabled' {
        It 'should create cache file' {
            New-ColorScriptCache -Name $testScriptName -Force
            $cachePath = "$env:APPDATA\ColorScripts-Enhanced\cache\$testScriptName.cache"
            Test-Path $cachePath | Should -Be $true
        }

        It 'should use cache on second call' {
            $firstTime = Measure-Command { Show-ColorScript -Name $testScriptName }
            $secondTime = Measure-Command { Show-ColorScript -Name $testScriptName }
            $firstTime.TotalMilliseconds | Should -BeGreaterThan $secondTime.TotalMilliseconds
        }
    }

    Context 'When errors occur' {
        It 'should handle invalid script names gracefully' {
            { Show-ColorScript -Name 'non-existent-script' -ErrorAction Stop } | Should -Throw
        }
    }

    AfterAll {
        # Cleanup after all tests
        Clear-ColorScriptCache -All -Confirm:$false -ErrorAction SilentlyContinue
    }
}
```

### Common Test Patterns

**Testing Command Existence**

```powershell
It 'should export Show-ColorScript command' {
    Get-Command Show-ColorScript -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
}
```

**Testing Parameter Validation**

```powershell
It 'should accept pipeline input' {
    { 'bars' | Show-ColorScript } | Should -Not -Throw
}
```

**Testing File Operations**

```powershell
It 'should create cache directory if missing' {
    $cachePath = "$env:APPDATA\ColorScripts-Enhanced\cache"
    if (Test-Path $cachePath) { Remove-Item $cachePath -Recurse -Force }

    New-ColorScriptCache -Name 'bars' -Force
    Test-Path $cachePath | Should -Be $true
}
```

**Testing Performance**

```powershell
It 'should improve performance with caching' {
    New-ColorScriptCache -Name 'mandelbrot-zoom' -Force

    $uncached = Measure-Command { Show-ColorScript -Name 'mandelbrot-zoom' -NoCache }
    $cached = Measure-Command { Show-ColorScript -Name 'mandelbrot-zoom' }

    $improvement = $uncached.TotalMilliseconds / $cached.TotalMilliseconds
    $improvement | Should -BeGreaterThan 1  # Cache should be faster
}
```

## Running Specific Tests

### Filter Tests

```powershell
# Run tests by tag
Invoke-Pester -Path ./Tests -Tag 'Cache'

# Run specific describe block
Invoke-Pester -Path ./Tests -Full | Where-Object { $_.Describe -like '*Cache*' }

# Run tests matching pattern
Invoke-Pester -Path ./Tests -TestNameFilter '*caching*'
```

### Test Reporting

```powershell
# Detailed output
Invoke-Pester -Path ./Tests -Output Detailed

# Summary only
Invoke-Pester -Path ./Tests -Output Summary

# JSON output for CI
Invoke-Pester -Path ./Tests -OutputFile ./testResults.junit.xml -OutputFormat JUnitXml
```

## Continuous Integration Testing

### GitHub Actions Matrix

Tests run on:

- **Windows**: PowerShell 5.1, 7.x
- **macOS**: PowerShell 7.x
- **Linux**: PowerShell 7.x

### Local CI Simulation

```powershell
# Replicate CI test matrix locally
# Test on PowerShell 5.1 (Windows only)
powershell -NoProfile -Command "& .\scripts\Test-Module.ps1"

# Test on PowerShell 7
pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"

# Full verification (all checks)
npm run verify
```

### CI Configuration

See `.github/workflows/test.yml` for the complete test matrix and execution order.

## Test Coverage

### Coverage Reports

```powershell
# Generate coverage report
$coverage = Invoke-Pester -Path ./Tests -CodeCoverage ColorScripts-Enhanced/ColorScripts-Enhanced.psm1 -PassThru
$coverage.CodeCoverage | Select-Object -Property Function, NumberOfCommandsAnalyzed, NumberOfCommandsExecuted

# Coverage summary
$coverage.CodeCoverage |
    Group-Object -Property Function |
    ForEach-Object {
        $cov = ($_.Group | Measure-Object -Property CommandCount, CommandExecuted -Sum)
        $percent = if ($cov[0].Sum -gt 0) { [math]::Round($cov[1].Sum / $cov[0].Sum * 100, 2) } else { 0 }
        Write-Host "$($_.Name): $percent%"
    }
```

### Coverage Goals

- **Minimum**: 80% statement coverage
- **Target**: 90% statement coverage
- **Ideal**: 95%+ statement coverage with edge cases

## Troubleshooting Tests

### Test Failures

**Module Import Issues**

```powershell
# Ensure clean import
Remove-Module ColorScripts-Enhanced -Force -ErrorAction SilentlyContinue
Import-Module .\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1 -Force

# Test import directly
.\ColorScripts-Enhanced\ColorScripts-Enhanced.psm1 | Out-Null
```

**Syntax Errors in Tests**

```powershell
# Validate test file syntax
[System.Management.Automation.PSParser]::Tokenize((Get-Content ./Tests/MyTest.Tests.ps1), [ref]$null)
```

**Pester Configuration**

```powershell
# Check Pester version
Get-Module Pester | Select-Object Version

# Upgrade Pester if needed
Update-Module Pester
```

### Performance Test Issues

```powershell
# Ensure cache is properly cleared
Clear-ColorScriptCache -All -Confirm:$false

# Rebuild cache
New-ColorScriptCache -Force

# Retry performance test
Invoke-Pester -Path ./Tests -TestNameFilter '*performance*' -Verbose
```

## Best Practices

### Test Writing

- ✅ **One assertion per test** - Single clear failure point
- ✅ **Descriptive names** - Clearly state what is being tested
- ✅ **Cleanup properly** - Use AfterAll/AfterEach blocks
- ✅ **Test in isolation** - No dependencies between tests
- ✅ **Realistic scenarios** - Test actual usage patterns
- ✅ **Error cases** - Test both success and failure paths

### Test Execution

- ✅ **Run tests frequently** - After every change
- ✅ **Use CI** - Automate testing on multiple platforms
- ✅ **Check coverage** - Aim for high coverage percentage
- ✅ **Document failures** - Record why tests were added

### Test Maintenance

- ✅ **Update tests with features** - Keep tests current
- ✅ **Remove obsolete tests** - Clean up old test files
- ✅ **Refactor test code** - Keep tests maintainable
- ✅ **Monitor performance** - Track test execution time

## Debugging Tests

### Verbose Output

```powershell
$VerbosePreference = 'Continue'
Invoke-Pester -Path ./Tests -Verbose
$VerbosePreference = 'SilentlyContinue'
```

### Step Through Tests

```powershell
# Set breakpoint in test file
Set-PSBreakpoint -Script ./Tests/MyTest.Tests.ps1 -Line 25

# Run Pester
Invoke-Pester -Path ./Tests/MyTest.Tests.ps1

# Breakpoint will pause execution
```

### Inspect Test Variables

```powershell
# In test context, check variables
Describe 'MyTest' {
    It 'should work' {
        $testVar = 'value'
        Write-Host "Test variable: $testVar"  # Visible with -Verbose
        $testVar | Should -Be 'value'
    }
}
```

## Performance Testing

### Benchmark Suite

```powershell
# Create performance baseline
function Test-ColorScriptPerformance {
    param(
        [string[]]$ScriptNames = @('bars', 'hearts', 'mandelbrot-zoom'),
        [switch]$SkipCache
    )

    $results = @()

    foreach ($script in $ScriptNames) {
        if ($SkipCache) {
            $time = Measure-Command { Show-ColorScript -Name $script -NoCache }
        } else {
            New-ColorScriptCache -Name $script -Force | Out-Null
            $time = Measure-Command { Show-ColorScript -Name $script }
        }

        $results += [PSCustomObject]@{
            Script = $script
            TimeMS = [math]::Round($time.TotalMilliseconds, 2)
        }
    }

    return $results
}

# Run benchmark
Test-ColorScriptPerformance | Format-Table
```

## Integration Test Examples

### Real-World Workflows

```powershell
# Test complete user workflow
Describe 'User Workflow' {
    Context 'Initial setup' {
        It 'should install and import module' {
            Import-Module .\ColorScripts-Enhanced -Force
            Get-Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It 'should add to profile' {
            Add-ColorScriptProfile -SkipStartupScript -Force
            $profile | Should -Exist
            Get-Content $profile | Should -Match 'ColorScripts-Enhanced'
        }

        It 'should pre-build cache' {
            New-ColorScriptCache
            (Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" | Measure-Object).Count | Should -BeGreaterThan 0
        }
    }

    Context 'Daily use' {
        It 'should display random colorscript' {
            { Show-ColorScript } | Should -Not -Throw
        }

        It 'should list available scripts' {
            $list = Get-ColorScriptList -AsObject
            $list.Count | Should -BeGreaterThan 0
        }

        It 'should filter by category' {
            $geo = Get-ColorScriptList -Category Geometric -AsObject
            $geo.Count | Should -BeGreaterThan 0
        }
    }
}
```

---

**Last Updated**: October 30, 2025
**Test Framework**: Pester 5.4+
**Coverage Target**: 90%+
Invoke-Pester -Path ./Tests -Tag "Show-ColorScript"

````

### Test Cache Functionality

```powershell
Invoke-Pester -Path ./Tests -Tag "Cache"
````

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
