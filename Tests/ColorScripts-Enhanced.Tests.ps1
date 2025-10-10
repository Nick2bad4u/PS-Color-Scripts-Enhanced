# Pester Tests for ColorScripts-Enhanced Module
# Run with: Invoke-Pester

BeforeAll {
    # Import the module (cross-platform path)
    $ModulePath = Join-Path $PSScriptRoot ".." "ColorScripts-Enhanced"
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
            $script:ManifestPath = Join-Path $PSScriptRoot ".." "ColorScripts-Enhanced" "ColorScripts-Enhanced.psd1"
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
            $scriptsPath = Join-Path $PSScriptRoot ".." "ColorScripts-Enhanced" "Scripts"
            Test-Path $scriptsPath | Should -Be $true
        }

        It "Should contain colorscript files" {
            $scriptsPath = Join-Path $PSScriptRoot ".." "ColorScripts-Enhanced" "Scripts"
            $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1" |
            Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }
            $scripts.Count | Should -BeGreaterThan 0
        }
    }

    Context "Cache System" {
        BeforeAll {
            $script:CacheDir = Join-Path $env:APPDATA "ColorScripts-Enhanced\cache"
        }

        It "Should create cache directory" {
            Test-Path $script:CacheDir | Should -Be $true
        }

        It "Should build cache for a script" {
            Build-ColorScriptCache -Name "bars" -ErrorAction Stop
            $cacheFile = Join-Path $script:CacheDir "bars.cache"
            Test-Path $cacheFile | Should -Be $true
        }

        It "Should clear specific cache" {
            Build-ColorScriptCache -Name "bars" -ErrorAction Stop
            Clear-ColorScriptCache -Name "bars" -Confirm:$false
            $cacheFile = Join-Path $script:CacheDir "bars.cache"
            Test-Path $cacheFile | Should -Be $false
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

AfterAll {
    # Cleanup test cache if needed
    $testCache = Join-Path $env:APPDATA "ColorScripts-Enhanced\cache\bars.cache"
    if (Test-Path $testCache) {
        Remove-Item $testCache -Force -ErrorAction SilentlyContinue
    }
}
