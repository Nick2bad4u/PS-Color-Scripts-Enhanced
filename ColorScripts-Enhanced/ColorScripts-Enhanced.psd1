@{
    RootModule        = 'ColorScripts-Enhanced.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author            = 'Nick'
    CompanyName       = 'Community'
    Copyright         = '(c) 2025. All rights reserved.'
    Description       = 'Enhanced PowerShell ColorScripts with high-performance caching system. Display beautiful ANSI art in your terminal with 6-19x faster load times.'
    PowerShellVersion = '5.1'

    # Functions to export
    FunctionsToExport = @(
        'Show-ColorScript',
        'Get-ColorScriptList',
        'Build-ColorScriptCache',
        'Clear-ColorScriptCache'
    )

    # Cmdlets to export
    CmdletsToExport   = @()

    # Variables to export
    VariablesToExport = @()

    # Aliases to export
    AliasesToExport   = @('scs')

    # Private data
    PrivateData       = @{
        PSData = @{
            Tags         = @('ColorScripts', 'ANSI', 'Terminal', 'Art', 'Cache', 'Performance')
            LicenseUri   = 'https://github.com/Nick2bad4u/ps-color-scripts/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/Nick2bad4u/ps-color-scripts'
            IconUri      = ''
            ReleaseNotes = @'
Version 1.0.0:
- Enhanced caching system with OS-wide cache in AppData
- 6-19x performance improvement
- Cache stored in centralized location
- Works from any directory
- 185+ beautiful colorscripts included
'@
        }
    }
}
