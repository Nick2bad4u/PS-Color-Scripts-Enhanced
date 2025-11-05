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
            $collection = @()
            foreach ($item in $InputObject) {
                $collection += ConvertTo-HashtableInternal $item
            }
            return $collection
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
