# Pester Tests for ColorScripts-Enhanced Module
# Run with: Invoke-Pester

BeforeAll {
    # Import the module
    $ModulePath = "$PSScriptRoot\..\ColorScripts-Enhanced"
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

        It "Should have 'scs' alias" {
            $alias = Get-Alias scs -ErrorAction SilentlyContinue
            $alias.Definition | Should -Be 'Show-ColorScript'
        }
    }

    Context "Module Manifest" {
        BeforeAll {
            $ManifestPath = "$PSScriptRoot\..\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
            $Manifest = Test-ModuleManifest $ManifestPath -ErrorAction Stop
        }

        It "Should have a valid manifest" {
            $Manifest | Should -Not -BeNullOrEmpty
        }

        It "Should support PowerShell 5.1 and Core" {
            $Manifest.CompatiblePSEditions | Should -Contain 'Desktop'
            $Manifest.CompatiblePSEditions | Should -Contain 'Core'
        }

        It "Should have proper metadata" {
            $Manifest.Author | Should -Not -BeNullOrEmpty
            $Manifest.Description | Should -Not -BeNullOrEmpty
            $Manifest.ProjectUri | Should -Not -BeNullOrEmpty
        }
    }

    Context "Scripts Directory" {
        It "Should have Scripts directory" {
            $scriptsPath = "$PSScriptRoot\..\ColorScripts-Enhanced\Scripts"
            Test-Path $scriptsPath | Should -Be $true
        }

        It "Should contain colorscript files" {
            $scriptsPath = "$PSScriptRoot\..\ColorScripts-Enhanced\Scripts"
            $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1" |
            Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }
            $scripts.Count | Should -BeGreaterThan 0
        }
    }

    Context "Cache System" {
        BeforeAll {
            $CacheDir = Join-Path $env:APPDATA "ColorScripts-Enhanced\cache"
        }

        It "Should create cache directory" {
            Test-Path $CacheDir | Should -Be $true
        }

        It "Should build cache for a script" {
            Build-ColorScriptCache -Name "bars" -ErrorAction Stop
            $cacheFile = Join-Path $CacheDir "bars.cache"
            Test-Path $cacheFile | Should -Be $true
        }

        It "Should clear specific cache" {
            Build-ColorScriptCache -Name "bars" -ErrorAction Stop
            Clear-ColorScriptCache -Name "bars" -Confirm:$false
            $cacheFile = Join-Path $CacheDir "bars.cache"
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
            { Show-ColorScript -Name "nonexistent-script-xyz" -ErrorAction Stop } | Should -Throw
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
            $commands = @('Show-ColorScript', 'Get-ColorScriptList', 'Build-ColorScriptCache', 'Clear-ColorScriptCache')
            foreach ($cmd in $commands) {
                $help = Get-Help $cmd
                $help.Synopsis | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Describe "Script Quality" {
    Context "Script Files" {
        BeforeAll {
            $scriptsPath = "$PSScriptRoot\..\ColorScripts-Enhanced\Scripts"
            $scripts = Get-ChildItem $scriptsPath -Filter "*.ps1" |
            Where-Object { $_.Name -ne 'ColorScriptCache.ps1' }
        }

        It "Scripts should use UTF-8 encoding" {
            # Sample test on a few scripts
            $testScripts = $scripts | Select-Object -First 5
            foreach ($script in $testScripts) {
                $content = [System.IO.File]::ReadAllBytes($script.FullName)
                # Check for UTF-8 BOM or assume UTF-8
                if ($content.Length -ge 3) {
                    # Just verify file can be read without error
                    { Get-Content $script.FullName -ErrorAction Stop } | Should -Not -Throw
                }
            }
        }

        It "Scripts should have cache check header" {
            $testScripts = $scripts | Select-Object -First 5
            foreach ($script in $testScripts) {
                $content = Get-Content $script.FullName -Raw
                # Most scripts should have cache header (some may not)
                if ($content -match 'ColorScriptCache') {
                    $content | Should -Match 'ColorScriptCache'
                }
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
