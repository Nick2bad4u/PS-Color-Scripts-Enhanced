function Initialize-SystemDelegateState {
    Invoke-ModuleSynchronized $script:DelegateSyncRoot {
        if (-not $script:GetUserProfilePathDelegate) {
            $script:GetUserProfilePathDelegate = { [System.Environment]::GetFolderPath('UserProfile') }
        }

        if (-not $script:IsPathRootedDelegate) {
            $script:IsPathRootedDelegate = {
                param([string]$Path)
                [System.IO.Path]::IsPathRooted($Path)
            }
        }

        if (-not $script:GetFullPathDelegate) {
            $script:GetFullPathDelegate = {
                param([string]$Path)
                [System.IO.Path]::GetFullPath($Path)
            }
        }

        if (-not $script:GetCurrentDirectoryDelegate) {
            $script:GetCurrentDirectoryDelegate = {
                [System.IO.Directory]::GetCurrentDirectory()
            }
        }

        if (-not $script:GetCurrentProviderPathDelegate) {
            $script:GetCurrentProviderPathDelegate = {
                $ExecutionContext.SessionState.Path.CurrentFileSystemLocation.ProviderPath
            }
        }

        if (-not $script:DirectoryGetLastWriteTimeUtcDelegate) {
            $script:DirectoryGetLastWriteTimeUtcDelegate = {
                param([string]$Path)
                [System.IO.Directory]::GetLastWriteTimeUtc($Path)
            }
        }

        if (-not $script:FileExistsDelegate) {
            $script:FileExistsDelegate = {
                param([string]$Path)
                [System.IO.File]::Exists($Path)
            }
        }

        if (-not $script:FileGetLastWriteTimeUtcDelegate) {
            $script:FileGetLastWriteTimeUtcDelegate = {
                param([string]$Path)
                [System.IO.File]::GetLastWriteTimeUtc($Path)
            }
        }

        if (-not $script:FileReadAllTextDelegate) {
            $script:FileReadAllTextDelegate = {
                param([string]$Path, [System.Text.Encoding]$Encoding)
                [System.IO.File]::ReadAllText($Path, $Encoding)
            }
        }

        if (-not $script:GetCurrentProcessDelegate) {
            $script:GetCurrentProcessDelegate = {
                [System.Diagnostics.Process]::GetCurrentProcess()
            }
        }

        if (-not $script:IsOutputRedirectedDelegate) {
            $script:IsOutputRedirectedDelegate = { [Console]::IsOutputRedirected }
        }

        if (-not $script:GetConsoleOutputEncodingDelegate) {
            $script:GetConsoleOutputEncodingDelegate = { [Console]::OutputEncoding }
        }

        if (-not $script:SetConsoleOutputEncodingDelegate) {
            $script:SetConsoleOutputEncodingDelegate = {
                param([System.Text.Encoding]$Encoding)
                [Console]::OutputEncoding = $Encoding
            }
        }

        if (-not $script:ConsoleWriteDelegate) {
            $script:ConsoleWriteDelegate = {
                param([string]$Text)
                [Console]::Write($Text)
            }
        }

        if (-not $script:CreateDirectoryDelegate) {
            $script:CreateDirectoryDelegate = {
                param([string]$Path)
                [System.IO.Directory]::CreateDirectory($Path)
            }
        }
    }
}
