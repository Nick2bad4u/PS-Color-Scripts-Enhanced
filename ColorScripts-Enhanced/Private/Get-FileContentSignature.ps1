function Get-FileContentSignature {
    <#
    .SYNOPSIS
        Returns file size, timestamps, and (optionally) a cryptographic hash for a file path.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter()]
        [switch]$IncludeHash
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw [System.IO.FileNotFoundException]::new(("File '{0}' was not found." -f $Path))
    }

    $resolvedPath = (Resolve-Path -LiteralPath $Path -ErrorAction Stop).ProviderPath
    $fileInfo = Get-Item -LiteralPath $resolvedPath -ErrorAction Stop

    $signature = [pscustomobject]@{
        Path             = $fileInfo.FullName
        Length           = [long]$fileInfo.Length
        LastWriteTime    = $fileInfo.LastWriteTime
        LastWriteTimeUtc = $fileInfo.LastWriteTimeUtc
        Hash             = $null
        HashAlgorithm    = $null
    }

    if ($IncludeHash) {
        $fileStream = $null
        $hashAlgorithm = $null

        try {
            $fileStream = [System.IO.File]::Open($resolvedPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
            $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
            $signature.Hash = ([System.BitConverter]::ToString($hashBytes) -replace '-', '').ToLowerInvariant()
            $signature.HashAlgorithm = 'SHA256'
        }
        finally {
            if ($hashAlgorithm) { $hashAlgorithm.Dispose() }
            if ($fileStream) { $fileStream.Dispose() }
        }
    }

    return $signature
}
