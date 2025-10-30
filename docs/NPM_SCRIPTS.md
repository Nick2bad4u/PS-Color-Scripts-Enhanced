# npm Scripts Reference

This document describes the npm scripts available for ColorScripts-Enhanced development and maintenance.

> **Note:** These npm scripts are for **development and repository maintenance only**. End-users do not need Node.js or npm to use the PowerShell module.

## Build & Release

### `npm run build`

Build the module manifest and refresh documentation counts.

```powershell
npm run build
```

This script:

- Updates the module manifest with version and metadata
- Refreshes script count markers in documentation
- Generates release notes
- Runs verification checks

### `npm run build:skip-help`

Build without regenerating help files (faster):

```powershell
npm run build:skip-help
```

### `npm run build:help`

Generate external help XML from markdown:

```powershell
npm run build:help
```

## Testing

### `npm test`

Execute the smoke-test harness (`Test-Module.ps1`):

```powershell
npm test
```

### `npm run test:pester`

Run the full Pester test suite in `./Tests`:

```powershell
npm run test:pester
```

### `npm run verify`

Run comprehensive verification including strict linting, markdown checks, and all tests:

```powershell
npm run verify
```

## Linting

### `npm run lint`

Run ScriptAnalyzer against the module:

```powershell
npm run lint
```

### `npm run lint:strict`

Run lint with tests included and warnings treated as errors:

```powershell
npm run lint:strict
```

### `npm run lint:fix`

Apply ScriptAnalyzer fixes where possible, then rerun lint:

```powershell
npm run lint:fix
```

### `npm run build:help`

Generate external help XML from markdown:

```powershell
npm run build:help
```

## Testing

### `npm test`

Execute the smoke-test harness (`Test-Module.ps1`):

```powershell
npm test
```

This runs:
- Module import validation
- Command export verification
- Basic functionality tests
- ScriptAnalyzer compliance check
- Help documentation availability

### `npm run test:pester`

Run the full Pester test suite in `./Tests`:

```powershell
npm run test:pester
```

Includes:
- Unit tests for all commands
- Integration test scenarios
- Cache behavior validation
- Configuration persistence tests
- Error handling tests
- Performance tests

### `npm run test:coverage`

Run tests with code coverage analysis:

```powershell
npm run test:coverage
```

Generates coverage report showing:
- Statement coverage percentage
- Branch coverage
- Function coverage
- Line coverage

## Advanced Test Workflows

### Test Specific File

```powershell
# Run individual test file
Invoke-Pester -Path ./Tests/Show-ColorScript.Tests.ps1
```

### Test Specific Function

```powershell
# Test only caching functionality
Invoke-Pester -Path ./Tests -TestNameFilter '*cache*'
```

### Test with Verbose Output

```powershell
# See detailed test execution
$VerbosePreference = 'Continue'
npm run test:pester
$VerbosePreference = 'SilentlyContinue'
```

### Generate Test Report

```powershell
# Generate XML report for CI
Invoke-Pester -Path ./Tests -OutputFile test-results.xml -OutputFormat JUnitXml
```

## Linting

### `npm run lint`

Run ScriptAnalyzer against the module:

```powershell
npm run lint
```

Checks:
- Cmdlet naming conventions
- Parameter naming
- Comment-based help quality
- Code style consistency
- Security concerns

### `npm run lint:strict`

Run lint with tests included and warnings treated as errors:

```powershell
npm run lint:strict
```

Use before:
- Pull request submission
- Release publishing
- Major commits

### `npm run lint:fix`

Apply ScriptAnalyzer fixes where possible, then rerun lint:

```powershell
npm run lint:fix
```

Auto-fixes:
- Indentation
- Whitespace
- Brace placement
- Some code style issues

Then reruns linting to verify all issues are resolved.

## Documentation

### `npm run docs:update-counts`

Synchronize script-count markers across all documentation files:

```powershell
npm run docs:update-counts
```

Updates markers like:
- `<!-- COLOR_SCRIPT_COUNT_PLUS -->498+<!-- /COLOR_SCRIPT_COUNT_PLUS -->`
- `<!-- COLOR_CACHE_TOTAL -->498+<!-- /COLOR_CACHE_TOTAL -->`

