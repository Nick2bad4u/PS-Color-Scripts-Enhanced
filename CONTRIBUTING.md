# Contributing to ColorScripts-Enhanced

Thank you for your interest in contributing to ColorScripts-Enhanced! This document provides guidelines for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

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
   # Check cache first for instant output
   if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

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
   Build-ColorScriptCache -Name my-cool-script
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
   pwsh -NoProfile -Command "& .\Test-Module.ps1"

   # Full unit tests
   Invoke-Pester -Path ./Tests

   # Lint (treat warnings as failures)
   pwsh -NoProfile -Command "& .\Lint-Module.ps1" -IncludeTests -TreatWarningsAsErrors

   # (Optional) Auto-fix ScriptAnalyzer violations when available
   pwsh -NoProfile -Command "& .\Lint-Module.ps1" -Fix
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

```
ps-color-scripts-enhanced/
├── ColorScripts-Enhanced/
│   ├── ColorScripts-Enhanced.psd1    # Module manifest
│   ├── ColorScripts-Enhanced.psm1    # Module code
│   ├── ColorScriptCache.ps1          # Cache helper
│   ├── en-US/                         # Help files
│   │   ├── about_ColorScripts-Enhanced.help.txt
│   │   ├── Show-ColorScript.md
│   │   ├── Get-ColorScriptList.md
│   │   ├── Build-ColorScriptCache.md
│   │   └── Clear-ColorScriptCache.md
│   └── Scripts/                       # Colorscript files
│       ├── hearts.ps1
│       ├── mandelbrot-zoom.ps1
│       └── ...
├── build.ps1                          # Build script
├── README.md                          # Main documentation
├── RELEASENOTES.md                    # Version history
├── CONTRIBUTING.md                    # This file
├── LICENSE                            # MIT License
└── .gitignore                        # Git ignore rules
```

## Pull Request Process

1. Update documentation
2. Add release notes
3. Ensure all tests pass
4. Request review from maintainers
5. Address review feedback
6. Wait for approval and merge

## Version Numbering

We use date-based versioning: `YYYY.MM.DD.BuildNumber`

Example: `2025.10.09.1625`

## Questions?

- Open an issue for questions
- Check existing documentation
- Review closed issues for answers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions help make ColorScripts-Enhanced better for everyone!
