function ConvertFrom-JsonToHashtable {
    <#
    .SYNOPSIS
        Converts JSON to a hashtable, compatible with PowerShell 5.1 and 7+
    .DESCRIPTION
        PowerShell 5.1 doesn't support -AsHashtable parameter on ConvertFrom-Json.
        This function provides a compatible conversion method for all PowerShell versions.
    #>
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [string]$InputObject
    )

    process {
        if ([string]::IsNullOrWhiteSpace($InputObject)) {
            return $null
        }

        # PowerShell 6.0+ supports -AsHashtable natively
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            return ConvertFrom-Json -InputObject $InputObject -AsHashtable
        }

        $obj = ConvertFrom-Json -InputObject $InputObject
        return ConvertTo-HashtableInternal $obj
    }
}