Run after:
- Adding new colorscripts
- Removing scripts
- Before commits/releases

### `npm run docs:validate-links`

Validate all markdown links:

```powershell
npm run docs:validate-links
```

Checks:
- Internal file references
- External URLs
- Anchor links
- Image references

Fix broken links before publishing.

## Release & Publishing

### `npm run release:notes`

Generate release notes using git-cliff:

```powershell
npm run release:notes
```

Outputs changelog from git history using conventional commits.

### `npm run release:notes:latest`

Generate only the latest version notes:

```powershell
npm run release:notes:latest
```

### `npm run release:verify`

Verify release notes format:

```powershell
npm run release:verify
```

Checks:
- CHANGELOG.md formatting
- Version consistency
- Link validity
- Duplicate sections

## Verification

### `npm run verify`

Run comprehensive verification including strict linting, markdown checks, and all tests:

```powershell
npm run verify
```

Runs in order:
1. Linting (strict mode)
2. Documentation validation
3. Smoke tests
4. Full Pester tests
5. Coverage report

**Use this before:**
- Committing to main
- Creating pull requests
- Publishing releases

## Utility Scripts

### Manual npm Script Inspection

View all available scripts:

```powershell
npm run
```

Or view the `package.json` file:

```powershell
Get-Content package.json | ConvertFrom-Json | Select-Object -ExpandProperty scripts
```

## Chaining Commands

### Run multiple scripts in sequence

```powershell
npm run lint && npm test && npm run docs:update-counts
```

### Run scripts with arguments

Pass arguments to scripts using `--`:

```powershell
# Run linter with specific file
npm run lint -- .\ColorScripts-Enhanced\ColorScripts-Enhanced.psm1

# Run Pester with verbose
npm run test:pester -- -Verbose
```

## Environment Variables

### PowerShell Paths

Scripts automatically detect:
- PowerShell executable location
- Module path locations
- Temp directory for test artifacts

Override with:
```powershell
$env:PSROOT = "C:\Program Files\PowerShell\7"
npm run test
```

### Test Configuration

```powershell
# Run tests with specific settings
$env:PESTER_VERBOSITY = 'Detailed'
npm run test:pester
```

## Troubleshooting npm Scripts

### Script Won't Run

```powershell
# Ensure Node.js is installed
node --version
npm --version

# Reinstall dependencies
npm install

# Clear cache
npm cache clean --force
```

### PowerShell Execution Issues

```powershell
# Set execution policy if needed
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Or run with bypass flag
npm test
```

### Permission Errors

```powershell
# Run PowerShell as Administrator if needed
# Or use Process scope (temporary)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

## Performance Optimization

### Parallel Execution

```powershell
# Run tests in parallel (PowerShell 7+)
npm run test:pester -- -Parallel -ThrottleLimit 4
```

### Faster Linting

```powershell
# Skip test linting for faster feedback
npm run lint
# (vs. npm run lint:strict which includes tests)
```

### Selective Testing

```powershell
# Test only modified files
npm test
# (faster than full suite)
```

## CI/CD Integration

These scripts are used in GitHub Actions workflows:

- `.github/workflows/test.yml` - Uses `npm test` and `npm run test:pester`
- `.github/workflows/publish.yml` - Uses `npm run build` and release scripts
- `.github/workflows/lint.yml` - Uses `npm run lint:strict`

See `.github/workflows/` for complete automation details.

## Daily Development Workflow

### Quick Development Loop

```powershell
# 1. Make code changes

# 2. Quick test
npm test

# 3. Full validation before commit
npm run verify

# 4. Commit if all pass
git commit -am "feat: your change"
```

### Before Pull Request

```powershell
# Complete validation suite
npm run verify

# Check documentation counts
npm run docs:update-counts

# Validate release notes
npm run release:verify

# Then push to GitHub
git push origin feature-branch
```

### Before Release

```powershell
# Full verification
npm run verify

# Update documentation
npm run docs:update-counts

# Generate release notes
npm run release:notes:latest

