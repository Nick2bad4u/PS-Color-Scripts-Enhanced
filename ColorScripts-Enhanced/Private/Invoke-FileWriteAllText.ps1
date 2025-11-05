function Invoke-FileWriteAllText {
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Content,
        [Parameter(Mandatory)]
        [System.Text.Encoding]$Encoding
    )

    [System.IO.File]::WriteAllText($Path, $Content, $Encoding)
}
