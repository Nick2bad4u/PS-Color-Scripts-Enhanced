function Set-FileLastWriteTimeUtc {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTimeUtc($Path, $Timestamp)
}
