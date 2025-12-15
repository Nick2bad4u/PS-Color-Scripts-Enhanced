# Contributing to ColorScripts-Enhanced

Thank you for your interest in contributing to ColorScripts-Enhanced! This document provides guidelines for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors. Please review the [Code of Conduct](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CODE_OF_CONDUCT.md) before submitting contributions.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in Issues
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - PowerShell version (`$PSVersionTable`)
   - Terminal information
   - Error messages (if any)

### Suggesting Features

1. Check if the feature has been suggested
2. Create a new issue with:
   - Clear description of the feature
   - Use cases and benefits
   - Possible implementation approach
   - Examples of similar features

### Contributing Code

#### Adding New Colorscripts

1. **Create the script file**
   - Place in `ColorScripts-Enhanced/Scripts/`
   - Use lowercase-with-hyphens naming: `my-cool-script.ps1`
   - Include proper UTF-8 encoding

2. **Script structure**

   ```powershell
   # Script Name - Brief description
   # Your colorscript code here
   Write-Host "Beautiful ANSI art" -ForegroundColor Green
   ```

3. **Follow guidelines**
   - Use ANSI escape codes for colors: `$esc = [char]27`
   - Support UTF-8 encoding
   - Keep scripts under 500 lines when possible
   - Add comments for complex sections
   - Test on multiple terminals

4. **Test your script**

   ```powershell
   # Test direct execution
   & .\ColorScripts-Enhanced\Scripts\my-cool-script.ps1

   # Test via module
   Show-ColorScript -Name my-cool-script

   # Test caching
   New-ColorScriptCache -Name my-cool-script
   Show-ColorScript -Name my-cool-script
   ```

#### Modifying Module Code

1. **Fork the repository**

2. **Create a feature branch**

   ```powershell
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add comment-based help to functions
   - Update version numbers appropriately
   - Test thoroughly

4. **Update documentation**
   - Update RELEASENOTES.md
   - Update README.md if needed
   - Add/update help files
   - Include examples

5. **Run tests**

   ```powershell
   # Module smoke tests (includes ScriptAnalyzer)
   pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"

   # Full unit tests
   Invoke-Pester -Path ./Tests

   # Lint (treat warnings as failures)
   pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors

   # (Optional) Auto-fix ScriptAnalyzer violations when available
   pwsh -NoProfile -Command "& .\scripts\Lint-Module.ps1" -Fix
   ```

6. **Commit your changes**

   ```powershell
   git add .
   git commit -m "feat: add awesome new feature"
   ```

7. **Push and create PR**
   ```powershell
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request on GitHub

## Development Guidelines

### PowerShell Style Guide

- Use approved verbs: `Get-`, `Set-`, `New-`, `Remove-`, `Build-`, `Clear-`, `Show-`
- PascalCase for function names
- camelCase for variables
- Full parameter names in scripts
- Comment-based help for all public functions
- Support `-WhatIf` and `-Confirm` for destructive operations

### Comment-Based Help Format

```powershell
function Verb-Noun {
    <#
    .SYNOPSIS
        Brief description

    .DESCRIPTION
        Detailed description

    .PARAMETER ParameterName
        Parameter description

    .EXAMPLE
        Verb-Noun -ParameterName Value
        Description of what this does

    .NOTES
        Additional information

    .LINK
        Related commands or URLs
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ParameterName
    )

    # Implementation
}
```

### ANSI Color Guidelines

Use ANSI escape sequences for maximum compatibility:

```powershell
$esc = [char]27

# 16 colors
Write-Host "${esc}[31mRed Text${esc}[0m"

# 256 colors
Write-Host "${esc}[38;5;208mOrange${esc}[0m"

# RGB (24-bit)
Write-Host "${esc}[38;2;255;100;50mCustom Color${esc}[0m"

# Always reset
Write-Host "${esc}[0m"
```

### Performance Considerations

- Use `[Console]::Write()` for direct output when possible
- Minimize object creation in loops
- Cache frequently used values
- Use StringBuilder for large string concatenations
- Profile performance-critical sections

