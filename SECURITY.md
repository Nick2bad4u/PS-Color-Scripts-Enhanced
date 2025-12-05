# Security Policy

## Supported Versions

We actively support the latest version of ColorScripts-Enhanced.

| Version  | Supported            |
| -------- | -------------------- |
| Latest   | :white\_check\_mark: |
| < Latest | :x:                  |

## Reporting a Vulnerability

If you discover a security vulnerability within ColorScripts-Enhanced, please send an email to the repository owner or open a private security advisory on GitHub.

## Please do not open public issues for security vulnerabilities

### What to Include

- Type of issue (e.g., code injection, privilege escalation)
- Full paths of source file(s) related to the issue
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Resolution:** Varies based on severity and complexity

We will acknowledge your email and work with you to understand and resolve the issue promptly.

## Security Best Practices for Users

1. **Keep Updated:** Always use the latest version from the PowerShell Gallery
2. **Verify Sources:** Only install from trusted sources (PowerShell Gallery)
3. **Review Code:** This is open source - review the code before installation
4. **Sandboxing:** Consider testing in isolated environments first
5. **Profile Security:** Be cautious when adding to PowerShell profiles

## Known Security Considerations

- **Script Execution:** This module executes PowerShell scripts to display ANSI art
- **Cache Storage:** Cache files are stored in user's AppData directory
- **File System Access:** Module reads/writes to cache directory only
- **No Network Access:** Module does not make network requests
- **No Sensitive Data:** Module does not handle or store sensitive information

## Scope

This security policy applies to:

- ColorScripts-Enhanced PowerShell module
- Associated scripts and tools in this repository
- Documentation and configuration files

Out of scope:

- Third-party dependencies (report to their respective maintainers)
- Issues in PowerShell itself
- Terminal emulator security

## Attribution

We appreciate responsible disclosure and will credit security researchers who report valid vulnerabilities (unless you prefer to remain anonymous).
