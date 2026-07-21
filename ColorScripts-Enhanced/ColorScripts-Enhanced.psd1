#
# Module manifest for module 'ColorScripts-Enhanced'
@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'ColorScripts-Enhanced.psm1'

    # Version number of this module.
    ModuleVersion = '2026.7.20.2250'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = 'f77548d7-23eb-48ce-a6e0-f64b4758d995'

    # Author of this module
    Author = 'Nick2bad4u'

    # Company or vendor of this module
    CompanyName = 'Community'

    # Copyright statement for this module
    Copyright = 'Copyright (c) 2024-2026 Nick2bad4u. Released under the Unlicense.'

    # Description of the functionality provided by this module
    Description = 'Displays the bundled ANSI-art colorscript collection with metadata filtering, localization, persistent configuration, and selective output caching for eligible renderers. Supports Windows PowerShell 5.1 and PowerShell 7+ on Windows, macOS, and Linux.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Show-ColorScript'
        'Get-ColorScriptList'
        'New-ColorScriptCache'
        'Clear-ColorScriptCache'
        'Add-ColorScriptProfile'
        'Get-ColorScriptConfiguration'
        'Set-ColorScriptConfiguration'
        'Reset-ColorScriptConfiguration'
        'Export-ColorScriptMetadata'
        'New-ColorScript'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @('scs', 'Update-ColorScriptCache', 'Build-ColorScriptCache')

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                'ColorScripts'
                'ANSI'
                'Terminal'
                'Art'
                'Cache'
                'Performance'
                'PowerShell'
                'Startup'
                'Terminal-Startup'
                'ANSI-Art'
                'Colorful-Terminal'
                'PowerShell-Art'
                'Fancy-Terminal'
                'Terminal-Enhancement'
                'Beautiful-Terminal'
                'Terminal-Colors'
                'PowerShell-Scripts'
                'Terminal-Art'
                'Colorful-Scripts'
                'Enhanced-Terminal'
                'Terminal-Visuals'
                'PowerShell-Module'
                'Colorful-Output'
                'Terminal-Themes'
                'PSEdition_Desktop'
                'PSEdition_Core'
                'Windows'
                'Linux'
                'MacOS'
                'Localization'
                'Internationalization'
                'Spanish'
                'Español'
                'Multilingual'
            )

            # A URL to the license for this module.
            LicenseUri = 'https://licenses.nuget.org/Unlicense'

            # License expression or path to license file
            License = 'Unlicense'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Nick2bad4u/ps-color-scripts-enhanced'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/Nick2bad4u/ps-color-scripts-enhanced/main/docs/colorscripts-icon.png'

            # ReleaseNotes of this module
            ReleaseNotes = @'
Release history: https://github.com/Nick2bad4u/ps-color-scripts-enhanced/releases
Changelog: https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/CHANGELOG.md
'@

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }

    # HelpInfo URI of this module
    HelpInfoURI = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/ColorScripts-Enhanced/'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
}
