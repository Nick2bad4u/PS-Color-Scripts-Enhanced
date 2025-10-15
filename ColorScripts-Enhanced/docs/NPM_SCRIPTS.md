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

## Documentation

### `npm run docs:update-counts`

Synchronize script-count markers across all documentation files:

```powershell
npm run docs:update-counts
```

This updates markers like:

- `<!-- COLOR_SCRIPT_COUNT_PLUS -->245+<!-- /COLOR_SCRIPT_COUNT_PLUS -->`
- `<!-- COLOR_CACHE_TOTAL -->245+<!-- /COLOR_CACHE_TOTAL -->`
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