### Testing Checklist

Before submitting:

- [ ] Code follows style guidelines
- [ ] All functions have comment-based help
- [ ] Examples work as documented
- [ ] Tested on PowerShell 5.1 and 7.x
- [ ] Tested on Windows Terminal
- [ ] Verified glyph-heavy scripts render with a Nerd Font (`Show-ColorScript -Name nerd-font-test`)
- [ ] UTF-8 encoding verified
- [ ] `Lint-Module.ps1 -IncludeTests -TreatWarningsAsErrors` passes
- [ ] Pester tests pass (`Invoke-Pester -Path ./Tests`)
- [ ] No breaking changes (or documented if required)
- [ ] Documentation updated
- [ ] Release notes updated

## Project Structure

```powershell
ps-color-scripts-enhanced/
├── ColorScripts-Enhanced/
│   ├── ColorScripts-Enhanced.psd1    # Module manifest
│   ├── ColorScripts-Enhanced.psm1    # Module code
│   ├── en-US/                         # Help files
│   │   ├── about_ColorScripts-Enhanced.help.txt
│   │   ├── Show-ColorScript.md
│   │   ├── Get-ColorScriptList.md
│   │   ├── New-ColorScriptCache.md
│   │   └── Clear-ColorScriptCache.md
│   └── Scripts/                       # Colorscript files
│       ├── hearts.ps1
│       ├── mandelbrot-zoom.ps1
│       └── ...                        # Render logic only; caching handled by module
├── scripts/                           # Build and utility scripts
│   ├── build.ps1                      # Build script
│   ├── Test-Module.ps1                # Test harness
│   ├── Lint-Module.ps1                # Linting script
│   └── ...                            # Other utility scripts
├── docs/                              # Documentation
│   ├── examples/                      # Example code and conversions
│   └── oversized-colorscripts/        # Large colorscripts
├── assets/                            # Static assets
│   └── ansi-files/                    # Source ANSI art files
├── README.md                          # Main documentation
├── RELEASENOTES.md                    # Version history
├── CONTRIBUTING.md                    # This file
├── LICENSE                            # Unlicense License
└── .gitignore                         # Git ignore rules
```

## Pull Request Process

1. **Before Starting**
   - [ ] Fork the repository
   - [ ] Create a feature branch: `git checkout -b feature/your-feature`
   - [ ] Update `.gitignore` if needed

2. **During Development**
   - [ ] Follow code style guidelines
   - [ ] Add tests for new functionality
   - [ ] Update relevant documentation
   - [ ] Run full test suite: `npm run verify`
   - [ ] Run linting: `npm run lint:fix`

3. **Before Submitting PR**
   - [ ] All tests pass: `npm run verify`
   - [ ] Linting clean: `npm run lint`
   - [ ] Documentation updated
   - [ ] Examples work correctly
   - [ ] Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
   - [ ] Tested on multiple PowerShell versions

4. **Creating the PR**
   - [ ] Use descriptive title
   - [ ] Link related issues: `Closes #123`
   - [ ] Include description of changes
   - [ ] Mention breaking changes (if any)
   - [ ] Request review from maintainers

5. **After PR Submission**
   - [ ] Address review feedback
   - [ ] Keep branch up to date with main
   - [ ] Rebase if necessary
   - [ ] Wait for maintainer approval

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```text
type(scope): subject

body

footer
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code formatting
- **refactor**: Code restructuring
- **perf**: Performance improvement
- **test**: Test changes
- **chore**: Build or dependency changes

### Examples

```text
feat(cache): add parallel cache building

Implemented multi-threaded cache generation
for improved performance on large collections.

Closes #456
```

```text
fix(caching): resolve cache invalidation bug

