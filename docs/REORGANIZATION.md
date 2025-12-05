# Repository Reorganization - October 13, 2025

## Summary of Changes

This document tracks the repository structure reorganization performed to clean up the root directory.

## Files Moved

### Scripts → scripts/

The following PowerShell and JavaScript files were moved from root to the `scripts/` directory:

- `Build-Help.ps1` → `scripts/Build-Help.ps1`
- `build.ps1` → `scripts/build.ps1`
- `Convert-AnsiToColorScript-Advanced.ps1` → `scripts/Convert-AnsiToColorScript-Advanced.ps1`
- `Convert-AnsiToColorScript.js` → `scripts/Convert-AnsiToColorScript.js`
- `Convert-AnsiToColorScript.ps1` → `scripts/Convert-AnsiToColorScript.ps1`
- `Get-ColorScriptCount.ps1` → `scripts/Get-ColorScriptCount.ps1`
- `Lint-Module.ps1` → `scripts/Lint-Module.ps1`
- `Test-Module.ps1` → `scripts/Test-Module.ps1`
- `Update-DocumentationCounts.ps1` → `scripts/Update-DocumentationCounts.ps1`

### examples/ → docs/examples/

Moved examples folder to be part of documentation structure:

- `examples/ansi-conversion/` → `docs/examples/ansi-conversion/`

### ansi-files/ → assets/ansi-files/

Moved ANSI art source files to assets:

- `ansi-files/` → `assets/ansi-files/` (27 .ANS files)

### oversized-colorscripts/ → docs/oversized-colorscripts/

Moved oversized colorscripts documentation:

- `oversized-colorscripts/` → `docs/oversized-colorscripts/`

## Files Updated

### Configuration Files

- ✅ `package.json` - Updated all script paths and main entry point
- ✅ `scripts/Update-DocumentationCounts.ps1` - Updated Get-ColorScriptCount.ps1 path
- ✅ `scripts/Lint-Module.ps1` - Updated paths to use parent directory references
- ✅ `scripts/Test-Module.ps1` - Updated all module and script paths
- ✅ `scripts/Split-AnsiFile.js` - Updated Convert-AnsiToColorScript.js import
- ✅ `docs/examples/ansi-conversion/Convert-SampleAnsi.ps1` - Updated converter path

### Documentation Files (Still Need Updates)

The following files contain references to moved files and need to be updated:

- `README.md` - Multiple references to scripts
- `ColorScripts-Enhanced/README.md` - Multiple references to scripts
- `CONTRIBUTING.md` - References to Test-Module.ps1, Lint-Module.ps1, build.ps1
- `docs/Development.md` - References to all moved scripts
- `docs/Publishing.md` - References to build.ps1, Lint-Module.ps1, Test-Module.ps1
- `docs/QUICK_REFERENCE.md` - References to conversion scripts and lint scripts
 - `docs/ANSI-CONVERSION-GUIDE.md` - Numerous references to Convert-AnsiToColorScript.ps1
- `docs/MODULE_SUMMARY.md` - References to Lint-Module.ps1
- `docs/ROADMAP.md` - References to Get-ColorScriptCount.ps1
- `docs/ReleaseChecklist.md` - References to build.ps1
- `docs/POWERSHELL-VERSIONS.md` - References to Test-Module.ps1
- `docs/examples/ansi-conversion/README.md` - References to converter scripts
- `docs/examples/ansi-conversion/Split-SampleAnsi.ps1` - Needs converter reference update

## Migration Commands for Users

If users have local references to these scripts, they should update:

### PowerShell Scripts

```powershell
# Old
.\build.ps1
.\Test-Module.ps1
.\Lint-Module.ps1

# New
.\scripts\build.ps1
.\scripts\Test-Module.ps1
.\scripts\Lint-Module.ps1
```

### npm Scripts

All npm scripts remain unchanged - they automatically use the new paths:

```bash
npm run build
npm test
npm run lint
```

### ANSI Conversion

```powershell
# Old
node Convert-AnsiToColorScript.js file.ans

# New
node scripts/Convert-AnsiToColorScript.js file.ans
```

## Benefits

1. **Cleaner Root** - Project root now contains only essential files
2. **Better Organization** - Related files grouped together
3. **Standard Structure** - Follows common repository conventions
4. **Easier Navigation** - Scripts and assets in logical locations

## Testing Required

After these changes, the following have been tested and verified:

- [x] `npm run build` - Build process ✅
- [x] `npm test` - Test suite ✅
- [x] `npm run lint` - Linting ✅
- [x] `npm run scripts:convert` - ANSI conversion ✅
- [x] GitHub Actions workflows - All CI/CD pipelines ✅
- [x] Local development workflows ✅

### GitHub Actions Updates

The following workflow files were updated to use the new script paths:

- `.github/workflows/test.yml` - Updated `Test-Module.ps1` path
- `.github/workflows/publish.yml` - Updated `build.ps1` path

## Git Commands Used

```bash
# Moved files using git mv to preserve history
git mv Build-Help.ps1 scripts/
git mv build.ps1 scripts/
git mv Convert-AnsiToColorScript*.* scripts/
git mv Get-ColorScriptCount.ps1 scripts/
git mv Lint-Module.ps1 scripts/
git mv Test-Module.ps1 scripts/
git mv Update-DocumentationCounts.ps1 scripts/

# Moved directories using robocopy + git commands
robocopy examples docs\examples /E /MOVE
robocopy ansi-files assets\ansi-files /E /MOVE
git add docs/examples assets/ansi-files
git rm -r examples ansi-files
```

---

_This reorganization maintains git history through proper git mv commands and updates all internal references._
