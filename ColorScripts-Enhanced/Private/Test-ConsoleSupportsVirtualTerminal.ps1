function Test-ConsoleSupportsVirtualTerminal {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not $script:IsWindows) {
        return $true
    }

    $ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
    $STD_OUTPUT_HANDLE = -11

    if (-not $script:DelegateSyncRoot) {
        $script:DelegateSyncRoot = New-Object System.Object
    }

    try {
        Invoke-ModuleSynchronized $script:DelegateSyncRoot {
            if (-not ('ColorScriptsEnhanced.ConsoleNative' -as [Type])) {
                $typeDefinition = @(
                    'using System;',
                    'using System.Runtime.InteropServices;',
                    '',
                    'namespace ColorScriptsEnhanced {',
                    '    internal static class ConsoleNative {',
                    '        [DllImport("kernel32.dll", SetLastError = true)]',
                    '        internal static extern IntPtr GetStdHandle(int nStdHandle);',
                    '',
                    '        [DllImport("kernel32.dll", SetLastError = true)]',
                    '        internal static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int lpMode);',
                    '',
                    '        [DllImport("kernel32.dll", SetLastError = true)]',
                    '        internal static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);',
                    '    }',
                    '}'
                ) -join [Environment]::NewLine

                Add-Type -TypeDefinition $typeDefinition -ErrorAction Stop
            }
        }
    }
    catch {
        return $false
    }

    try {
        $handle = [ColorScriptsEnhanced.ConsoleNative]::GetStdHandle($STD_OUTPUT_HANDLE)
        if ($handle -eq [IntPtr]::Zero) {
            return $false
        }

        $mode = 0
        if (-not [ColorScriptsEnhanced.ConsoleNative]::GetConsoleMode($handle, [ref]$mode)) {
            return $false
        }

        if (($mode -band $ENABLE_VIRTUAL_TERMINAL_PROCESSING) -ne 0) {
            return $true
        }

        if ([ColorScriptsEnhanced.ConsoleNative]::SetConsoleMode($handle, $mode -bor $ENABLE_VIRTUAL_TERMINAL_PROCESSING)) {
            $updatedMode = 0
            if ([ColorScriptsEnhanced.ConsoleNative]::GetConsoleMode($handle, [ref]$updatedMode)) {
                return (($updatedMode -band $ENABLE_VIRTUAL_TERMINAL_PROCESSING) -ne 0)
            }
        }
    }
    catch {
        return $false
    }

    return $false
}
