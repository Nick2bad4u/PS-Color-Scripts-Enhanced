function Invoke-WithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock,
        [object[]]$Arguments
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not (& $script:IsOutputRedirectedDelegate)) {
        try {
            $originalEncoding = & $script:GetConsoleOutputEncodingDelegate
            if ($originalEncoding -and $originalEncoding.WebName -ne 'utf-8') {
                & $script:SetConsoleOutputEncodingDelegate ([System.Text.Encoding]::UTF8)
                $encodingChanged = $true
            }
        }
        catch [System.IO.IOException] {
            $originalEncoding = $null
            $encodingChanged = $false
            Write-Verbose 'Console handle unavailable; skipping OutputEncoding change.'
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
            catch [System.IO.IOException] {
                Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding.'
            }
        }
    }
}