Cache was not invalidating when scripts
were updated in certain scenarios.
```

## Contribution Types

### Adding Colorscripts

**Difficulty**: Easy 🟢

Steps:

1. Create script file in `ColorScripts-Enhanced/Scripts/`
2. Use lowercase-with-hyphens naming
3. Add to `ScriptMetadata.psd1`
4. Test with: `Show-ColorScript -Name your-script`
5. Submit PR with description

**Requirements**:

- [ ] UTF-8 encoding
- [ ] ANSI escape sequences for colors
- [ ] Under 500 lines (prefer smaller)
- [ ] No external dependencies
- [ ] Tested on multiple terminals
- [ ] Comments for complex sections

**Example**:

```powershell
# File: ColorScripts-Enhanced/Scripts/my-awesome-art.ps1
$esc = [char]27
$red = "$esc[38;2;255;0;0m"
$reset = "$esc[0m"

Write-Host "${red}Beautiful ANSI Art${reset}"
```

### Bug Reports

**Difficulty**: Easy 🟢

When reporting:

1. Use [bug report template](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues/new?template=bug_report.md)
2. Include:
   - PowerShell version (`$PSVersionTable`)
   - Operating system and terminal
   - Exact reproduction steps
   - Error messages and logs
   - Attached screenshots (if visual)

### Feature Requests

**Difficulty**: Easy 🟢

When requesting:

1. Use [feature request template](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues/new?template=feature_request.md)
2. Include:
   - Clear description of desired functionality
   - Use cases and benefits
   - Proposed implementation approach
   - Examples or mockups (if applicable)

### Documentation

**Difficulty**: Easy 🟢

Areas for improvement:

- [ ] Typo fixes
- [ ] Clarity improvements
- [ ] New examples
- [ ] Additional guides
- [ ] Better translations (if multilingual)

### Code Contributions

**Difficulty**: Medium 🟡 to Hard 🔴

Examples:

- New cmdlet (Hard 🔴)
- Bug fix (Medium 🟡)
- Performance optimization (Medium 🟡 to Hard 🔴)
- Refactoring (Medium 🟡)
- Test additions (Easy 🟢 to Medium 🟡)

For complex changes:

1. Open issue first to discuss approach
2. Wait for maintainer feedback
3. Implement with tests
4. Submit PR with detailed explanation

## Development Workflow Details

### Local Setup

```powershell
# 1. Clone repository
git clone https://github.com/yourusername/ps-color-scripts-enhanced.git
cd ps-color-scripts-enhanced

# 2. Install dependencies
npm install

# 3. Verify setup
npm run build
npm test
```

### Making Changes

```powershell
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes to files

# 3. Test changes
npm test
npm run lint

# 4. Run full validation
npm run verify

# 5. Commit changes
git add .
git commit -m "feat(module): add new feature"

# 6. Push to fork
git push origin feature/my-feature
```

### Handling Conflicts

If your PR has conflicts:

```powershell
# Update from main
git fetch upstream
git rebase upstream/main

# Resolve conflicts in your editor, then:
git add .
git rebase --continue
git push origin feature/my-feature -f
```

## Testing Your Contributions

### Unit Tests

```powershell
# Run all tests
npm run test:pester

# Run specific test file
Invoke-Pester -Path ./Tests/MyTest.Tests.ps1

# Run with coverage report
Invoke-Pester -Path ./Tests -CodeCoverage ColorScripts-Enhanced/ColorScripts-Enhanced.psm1
```

### Integration Tests

```powershell
# Test full workflow
New-ColorScriptCache -Force
Show-ColorScript
Get-ColorScriptList
Export-ColorScriptMetadata -IncludeFileInfo
```

### Smoke Tests

```powershell
# Quick validation
npm test
```

### Linting

```powershell
# Standard linting
npm run lint

# With auto-fix
npm run lint:fix

# Strict mode (treat warnings as errors)
npm run lint:strict
```

## Testing Matrix

Test your changes across:

| Platform | PowerShell 5.1 | PowerShell 7.x | Status      |
| -------- | -------------- | -------------- | ----------- |
| Windows  | ✅              | ✅              | Required    |
| macOS    | ❌              | ✅              | Recommended |
| Linux    | ❌              | ✅              | Recommended |

Use GitHub Actions or test locally:

```powershell
# PowerShell 5.1 (Windows only)
powershell -NoProfile -Command "& .\scripts\Test-Module.ps1"

