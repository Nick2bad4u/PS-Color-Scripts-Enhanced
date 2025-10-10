# Pester Tests for ColorScripts-Enhanced Module
# Run with: Invoke-Pester

BeforeAll {
    # Import the module (cross-platform path)
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath ".."
    $ModulePath = Join-Path -Path $ModulePath -ChildPath "ColorScripts-Enhanced"
    Import-Module $ModulePath -Force
}

Describe "ColorScripts-Enhanced Module" {

    Context "Module Loading" {
        It "Should load the module successfully" {
            $module = Get-Module ColorScripts-Enhanced
            $module | Should -Not -BeNullOrEmpty
        }

        It "Should have the correct GUID" {
            $module = Get-Module ColorScripts-Enhanced
            $module.GUID | Should -Be 'f77548d7-23eb-48ce-a6e0-f64b4758d995'
        }

        It "Should export Show-ColorScript function" {
            Get-Command Show-ColorScript -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It "Should export Get-ColorScriptList function" {
            Get-Command Get-ColorScriptList -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It "Should export Build-ColorScriptCache function" {
            Get-Command Build-ColorScriptCache -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It "Should export Clear-ColorScriptCache function" {
            Get-Command Clear-ColorScriptCache -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It "Should export Add-ColorScriptProfile function" {
            Get-Command Add-ColorScriptProfile -Module ColorScripts-Enhanced | Should -Not -BeNullOrEmpty
        }

        It "Should have 'scs' alias" {
            $alias = Get-Alias scs -ErrorAction SilentlyContinue
            $alias.Definition | Should -Be 'Show-ColorScript'
        }
    }

    Context "Module Manifest" {
        BeforeAll {
            $script:ManifestPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $script:ManifestPath = Join-Path -Path $script:ManifestPath -ChildPath "ColorScripts-Enhanced"
            $script:ManifestPath = Join-Path -Path $script:ManifestPath -ChildPath "ColorScripts-Enhanced.psd1"
            $script:Manifest = Test-ModuleManifest $script:ManifestPath -ErrorAction Stop
        }

        It "Should have a valid manifest" {
            $script:Manifest | Should -Not -BeNullOrEmpty
        }

        It "Should support PowerShell 5.1 and Core" {
            $script:Manifest.CompatiblePSEditions | Should -Contain 'Desktop'
            $script:Manifest.CompatiblePSEditions | Should -Contain 'Core'
        }

        It "Should have proper metadata" {
            $script:Manifest.Author | Should -Not -BeNullOrEmpty
            $script:Manifest.Description | Should -Not -BeNullOrEmpty
            $script:Manifest.ProjectUri | Should -Not -BeNullOrEmpty
        }
    }

    Context "Scripts Directory" {
        It "Should have Scripts directory" {
            $scriptsPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "ColorScripts-Enhanced"
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "Scripts"
            Test-Path $scriptsPath | Should -Be $true
        }

        It "Should contain colorscript files" {
            $scriptsPath = Join-Path -Path $PSScriptRoot -ChildPath ".."
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "ColorScripts-Enhanced"
            $scriptsPath = Join-Path -Path $scriptsPath -ChildPath "Scripts"
            $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1" |
            Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }
            $scripts.Count | Should -BeGreaterThan 0
        }
    }

    Context "Cache System" {
        BeforeAll {
            # Use cross-platform cache directory
            if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
                $script:CacheDir = Join-Path -Path $env:APPDATA -ChildPath "ColorScripts-Enhanced"
                $script:CacheDir = Join-Path -Path $script:CacheDir -ChildPath "cache"
            }
            elseif ($IsMacOS) {
                $script:CacheDir = Join-Path -Path $HOME -ChildPath "Library"
                $script:CacheDir = Join-Path -Path $script:CacheDir -ChildPath "Application Support"
                $script:CacheDir = Join-Path -Path $script:CacheDir -ChildPath "ColorScripts-Enhanced"
                $script:CacheDir = Join-Path -Path $script:CacheDir -ChildPath "cache"
            }
            else {
                $xdgCache = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path -Path $HOME -ChildPath ".cache" }
                $script:CacheDir = Join-Path -Path $xdgCache -ChildPath "ColorScripts-Enhanced"
            }
        }

        It "Should create cache directory" {
            Test-Path $script:CacheDir | Should -Be $true
        }

        It "Should build cache for a script" {
            $result = Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"

            $result | Should -Not -BeNullOrEmpty
            $result[0].Status | Should -BeIn @('Updated', 'SkippedUpToDate')
            Test-Path $cacheFile | Should -Be $true
        }

        It "Should skip cache rebuild when up-to-date" {
            Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            [System.IO.File]::SetLastWriteTime($cacheFile, (Get-Date).AddHours(1))

            $result = Build-ColorScriptCache -Name "bars" -ErrorAction Stop
            $result[0].Status | Should -Be 'SkippedUpToDate'
        }

        It "Should force cache rebuild even when cache is newer" {
            Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            [System.IO.File]::SetLastWriteTime($cacheFile, (Get-Date).AddHours(1))

            $result = Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop
            $result[0].Status | Should -Be 'Updated'
        }

        It "Should write UTF-8 cache without BOM" {
            Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            $bytes = [System.IO.File]::ReadAllBytes($cacheFile)

            if ($bytes.Length -ge 3) {
                $bytes[0] | Should -Not -Be 0xEF
                $bytes[1] | Should -Not -Be 0xBB
                $bytes[2] | Should -Not -Be 0xBF
            }
        }

        It "Should clear specific cache" {
            Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null
            $result = Clear-ColorScriptCache -Name "bars" -Confirm:$false
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"

            $result[0].Status | Should -BeIn @('Removed', 'Missing')
            Test-Path $cacheFile | Should -Be $false
        }

        It "Should support DryRun cache clearing" {
            Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop | Out-Null
            $dryRun = Clear-ColorScriptCache -Name "bars" -DryRun
            $dryRun[0].Status | Should -Be 'DryRun'
            $cacheFile = Join-Path -Path $script:CacheDir -ChildPath "bars.cache"
            Test-Path $cacheFile | Should -Be $true
        }
    }

    Context "Show-ColorScript Function" {
        It "Should have proper help" {
            $help = Get-Help Show-ColorScript
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -Name parameter" {
            { Show-ColorScript -Name "bars" -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support -List parameter" {
            { Show-ColorScript -List -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support -NoCache parameter" {
            { Show-ColorScript -Name "bars" -NoCache -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should handle non-existent script gracefully" {
            { Show-ColorScript -Name "nonexistent-script-xyz" } | Should -Not -Throw
        }
    }

    Context "Get-ColorScriptList Function" {
        It "Should have proper help" {
            $help = Get-Help Get-ColorScriptList
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should execute without error" {
            { Get-ColorScriptList } | Should -Not -Throw
        }
    }

    Context "Metadata and Filtering" {
        It "Should return structured objects when using -AsObject" {
            $records = Get-ColorScriptList -AsObject
            $records | Should -Not -BeNullOrEmpty
            $records[0] | Should -BeOfType [pscustomobject]
            $records[0].Metadata | Should -Not -BeNullOrEmpty
        }

        It "Should filter by category" {
            $records = Get-ColorScriptList -AsObject -Category 'Patterns'
            $records | Should -Not -BeNullOrEmpty
            $records | ForEach-Object {
                $_.Categories | ForEach-Object { $_.ToLowerInvariant() } | Should -Contain 'patterns'
            }
        }

        It "Should filter by tag" {
            $records = Get-ColorScriptList -AsObject -Tag 'recommended'
            $records | Should -Not -BeNullOrEmpty
            $records | ForEach-Object {
                $_.Tags | ForEach-Object { $_.ToLowerInvariant() } | Should -Contain 'recommended'
            }
        }

        It "Show-ColorScript -PassThru should return metadata" {
            $record = Show-ColorScript -Name 'bars' -NoCache -PassThru
            $record.Name | Should -Be 'bars'
            $record.Metadata | Should -Not -BeNullOrEmpty
        }

        It "Should provide metadata for every colorscript" {
            $records = Get-ColorScriptList -AsObject
            $records.Count | Should -BeGreaterThan 0
            $records | ForEach-Object { $_.Metadata | Should -Not -BeNullOrEmpty }
        }
    }

    Context "Build-ColorScriptCache Function" {
        It "Should have proper help" {
            $help = Get-Help Build-ColorScriptCache
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -Name parameter" {
            { Build-ColorScriptCache -Name "bars" -ErrorAction Stop } | Should -Not -Throw
        }

        It "Should support -Force parameter" {
            { Build-ColorScriptCache -Name "bars" -Force -ErrorAction Stop } | Should -Not -Throw
        }
    }

    Context "Clear-ColorScriptCache Function" {
        It "Should have proper help" {
            $help = Get-Help Clear-ColorScriptCache
            $help.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "Should support -WhatIf" {
            { Clear-ColorScriptCache -All -WhatIf } | Should -Not -Throw
        }

        It "Should support -Confirm:$false" {
            { Clear-ColorScriptCache -Name "bars" -Confirm:$false } | Should -Not -Throw
        }

        It "Should support custom cache path" {
            $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsCache_" + [guid]::NewGuid())
            $null = New-Item -ItemType Directory -Path $tempDir
            $tempCache = Join-Path $tempDir 'bars.cache'
            Set-Content -Path $tempCache -Value 'cache-data' -Encoding utf8

            try {
                $result = Clear-ColorScriptCache -Name 'bars' -Path $tempDir -Confirm:$false
                $result[0].Status | Should -Be 'Removed'
                Test-Path $tempCache | Should -BeFalse
            }
            finally {
                if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
            }
        }
    }

    Context "Help Documentation" {
        It "Should have about help topic" {
            $help = Get-Help about_ColorScripts-Enhanced -ErrorAction SilentlyContinue
            $help | Should -Not -BeNullOrEmpty
        }

        It "Show-ColorScript should have examples" {
            $help = Get-Help Show-ColorScript -Examples
            $help.Examples | Should -Not -BeNullOrEmpty
        }

        It "All functions should have synopsis" {
            $commands = @('Show-ColorScript', 'Get-ColorScriptList', 'Build-ColorScriptCache', 'Clear-ColorScriptCache', 'Add-ColorScriptProfile')
            foreach ($cmd in $commands) {
                $help = Get-Help $cmd
                $help.Synopsis | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Describe "Add-ColorScriptProfile Function" {
    It "Should have proper help" {
        $help = Get-Help Add-ColorScriptProfile
        $help.Synopsis | Should -Not -BeNullOrEmpty
    }

    It "Should create profile snippet at custom path" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfile_" + [guid]::NewGuid() + '.ps1')
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

        try {
            $result = Add-ColorScriptProfile -Path $tempProfile
            $result.Changed | Should -BeTrue

            Test-Path $tempProfile | Should -BeTrue

            $content = Get-Content $tempProfile -Raw
            $content | Should -Match 'Import-Module\s+ColorScripts-Enhanced'
            $content | Should -Match 'Show-ColorScript'
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }

    It "Should respect SkipStartupScript" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfileSkip_" + [guid]::NewGuid() + '.ps1')
        if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }

        try {
            Add-ColorScriptProfile -Path $tempProfile -SkipStartupScript | Out-Null

            $content = Get-Content $tempProfile -Raw
            $content | Should -Match 'Import-Module\s+ColorScripts-Enhanced'
            $content | Should -Not -Match 'Show-ColorScript'
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }

    It "Should avoid duplicates unless forced" {
        $tempProfile = Join-Path ([System.IO.Path]::GetTempPath()) ("ColorScriptsProfileDup_" + [guid]::NewGuid() + '.ps1')
        $initialContent = 'Import-Module ColorScripts-Enhanced'
        Set-Content -Path $tempProfile -Value $initialContent -Encoding utf8

        try {
            $result = Add-ColorScriptProfile -Path $tempProfile
            $result.Changed | Should -BeFalse

            $content = Get-Content $tempProfile -Raw
            ($content -split [Environment]::NewLine | Where-Object { $_ -match 'Import-Module\s+ColorScripts-Enhanced' }).Count | Should -Be 1

            $forceResult = Add-ColorScriptProfile -Path $tempProfile -Force
            $forceResult.Changed | Should -BeTrue

            $updatedContent = Get-Content $tempProfile -Raw
            (($updatedContent -split [Environment]::NewLine) | Where-Object { $_ -match '# Added by ColorScripts-Enhanced' }).Count | Should -Be 1
            (($updatedContent -split [Environment]::NewLine) | Where-Object { $_ -match 'Import-Module\s+ColorScripts-Enhanced' }).Count | Should -Be 1
        }
        finally {
            if (Test-Path $tempProfile) { Remove-Item $tempProfile -Force }
        }
    }
}

Describe "Script Quality" {
    Context "Script Files" {
        BeforeAll {
            $scriptsPath = "$PSScriptRoot\..\ColorScripts-Enhanced\Scripts"
            $script:TestScripts = (Get-ChildItem $scriptsPath -Filter "*.ps1" |
                Where-Object { $_.Name -ne 'ColorScriptCache.ps1' } |
                Select-Object -First 5)
        }

        It "Scripts should use UTF-8 encoding" {
            foreach ($script in $script:TestScripts) {
                { Get-Content $script.FullName -ErrorAction Stop } | Should -Not -Throw
            }
        }

        It "Scripts should have cache check header" {
            foreach ($script in $script:TestScripts) {
                $content = Get-Content $script.FullName -Raw
                if ($content -notmatch 'Write-Host') { continue } # Skip empty/non-output scripts
                $content | Should -Match 'ColorScriptCache'
            }
        }
    }
}

Describe "Test-AllColorScripts Script" {
    BeforeAll {
        $script:RunnerPath = Join-Path -Path $PSScriptRoot -ChildPath "..\ColorScripts-Enhanced\Test-AllColorScripts.ps1"
    }

    It "Should return structured results for filtered run" {
        $results = & $script:RunnerPath -Filter 'bars' -Delay 0 -SkipErrors
        $results | Should -Not -BeNullOrEmpty
        $results[0].Name | Should -Be 'bars'
        $results[0] | Should -BeOfType [pscustomobject]
    }

    It "Should support parallel execution when available" {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            $results = & $script:RunnerPath -Filter 'bars' -Delay 0 -SkipErrors -Parallel -ThrottleLimit 1
            $results | Should -Not -BeNullOrEmpty
            $results[0].Name | Should -Be 'bars'
        }
        else {
            Set-ItResult -Skipped -Because "Parallel mode requires PowerShell 7 or later."
        }
    }
}

AfterAll {
    Clear-ColorScriptCache -Name 'bars' -Confirm:$false | Out-Null
}
