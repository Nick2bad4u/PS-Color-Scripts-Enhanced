@{
    SchemaVersion = 1

    Module = @{
        Name        = 'ColorScripts-Enhanced'
        Guid        = 'f77548d7-23eb-48ce-a6e0-f64b4758d995'
        HelpVersion = '2026.7.26.0'
        HelpInfoUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/ColorScripts-Enhanced/'
    }

    PlatyPS = @{
        Name            = 'Microsoft.PowerShell.PlatyPS'
        RequiredVersion = '1.0.3'
    }

    Cultures = @(
        'de'
        'en-US'
        'es'
        'fr'
        'it'
        'ja'
        'nl'
        'pt'
        'ru'
        'zh-CN'
    )

    # ZIP and CAB entries use this timestamp so repeated builds are byte-stable.
    SourceDateUtc = '2026-07-26T00:00:00Z'
}
