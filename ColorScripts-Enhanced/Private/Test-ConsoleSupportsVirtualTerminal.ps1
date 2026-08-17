function Initialize-ColorScriptConsoleNativeType {
    if (-not $script:DelegateSyncRoot) {
        $script:DelegateSyncRoot = New-Object System.Object
    }

    try {
        Invoke-ModuleSynchronized $script:DelegateSyncRoot {
            if ('ColorScriptsEnhanced.ConsoleNative' -as [Type]) {
                return
            }

            $typeDefinition = @(
                'using System;',
                'using System.Runtime.InteropServices;',
                '',
                'namespace ColorScriptsEnhanced {',
                '    public static class ConsoleNative {',
                '        [DllImport("kernel32.dll", SetLastError = true)]',
                '        public static extern IntPtr GetStdHandle(int nStdHandle);',
                '',
                '        [DllImport("kernel32.dll", SetLastError = true)]',
                '        public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int lpMode);',
                '',
                '        [DllImport("kernel32.dll", SetLastError = true)]',
                '        public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);',
                '    }',
                '}'
            ) -join [Environment]::NewLine

            Add-Type -TypeDefinition $typeDefinition -ErrorAction Stop
        }
    }
    catch {
        return $false
    }

    return $null -ne ('ColorScriptsEnhanced.ConsoleNative' -as [Type])
}

function Get-ColorScriptConsoleNativeDelegateSet {
    param(
        [AllowNull()]
        [object]$Overrides
    )

    $getStdHandle = if ($Overrides -and $Overrides.GetStdHandle) {
        $Overrides.GetStdHandle
    }
    else {
        { param([int]$handleId) [ColorScriptsEnhanced.ConsoleNative]::GetStdHandle($handleId) }
    }

    $getConsoleMode = if ($Overrides -and $Overrides.GetConsoleMode) {
        $Overrides.GetConsoleMode
    }
    else {
        { param([IntPtr]$handle, [ref]$mode) [ColorScriptsEnhanced.ConsoleNative]::GetConsoleMode($handle, [ref]$mode) }
    }

    $setConsoleMode = if ($Overrides -and $Overrides.SetConsoleMode) {
        $Overrides.SetConsoleMode
    }
    else {
        { param([IntPtr]$handle, [int]$mode) [ColorScriptsEnhanced.ConsoleNative]::SetConsoleMode($handle, $mode) }
    }

    return @{
        GetStdHandle   = $getStdHandle
        GetConsoleMode = $getConsoleMode
        SetConsoleMode = $setConsoleMode
    }
}

function Enable-ColorScriptVirtualTerminal {
    param(
        [Parameter(Mandatory)]
        [hashtable]$Delegates
    )

    $enableVirtualTerminalProcessing = 0x0004
    $standardOutputHandle = -11

    try {
        $handle = & $Delegates.GetStdHandle $standardOutputHandle
        if ($handle -eq [IntPtr]::Zero) {
            return $false
        }

        $mode = 0
        if (-not (& $Delegates.GetConsoleMode $handle ([ref]$mode))) {
            return $false
        }

        if (($mode -band $enableVirtualTerminalProcessing) -ne 0) {
            return $true
        }

        if (-not (& $Delegates.SetConsoleMode $handle ($mode -bor $enableVirtualTerminalProcessing))) {
            return $false
        }

        $updatedMode = 0
        if (-not (& $Delegates.GetConsoleMode $handle ([ref]$updatedMode))) {
            return $false
        }

        return ($updatedMode -band $enableVirtualTerminalProcessing) -ne 0
    }
    catch {
        return $false
    }
}

function Test-ConsoleSupportsVirtualTerminal {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not $script:IsWindows) {
        return $true
    }

    $overrides = $null
    if ($script:ConsoleNativeOverrides -and $script:ConsoleNativeOverrides.Enabled -eq $true) {
        $overrides = $script:ConsoleNativeOverrides
    }

    if (-not $overrides -and -not (Initialize-ColorScriptConsoleNativeType)) {
        return $false
    }

    $delegates = Get-ColorScriptConsoleNativeDelegateSet -Overrides $overrides
    return Enable-ColorScriptVirtualTerminal -Delegates $delegates
}
