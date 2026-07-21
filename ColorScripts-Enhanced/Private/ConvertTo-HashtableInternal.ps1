function ConvertTo-HashtableInternal {
    param([Parameter(ValueFromPipeline)]$InputObject)

    process {
        if ($null -eq $InputObject) {
            return $null
        }

        if ($InputObject -is [System.Collections.IDictionary]) {
            $hash = @{}
            foreach ($entry in $InputObject.GetEnumerator()) {
                $hash[$entry.Key] = ConvertTo-HashtableInternal $entry.Value
            }
            return $hash
        }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = New-Object 'System.Collections.Generic.List[object]'
            foreach ($item in $InputObject) {
                $convertedItem = ConvertTo-HashtableInternal $item
                $null = $collection.Add($convertedItem)
            }

            # Preserve nested JSON array boundaries instead of allowing PowerShell's pipeline
            # enumeration to flatten every child collection into its parent.
            Write-Output -NoEnumerate -InputObject $collection.ToArray()
            return
        }

        if ($InputObject -is [PSCustomObject]) {
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-HashtableInternal $property.Value
            }
            return $hash
        }

        return $InputObject
    }
}
