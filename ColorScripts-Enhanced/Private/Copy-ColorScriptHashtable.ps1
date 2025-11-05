function Copy-ColorScriptHashtable {
    param([System.Collections.IDictionary]$Source)

    if (-not $Source) {
        return @{}
    }

    $clone = @{}
    foreach ($key in $Source.Keys) {
        $value = $Source[$key]
        switch ($true) {
            { $value -is [System.Collections.IDictionary] } {
                $clone[$key] = Copy-ColorScriptHashtable $value
                break
            }
            { $value -is [System.Array] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.ICloneable] -and $value -isnot [string] } {
                $clone[$key] = $value.Clone()
                break
            }
            { $value -is [System.Collections.IEnumerable] -and $value -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $value) {
                    $null = $buffer.Add($item)
                }
                $clone[$key] = $buffer.ToArray()
                break
            }
            default {
                $clone[$key] = $value
            }
        }
    }

    return $clone
}
