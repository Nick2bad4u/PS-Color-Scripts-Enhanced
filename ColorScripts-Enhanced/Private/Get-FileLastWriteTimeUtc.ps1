function Get-FileLastWriteTimeUtc {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTimeUtc($Path)
}
