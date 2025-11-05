function Test-ColorScriptTextEmission {
    param(
        [bool]$ReturnText,
        [bool]$PassThru,
        [int]$PipelineLength,
        [System.Collections.IDictionary]$BoundParameters
    )

    $isRedirected = $false
    try {
        if ($script:IsOutputRedirectedDelegate) {
            $isRedirected = & $script:IsOutputRedirectedDelegate
        }
        else {
            $isRedirected = [Console]::IsOutputRedirected
        }
    }
    catch {
        $isRedirected = $false
    }

    if ($ReturnText) {
        return $true
    }

    if ($PassThru) {
        return $isRedirected
    }

    if ($PipelineLength -gt 1) {
        return $true
    }

    if ($BoundParameters -and ($BoundParameters.ContainsKey('OutVariable') -or $BoundParameters.ContainsKey('PipelineVariable'))) {
        return $true
    }

    if ($PipelineLength -gt 0) {
        return $isRedirected
    }

    return $isRedirected
}
