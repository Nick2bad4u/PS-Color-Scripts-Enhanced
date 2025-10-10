# Kevin Woods ASCII
# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$art = @'
Kevin Woods:
                                 ,        ,
                                /(        )`
                                \ \___   / |
                                /- _  `-/  '
                               (/\/ \ \   /\
                               / /   | `    \
                               O O   ) /    |
                               `-^--'`<     '
                   TM         (_.)  _  )   /
|  | |\  | ~|~ \ /             `.___/`    /
|  | | \ |  |   X                `-----' /
`__| |  \| _|_ / \  <----.     __ / __   \
                    <----|====O)))==) \) /====
                    <----'    `--' `.__,' \
                                 |        |
                                  \       /
                             ______( (_  / \______
                           ,'  ,-----'   |        \
                           `--{__________)        \/
'@

Write-Host -Object $art

# Enable ANSI (virtual terminal) processing so escape sequences are handled
$kernel32 = @"
using System;
using System.Runtime.InteropServices;
public static class Kernel32 {
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode);
}
"@
Add-Type -TypeDefinition $kernel32 -ErrorAction SilentlyContinue | Out-Null

$STD_OUTPUT_HANDLE = -11
$ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004

try {
    $handle = [Kernel32]::GetStdHandle($STD_OUTPUT_HANDLE)
    $mode = 0
    if ([Kernel32]::GetConsoleMode($handle, [ref]$mode)) {
        [Kernel32]::SetConsoleMode($handle, $mode -bor $ENABLE_VIRTUAL_TERMINAL_PROCESSING) | Out-Null
    }
} catch {
    # If enabling VT fails, continue anyway; many hosts already support ANSI
}

$esc = [char]27

# Color rules:
# - space => plain space
# - 'O' => bright white
# - 'T' / 'M' => yellow
# - everything else (non-space) => red
$lines = $art -split "`n"
foreach ($line in $lines) {
    $chars = $line.ToCharArray()
    $out = for ($i = 0; $i -lt $chars.Length; $i++) {
        $c = $chars[$i]
        switch ($c) {
            ' ' { ' ' }
            'O' { "$esc[97m$c" }               # bright white (eyes)
            'T' { "$esc[33m$c" }               # yellow (TM)
            'M' { "$esc[33m$c" }               # yellow (TM)
            default {
                if ($c -match '\s') { $c }     # any whitespace fallback
                else { "$esc[31m$c" }          # red for drawing lines
            }
        }
    }
    # reset color and write the line
    $coloredLine = ($out -join '') + "$esc[0m"
    Write-Host $coloredLine
}
