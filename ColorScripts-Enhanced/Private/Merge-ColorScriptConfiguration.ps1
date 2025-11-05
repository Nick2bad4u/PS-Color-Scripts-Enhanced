function Merge-ColorScriptConfiguration {
    param(
        [System.Collections.IDictionary]$Base,
        [System.Collections.IDictionary]$Override
    )

    if (-not $Override) {
        return Copy-ColorScriptHashtable $Base
    }

    $result = Copy-ColorScriptHashtable $Base
    foreach ($key in $Override.Keys) {
        $overrideValue = $Override[$key]
        if ($result.ContainsKey($key)) {
            $baseValue = $result[$key]
            if ($baseValue -is [System.Collections.IDictionary] -and $overrideValue -is [System.Collections.IDictionary]) {
                $result[$key] = Merge-ColorScriptConfiguration $baseValue $overrideValue
                continue
            }
        }

        switch ($true) {
            { $overrideValue -is [System.Collections.IDictionary] } {
                $result[$key] = Copy-ColorScriptHashtable $overrideValue
                break
            }
            { $overrideValue -is [System.Array] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.ICloneable] -and $overrideValue -isnot [string] } {
                $result[$key] = $overrideValue.Clone()
                break
            }
            { $overrideValue -is [System.Collections.IEnumerable] -and $overrideValue -isnot [string] } {
                $buffer = New-Object System.Collections.Generic.List[object]
                foreach ($item in $overrideValue) {
                    $null = $buffer.Add($item)
                }
                $result[$key] = $buffer.ToArray()
                break
            }
            default {
                $result[$key] = $overrideValue
            }
        }
    }

    return $result
}
