function Set-FileLastWriteTime {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][datetime]$Timestamp
    )

    [System.IO.File]::SetLastWriteTime($Path, $Timestamp)
}