# Build
npm run build

# Then publish via GitHub Actions
```

## Reference

- **Build Script**: `scripts/build.ps1`
- **Test Harness**: `scripts/Test-Module.ps1`
- **Linter**: `scripts/Lint-Module.ps1`
- **Documentation Script**: `scripts/Update-DocumentationCounts.ps1`
- **Package Config**: `package.json`

---

**Last Updated**: October 30, 2025
- `<!-- COLOR_SCRIPT_COUNT -->245<!-- /COLOR_SCRIPT_COUNT -->`

### `npm run markdown:check`

Run `markdown-link-check` across all repository documentation:

```powershell
npm run markdown:check
```

### `npm run readme:check`

Check if the PowerShell Gallery README is within the 8KB size limit:

```powershell
npm run readme:check
```

### `npm run readme:check:strict`

Strict README size check that fails if over limit:

```powershell
npm run readme:check:strict
```

## Package Management

### `npm run package:metadata`

Inject README/license/icon metadata into a generated package before publishing:

```powershell
npm run package:metadata -- --PackagePath path/to/package.nupkg
```

## ColorScript Utilities

### `npm run scripts:convert`

Convert an ANSI file into a PowerShell colorscript (Node-based converter):

```powershell
npm run scripts:convert -- path/to/artwork.ans
```

### `npm run scripts:convert:ps`

Convert using the PowerShell converter:

```powershell
npm run scripts:convert:ps
```

### `npm run scripts:convert:advanced`

Convert using the advanced PowerShell converter with enhanced features:

```powershell
npm run scripts:convert:advanced
```

### `npm run scripts:split`

Split a tall ANSI or PowerShell script into multiple chunks:

```powershell
npm run scripts:split -- file.ans --max-height 50
```

### `npm run scripts:format`

Format and standardize colorscript files:

```powershell
npm run scripts:format
```

### `npm run scripts:count`

Count the total number of colorscripts:

```powershell
npm run scripts:count
```

### `npm run scripts:test-all`

Execute every colorscript to validate they all work:

```powershell
npm run scripts:test-all
```

## Release Notes

### `npm run release:notes`

Generate unreleased notes (stripped header) for PowerShell Gallery publishing:

```powershell
npm run release:notes
```

Output: `dist/PowerShellGalleryReleaseNotes.md`

### `npm run release:notes:latest`

Generate the most recent tagged release notes:

```powershell
npm run release:notes:latest
```

Output: `dist/LatestReleaseNotes.md`

### `npm run release:verify`

Validate CHANGELOG.md against the module manifest and git-cliff configuration:

```powershell
npm run release:verify
```

## Development Workflow

Typical development workflow using npm scripts:

```powershell
# 1. Make changes to module code

# 2. Update documentation counts
npm run docs:update-counts

# 3. Run linting with auto-fix
npm run lint:fix

# 4. Run tests
npm test

# 5. Run full verification
npm run verify

# 6. Build module
npm run build
```

## CI/CD Integration

The GitHub Actions workflows use these npm scripts:

- **Test Workflow** - `npm test`, `npm run lint:strict`
- **Publish Workflow** - `npm run build`, `npm run release:notes`
- **Link Check** - `npm run markdown:check`

## Requirements

The npm scripts require:

- **Node.js** 18+ (for ANSI conversion scripts)
- **PowerShell** 5.1+ or PowerShell 7.0+
- **npm** dependencies installed (`npm install`)

Developer-specific PowerShell modules:

- **Pester** 5.4.0+ (for testing)
- **PSScriptAnalyzer** (for linting)
- **platyPS** (optional, for help generation)

Install PowerShell modules:

```powershell
Install-Module -Name Pester -MinimumVersion 5.4.0 -Force -SkipPublisherCheck
Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck
Install-Module -Name platyPS -Force -SkipPublisherCheck  # Optional
```

## See Also

- [Development Guide](Development.md) - Complete development workflow
- [Testing Guide](TESTING.md) - Testing procedures
- [Linting Guide](LINTING.md) - Code quality standards
- [Publishing Guide](Publishing.md) - Release and publishing process
