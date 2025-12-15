# Ensures Pester runs do not touch the user's real cache/config.
# This is especially important because some tests legitimately call Clear-ColorScriptCache -All.

Describe 'Test Environment Isolation' {
    BeforeAll {
        $script:OriginalCachePathEnv = $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH
        $script:OriginalConfigRootEnv = $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT

        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = Join-Path -Path $TestDrive -ChildPath 'cache'
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = Join-Path -Path $TestDrive -ChildPath 'config'

        New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH -Force | Out-Null
        New-Item -ItemType Directory -Path $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT -Force | Out-Null

        # If the module is already loaded (e.g., when running a subset of tests), reset cached paths
        # so subsequent cache operations use the isolated env vars.
        if (Get-Module -Name ColorScripts-Enhanced -ErrorAction SilentlyContinue) {
            InModuleScope ColorScripts-Enhanced {
                $script:CacheDir = $null
                $script:CacheInitialized = $false
                $script:ConfigurationRoot = $null
                $script:ConfigurationInitialized = $false
            }
        }
    }

    AfterAll {
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH = $script:OriginalCachePathEnv
        $env:COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT = $script:OriginalConfigRootEnv
    }

    It 'uses an isolated cache path during tests' {
        $env:COLOR_SCRIPTS_ENHANCED_CACHE_PATH | Should -Match ([regex]::Escape($TestDrive))
    }
}
