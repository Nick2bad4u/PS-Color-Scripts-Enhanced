# Codecov JUnit XML Test Results Integration

## Overview

ColorScripts-Enhanced now generates **Codecov-compatible JUnit XML test results** using Pester's built-in `Export-JUnitReport` command.

### Key Points

- **NUnit XML** (Pester's default) → **JUnit XML** (Codecov's requirement)
- **Pester v5.7.1+** includes `Export-JUnitReport` command
- **Automatic conversion** during CI test runs
- **Codecov-ready format** with all required fields

---

## Test Results Format

### JUnit XML Schema (Codecov Expected)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="jest tests" tests="2" failures="2" errors="0" time="1.007">
    <testsuite name="undefined" errors="0" failures="2" skipped="0"
               timestamp="2024-02-22T19:10:35" time="0.955" tests="6.4">
        <testcase classname="test uncovered if" name="test uncovered if" time="5.4">
        </testcase>
        <testcase classname="fully covered" name="fully covered" time="7.2">
            <failure message="Test failed" />
        </testcase>
    </testsuite>
</testsuites>
```

### Key Required Fields

- `<testsuites>` - Root element
- `tests` - Total test count
- `failures` - Failed test count
- `errors` - Error count
- `time` - Total execution time (seconds)
- `timestamp` - ISO 8601 format timestamp
- `<testsuite>` - Test suite container
- `<testcase>` - Individual test
  - `classname` - Test class/module
  - `name` - Test name
  - `time` - Test execution time
  - `<failure>` - Optional failure element

---

## Running Tests

### Generate Both NUnit and JUnit Formats

```powershell
# Run tests with CI flag to generate both formats
npm run test:coverage -- -CI

# Or directly
pwsh -NoProfile -Command "& .\scripts\Test-Coverage.ps1 -CI"
```

### Output Files

| File | Format | Purpose |
|------|--------|---------|
| `testResults.junit.xml` | NUnit XML | Local testing, Azure DevOps |
| `testResults.junit.xml` | JUnit XML | **Codecov** (required) |
| `coverage.xml` | JaCoCo | Code coverage analysis |

---

## Pester Export Commands

### Export-JUnitReport (Primary)

```powershell
# Run tests and capture result
$result = Invoke-Pester -PassThru

# Export to JUnit format
$result | Export-JUnitReport -Path "testResults.junit.xml"
```

### Export-NUnitReport (Default)

```powershell
# Alternative: Export to NUnit format
$result | Export-NUnitReport -Path "testResults.junit.xml" -Format NUnit2.5
```

---

## CI/CD Integration

### GitHub Actions

```yaml
- name: Run Tests with Coverage
  run: pwsh -NoProfile -Command "& .\scripts\Test-Coverage.ps1 -CI"

- name: Upload to Codecov
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage.xml
    test_results_file: ./testResults.junit.xml
    flags: unittests
```

### Local Testing

```powershell
# Generate JUnit for local review
pwsh -NoProfile -Command "& .\scripts\Test-Coverage.ps1 -CI"

# View the generated file
[xml]$junit = Get-Content testResults.junit.xml
$junit.testsuites
```

---

## Troubleshooting

### Codecov Not Recognizing Tests

✅ **Verify file naming** - Must end with `junit.xml`:
```powershell
# Correct
testResults.junit.xml ✓

# Incorrect
testResults.xml ✗
test-results.junit.xml ✗
```

✅ **Check XML structure**:
```powershell
$xml = [xml](Get-Content testResults.junit.xml)
$xml.testsuites | Select-Object name, tests, failures, errors, time
```

✅ **Ensure CODECOV_TOKEN is set**:
```powershell
$env:CODECOV_TOKEN = "your-token-here"
```

### Export-JUnitReport Not Found

Ensure Pester v5.7.1+ is installed:

```powershell
# Check version
$pesterModule = Get-Module -ListAvailable -Name Pester
$pesterModule | Select-Object Name, Version

# Update if needed
Install-Module -Name Pester -MinimumVersion 5.7.1 -Force
```

### Missing Required Attributes

The conversion automatically adds:
- ✓ `timestamp` - Current date/time
- ✓ `time` - Test execution duration
- ✓ `tests` - Total test count
- ✓ `failures` - Failed count
- ✓ `errors` - Error count

---

## Test Results Analysis

### Parse JUnit XML Programmatically

```powershell
# Load and analyze
[xml]$junit = Get-Content testResults.junit.xml

# Get summary
$junit.testsuites | Select-Object tests, failures, errors, time

# List all testcases
$junit.testsuites.testsuite.testcase | Select-Object classname, name, time

# Find failures
$junit.testsuites.testsuite.testcase | Where-Object { $_.failure }
```

### Generate Reports

```powershell
# Extract test metrics
$suite = $junit.testsuites.testsuite
$totalTests = [int]$suite.tests
$failures = [int]$suite.failures
$successRate = (($totalTests - $failures) / $totalTests) * 100

Write-Host "Test Results:"
Write-Host "  Total: $totalTests"
Write-Host "  Passed: $($totalTests - $failures)"
Write-Host "  Failed: $failures"
Write-Host "  Success Rate: $([math]::Round($successRate, 2))%"
```

---

## Files Modified

- `scripts/Test-Coverage.ps1` - Added JUnit export on line after Pester execution
- Generates `testResults.junit.xml` automatically in CI mode

## Migration from NUnit to JUnit

**Before:**
```powershell
$config.TestResult.OutputFormat = 'NUnitXml'
```

**After:**
```powershell
# Generate both NUnit (for Azure DevOps) and JUnit (for Codecov)
$result | Export-JUnitReport -Path "testResults.junit.xml"
```

---

## References

- [Pester Export-JUnitReport Docs](https://pester.dev/docs/commands/Export-JUnitReport)
- [Codecov Test Results Documentation](https://docs.codecov.com/docs/test-analytics)
- [JUnit 4 XML Schema](https://junit.org/junit4/)

---

## Summary

✅ **Automatic JUnit XML generation** for Codecov
✅ **Pester v5.7.1+ built-in support**
✅ **CI-friendly format** with all required fields
✅ **Easy troubleshooting** with XML validation
✅ **Multiple format support** (NUnit + JUnit)

Codecov will now automatically detect and parse `testResults.junit.xml` files generated by your test runs.
