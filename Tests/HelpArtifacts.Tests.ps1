Set-StrictMode -Version Latest

Describe 'External and Updatable Help artifacts' {
    BeforeAll {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath '..')).ProviderPath
        $script:ModuleRoot = Join-Path -Path $script:RepoRoot -ChildPath 'ColorScripts-Enhanced'
        $script:PublishRoot = Join-Path -Path $script:RepoRoot -ChildPath 'docs/ColorScripts-Enhanced'
        $script:ConfigurationPath = Join-Path -Path $script:RepoRoot -ChildPath 'Help.Build.psd1'
        $script:UpdatableHelpBuilder = Join-Path -Path $script:RepoRoot -ChildPath 'scripts/Build-UpdatableHelp.ps1'
        $script:Configuration = Import-PowerShellDataFile -LiteralPath $script:ConfigurationPath
        $script:ModuleName = [string]$script:Configuration.Module.Name
        $script:ModuleGuid = [guid][string]$script:Configuration.Module.Guid
        $script:HelpVersion = [version][string]$script:Configuration.Module.HelpVersion
        $script:Cultures = @($script:Configuration.Cultures)
        $script:ExpectedCommands = @(
            'Add-ColorScriptProfile'
            'Clear-ColorScriptCache'
            'Export-ColorScriptMetadata'
            'Get-ColorScriptConfiguration'
            'Get-ColorScriptList'
            'New-ColorScript'
            'New-ColorScriptCache'
            'Reset-ColorScriptConfiguration'
            'Set-ColorScriptConfiguration'
            'Show-ColorScript'
        )
        $script:MetadataDate = ([datetimeoffset]::Parse(
                $script:Configuration.SourceDateUtc
            )).UtcDateTime.ToString('MM/dd/yyyy', [cultureinfo]::InvariantCulture)
        $script:ExpectedNoNotes = @{
            'en-US' = 'None.'
            de      = 'Keine.'
            es      = 'Ninguna.'
            fr      = 'Aucune.'
            it      = 'Nessuna.'
            ja      = 'ありません。'
            nl      = 'Geen.'
            pt      = 'Nenhuma.'
            ru      = 'Нет.'
            'zh-CN' = '无。'
        }
    }

    It 'pins the module identity, culture set, source date, and PlatyPS serializer' {
        $script:Configuration.SchemaVersion | Should -Be 1
        $script:Configuration.PlatyPS.Name | Should -BeExactly 'Microsoft.PowerShell.PlatyPS'
        $script:Configuration.PlatyPS.RequiredVersion | Should -BeExactly '1.0.3'
        $script:Cultures | Should -BeExactly @('de', 'en-US', 'es', 'fr', 'it', 'ja', 'nl', 'pt', 'ru', 'zh-CN')
        ([datetimeoffset]::Parse($script:Configuration.SourceDateUtc)).Offset | Should -Be ([timespan]::Zero)

        $manifest = Import-PowerShellDataFile -LiteralPath (
            Join-Path -Path $script:ModuleRoot -ChildPath "$($script:ModuleName).psd1"
        )
        [string]$manifest.Guid | Should -BeExactly $script:ModuleGuid.ToString()
        [string]$manifest.HelpInfoURI | Should -BeExactly $script:Configuration.Module.HelpInfoUri
    }

    It 'keeps every generated MAML example structured and free of PlatyPS fence sentinels' {
        $referenceParameterNames = @{}
        [xml]$referenceDocument = Get-Content -LiteralPath (
            Join-Path -Path $script:ModuleRoot -ChildPath "en-US/$($script:ModuleName)-help.xml"
        ) -Raw
        foreach ($command in $referenceDocument.SelectNodes(
                "//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"
            )) {
            $commandName = $command.SelectSingleNode(
                "./*[local-name()='details']/*[local-name()='name']"
            ).InnerText
            $referenceParameterNames[$commandName] = @(
                $command.SelectNodes(
                    "./*[local-name()='parameters']/*[local-name()='parameter']/*[local-name()='name']"
                ).InnerText |
                    Sort-Object -Unique
            )
        }

        foreach ($culture in $script:Cultures) {
            $cultureRoot = Join-Path -Path $script:ModuleRoot -ChildPath $culture
            $mamlPath = Join-Path -Path $cultureRoot -ChildPath "$($script:ModuleName)-help.xml"
            $content = [System.IO.File]::ReadAllText($mamlPath)
            $content | Should -Not -Match '```' -Because $mamlPath
            $content.Contains([char]0x80) | Should -BeFalse -Because $mamlPath

            [xml]$document = $content
            $commands = @($document.SelectNodes(
                    "//*[local-name()='command' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"
                ))
            $examples = @($document.SelectNodes(
                    "//*[local-name()='example' and namespace-uri()='http://schemas.microsoft.com/maml/dev/command/2004/10']"
                ))
            $emptyCode = @($document.SelectNodes(
                    "//*[local-name()='example']/*[local-name()='code' and namespace-uri()='http://schemas.microsoft.com/maml/dev/2004/10' and not(normalize-space())]"
                ))
            $commands | Should -HaveCount 10 -Because $mamlPath
            $commandNames = @(
                foreach ($command in $commands) {
                    $command.SelectSingleNode(
                        "./*[local-name()='details']/*[local-name()='name']"
                    ).InnerText
                }
            )
            @($commandNames | Sort-Object) |
                Should -BeExactly $script:ExpectedCommands -Because $mamlPath
            foreach ($command in $commands) {
                $commandName = $command.SelectSingleNode(
                    "./*[local-name()='details']/*[local-name()='name']"
                ).InnerText
                $synopsis = @(
                    $command.SelectNodes(
                        "./*[local-name()='details']/*[local-name()='description']/*[local-name()='para']"
                    ).InnerText
                ) -join ' '
                $synopsis.Trim() | Should -Not -BeNullOrEmpty -Because "${mamlPath}:$commandName"
                $parameterNames = @(
                    $command.SelectNodes(
                        "./*[local-name()='parameters']/*[local-name()='parameter']/*[local-name()='name']"
                    ).InnerText |
                        Sort-Object -Unique
                )
                $parameterNames |
                    Should -BeExactly $referenceParameterNames[$commandName] -Because (
                        "$mamlPath must retain the en-US parameter contract for $commandName"
                    )
            }
            $examples.Count | Should -BeGreaterThan 0 -Because $mamlPath
            $emptyCode | Should -BeNullOrEmpty -Because $mamlPath
        }
    }

    It 'keeps empty notes localized and avoids a host-version-specific common parameter inventory' {
        foreach ($culture in $script:Cultures) {
            $cultureRoot = Join-Path -Path $script:ModuleRoot -ChildPath $culture
            $markdownPath = Join-Path `
                -Path $cultureRoot `
                -ChildPath 'Export-ColorScriptMetadata.md'
            $content = [System.IO.File]::ReadAllText($markdownPath)
            $notes = [regex]::Match(
                $content,
                '(?ms)^## NOTES\s*\r?\n(?<Body>.*?)(?=^## |\z)'
            ).Groups['Body'].Value.Trim()
            $commonParameters = [regex]::Match(
                $content,
                '(?ms)^### CommonParameters\s*\r?\n(?<Body>.*?)(?=^## |\z)'
            ).Groups['Body'].Value.Trim()

            $notes | Should -BeExactly $script:ExpectedNoNotes[$culture] -Because $markdownPath
            $commonParameters | Should -Match '\[about_CommonParameters\]\(https://go\.microsoft\.com/fwlink/\?LinkID=113216\)' -Because $markdownPath
            $commonParameters | Should -Not -Match '(?m)^-(?:Debug|ProgressAction)' -Because $markdownPath

            foreach ($topic in Get-ChildItem -LiteralPath $cultureRoot -File -Filter '*.md') {
                $topicContent = [System.IO.File]::ReadAllText($topic.FullName)
                $topicContent | Should -Match (
                    '(?m)^ms\.date: {0}$' -f [regex]::Escape($script:MetadataDate)
                ) -Because $topic.FullName
            }
        }
    }

    It 'publishes one multi-culture HelpInfo file and one ZIP/CAB pair per culture' {
        $helpInfoName = '{0}_{1}_HelpInfo.xml' -f $script:ModuleName, $script:ModuleGuid
        $helpInfoPath = Join-Path -Path $script:PublishRoot -ChildPath $helpInfoName
        [xml]$helpInfo = Get-Content -LiteralPath $helpInfoPath -Raw
        $namespace = New-Object System.Xml.XmlNamespaceManager($helpInfo.NameTable)
        $namespace.AddNamespace('help', 'http://schemas.microsoft.com/powershell/help/2010/05')
        $cultureNodes = @($helpInfo.SelectNodes('//help:UICulture', $namespace))

        $cultureNodes | Should -HaveCount $script:Cultures.Count
        @($cultureNodes.UICultureName) | Should -BeExactly $script:Cultures
        foreach ($cultureNode in $cultureNodes) {
            [version]$cultureNode.UICultureVersion | Should -Be $script:HelpVersion
        }

        foreach ($culture in $script:Cultures) {
            $baseName = '{0}_{1}_{2}_HelpContent' -f $script:ModuleName, $script:ModuleGuid, $culture
            foreach ($extension in @('.zip', '.cab')) {
                $artifact = Get-Item -LiteralPath (Join-Path -Path $script:PublishRoot -ChildPath "$baseName$extension")
                $artifact.Length | Should -BeGreaterThan 0
                if ($extension -eq '.zip') {
                    $archive = [System.IO.Compression.ZipFile]::OpenRead($artifact.FullName)
                    try {
                        @($archive.Entries.FullName) |
                            Should -BeExactly @(
                                "about_$($script:ModuleName).help.txt"
                                "$($script:ModuleName)-help.xml"
                            ) -Because $artifact.FullName
                        foreach ($entry in $archive.Entries) {
                            $entry.Length | Should -BeGreaterThan 0 -Because "$($artifact.FullName):$($entry.FullName)"
                            $reader = New-Object System.IO.StreamReader(
                                $entry.Open(),
                                (New-Object System.Text.UTF8Encoding($false, $true)),
                                $true
                            )
                            try {
                                $packagedContent = $reader.ReadToEnd()
                            }
                            finally {
                                $reader.Dispose()
                            }
                            $sourcePath = Join-Path `
                                -Path (Join-Path -Path $script:ModuleRoot -ChildPath $culture) `
                                -ChildPath $entry.FullName
                            $expectedContent = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n?", "`n"
                            $packagedContent |
                                Should -BeExactly $expectedContent -Because (
                                    "$($artifact.FullName):$($entry.FullName) must contain canonical LF text"
                                )
                        }
                    }
                    finally {
                        $archive.Dispose()
                    }
                }
                else {
                    $signature = [System.Text.Encoding]::ASCII.GetString(
                        [System.IO.File]::ReadAllBytes($artifact.FullName),
                        0,
                        4
                    )
                    $signature | Should -BeExactly 'MSCF' -Because $artifact.FullName
                }
            }
        }

        @(Get-ChildItem -LiteralPath $script:ModuleRoot -Recurse -File -Filter '*_HelpInfo.xml') |
            Should -BeNullOrEmpty -Because 'the module has one remote HelpInfo document, not one conflicting file per culture'
    }

    It 'reconciles cross-platform artifacts while preserving current cabinets and unrelated files' {
        $outputPath = Join-Path -Path $TestDrive -ChildPath 'cross-platform-help'
        $null = New-Item -ItemType Directory -Path $outputPath
        $currentCabinetPaths = @(
            foreach ($culture in $script:Cultures) {
                $currentCabinetName = '{0}_{1}_{2}_HelpContent.cab' -f (
                    $script:ModuleName,
                    $script:ModuleGuid,
                    $culture
                )
                $currentCabinetPath = Join-Path -Path $outputPath -ChildPath $currentCabinetName
                Set-Content -LiteralPath $currentCabinetPath -Value "preserved cabinet: $culture"
                $currentCabinetPath
            }
        )
        & $script:UpdatableHelpBuilder `
            -ModulePath $script:ModuleRoot `
            -ConfigurationPath $script:ConfigurationPath `
            -OutputPath $outputPath `
            -SkipCabinet `
            -Confirm:$false

        $staleBaseName = '{0}_{1}_removed-culture_HelpContent' -f (
            $script:ModuleName,
            $script:ModuleGuid
        )
        $staleZipPath = Join-Path -Path $outputPath -ChildPath "$staleBaseName.zip"
        $staleCabinetPath = Join-Path -Path $outputPath -ChildPath "$staleBaseName.cab"
        $missingCabinetPath = $currentCabinetPaths[0]
        $missingCabinetContent = Get-Content -LiteralPath $missingCabinetPath -Raw
        Remove-Item -LiteralPath $missingCabinetPath
        {
            & $script:UpdatableHelpBuilder `
                -ModulePath $script:ModuleRoot `
                -ConfigurationPath $script:ConfigurationPath `
                -OutputPath $outputPath `
                -SkipCabinet `
                -Check
        } | Should -Throw '*Published Updatable Help file set is stale*'
        Set-Content -LiteralPath $missingCabinetPath -Value $missingCabinetContent -NoNewline

        if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
            $wrongCaseCabinetPath = Join-Path `
                -Path $outputPath `
                -ChildPath ([System.IO.Path]::GetFileName($missingCabinetPath).ToUpperInvariant())
            Move-Item -LiteralPath $missingCabinetPath -Destination $wrongCaseCabinetPath
            {
                & $script:UpdatableHelpBuilder `
                    -ModulePath $script:ModuleRoot `
                    -ConfigurationPath $script:ConfigurationPath `
                    -OutputPath $outputPath `
                    -SkipCabinet `
                    -Check
            } | Should -Throw '*Published Updatable Help file set is stale*'
            Move-Item -LiteralPath $wrongCaseCabinetPath -Destination $missingCabinetPath
        }

        Set-Content -LiteralPath $staleCabinetPath -Value 'stale cabinet'
        {
            & $script:UpdatableHelpBuilder `
                -ModulePath $script:ModuleRoot `
                -ConfigurationPath $script:ConfigurationPath `
                -OutputPath $outputPath `
                -SkipCabinet `
                -Check
        } | Should -Throw '*Published Updatable Help file set is stale*'

        Set-Content -LiteralPath $staleZipPath -Value 'stale zip'

        & $script:UpdatableHelpBuilder `
            -ModulePath $script:ModuleRoot `
            -ConfigurationPath $script:ConfigurationPath `
            -OutputPath $outputPath `
            -SkipCabinet `
            -Confirm:$false

        $staleZipPath | Should -Not -Exist
        $staleCabinetPath | Should -Not -Exist
        foreach ($currentCabinetPath in $currentCabinetPaths) {
            $currentCabinetPath | Should -Exist
        }
        {
            & $script:UpdatableHelpBuilder `
                -ModulePath $script:ModuleRoot `
                -ConfigurationPath $script:ConfigurationPath `
                -OutputPath $outputPath `
                -SkipCabinet `
                -Check
        } | Should -Not -Throw

        $unrelatedPath = Join-Path -Path $outputPath -ChildPath 'README.txt'
        Set-Content -LiteralPath $unrelatedPath -Value 'unrelated file'
        {
            & $script:UpdatableHelpBuilder `
                -ModulePath $script:ModuleRoot `
                -ConfigurationPath $script:ConfigurationPath `
                -OutputPath $outputPath `
                -SkipCabinet `
                -Confirm:$false
        } | Should -Throw '*Published Updatable Help file set is stale*'
        $unrelatedPath | Should -Exist
    }

    It 'removes stale cabinets when the platform can regenerate them' -Skip:(
        $null -eq (Get-Command -Name makecab.exe -CommandType Application -ErrorAction SilentlyContinue)
    ) {
        $outputPath = Join-Path -Path $TestDrive -ChildPath 'complete-help'
        $staleBaseName = '{0}_{1}_removed-culture_HelpContent' -f (
            $script:ModuleName,
            $script:ModuleGuid
        )
        $null = New-Item -ItemType Directory -Path $outputPath
        $staleCabinetPath = Join-Path -Path $outputPath -ChildPath "$staleBaseName.cab"
        Set-Content -LiteralPath $staleCabinetPath -Value 'stale cabinet'

        & $script:UpdatableHelpBuilder `
            -ModulePath $script:ModuleRoot `
            -ConfigurationPath $script:ConfigurationPath `
            -OutputPath $outputPath `
            -Confirm:$false

        $staleCabinetPath | Should -Not -Exist
        {
            & $script:UpdatableHelpBuilder `
                -ModulePath $script:ModuleRoot `
                -ConfigurationPath $script:ConfigurationPath `
                -OutputPath $outputPath `
                -Check
        } | Should -Not -Throw
    }
}
