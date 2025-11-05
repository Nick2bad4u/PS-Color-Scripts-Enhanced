function Get-FileLastWriteTime {
    param([Parameter(Mandatory)][string]$Path)
    [System.IO.File]::GetLastWriteTime($Path)
}
