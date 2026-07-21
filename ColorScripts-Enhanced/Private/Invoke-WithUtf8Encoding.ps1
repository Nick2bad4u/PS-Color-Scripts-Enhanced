function Invoke-WithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock,
        [object[]]$Arguments
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not (Test-ConsoleOutputRedirected)) {
        try {
            $originalEncoding = & $script:GetConsoleOutputEncodingDelegate
            if ($originalEncoding -and $originalEncoding.WebName -ne 'utf-8') {
                & $script:SetConsoleOutputEncodingDelegate ([System.Text.Encoding]::UTF8)
                $encodingChanged = $true
            }
        }
        catch {
            $originalEncoding = $null
            $encodingChanged = $false
            Write-Verbose ("Unable to change the console output encoding: {0}" -f $_.Exception.Message)
        }
    }

    try {
        if ($Arguments) {
            return & $ScriptBlock @Arguments
        }

        return & $ScriptBlock
    }
    finally {
        if ($encodingChanged -and $originalEncoding) {
            try {
                & $script:SetConsoleOutputEncodingDelegate $originalEncoding
            }
            catch {
                Write-Verbose ("Unable to restore the console output encoding: {0}" -f $_.Exception.Message)
            }
        }
    }
}