# PowerShell 7
pwsh -NoProfile -Command "& .\scripts\Test-Module.ps1"
```

## Performance Benchmarking

Before optimization PRs, include benchmarks:

```powershell
# Measure before
$before = Measure-Command { Show-ColorScript -Name mandelbrot-zoom -NoCache }

# Make your changes...

# Measure after
$after = Measure-Command { Show-ColorScript -Name mandelbrot-zoom -NoCache }

Write-Host "Before: $($before.TotalMilliseconds)ms"
Write-Host "After: $($after.TotalMilliseconds)ms"
Write-Host "Improvement: $(([math]::Round($before.TotalMilliseconds / $after.TotalMilliseconds, 2)))x"
```

## Documentation Standards

### Code Comments

```powershell
# Good: Explains WHY not WHAT
# We use StringBuilder for performance with large outputs
$sb = [System.Text.StringBuilder]::new()

# Bad: Restates obvious code
# Increment counter
$i++
```

### Help Documentation

All public functions must have comment-based help:

```powershell
<#
.SYNOPSIS
    One-line summary (critical)

.DESCRIPTION
    Detailed explanation of what it does.
    Include use cases and behavior.

.PARAMETER Name
    Description of parameter.
    Include type and valid values.

.PARAMETER Force
    Switch to override default behavior.

.EXAMPLE
    Show-ColorScript -Name "hearts"

    Displays the "hearts" colorscript.

.EXAMPLE
    Show-ColorScript -Random

    Displays a random colorscript.

.INPUTS
    System.String. You can pipe a script name.

.OUTPUTS
    None or System.String (with -PassThru)

.NOTES
    Additional technical notes.

.LINK
    Get-ColorScriptList
    New-ColorScriptCache
    https://github.com/Nick2bad4u/ps-color-scripts-enhanced
#>
```

## Approval Process

### Automatic Checks

- ✅ Tests pass
- ✅ Linting passes
- ✅ No security issues
- ✅ Coverage maintained

### Manual Review

- Code quality
- Design appropriateness
- Documentation completeness
- Breaking changes assessment

### Approval Criteria

PR can be merged when:

1. All automatic checks pass
2. At least one maintainer approves
3. No requested changes remain
4. Commits are clean

## Recognition

Contributors will be recognized:

- In CHANGELOG.md for each release
- In [CONTRIBUTORS.md](./docs/CONTRIBUTORS.md)
- GitHub "Contributors" page
- Release announcements (optional)

## Resources for Contributors

### Documentation (2)

- [PowerShell Docs](https://docs.microsoft.com/powershell/)
- [Pester Testing Guide](https://pester.dev/)
- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
- [ANSI Art Guide](./docs/ANSI-COLOR-GUIDE.md)
- [ANSI Conversion Guide](./docs/ANSI-CONVERSION-GUIDE.md)

### Tools

- [VS Code PowerShell Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [git-cliff](https://git-cliff.org/)

### Community

- [GitHub Discussions](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/discussions)
- [GitHub Issues](https://github.com/Nick2bad4u/ps-color-scripts-enhanced/issues)
- PowerShell Discord (if available)

## Getting Help

- **Questions**: Open a GitHub Discussion
- **Bug Reports**: Use issue template
- **Feature Ideas**: Use issue template or Discussion
- **Code Review**: Ask in PR comments
- **General Help**: Check existing docs first

## Version Numbering

Format: `YYYY.MM.DD.BuildNumber`

Example: `2025.10.09.1625`

- **YYYY**: Year
- **MM**: Month (01-12)
- **DD**: Day (01-31)
- **BuildNumber**: Sequential number for multiple releases per day

## Questions

- 📖 Check [README.md](./README.md)
- 📚 Review [docs/](./docs/) folder
- 💬 Open a Discussion
- 🐛 Check existing Issues
- 👥 Ask in PR comments

## License

By contributing, you agree your contributions will be licensed under the [Unlicense License](./LICENSE).

---

## Thank You

Your contributions make ColorScripts-Enhanced better for the entire PowerShell community! 🎨✨
