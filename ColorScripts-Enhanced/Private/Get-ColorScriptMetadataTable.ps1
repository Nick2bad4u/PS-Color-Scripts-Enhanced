function Get-ColorScriptMetadataTable {
    Invoke-ModuleSynchronized $script:MetadataSyncRoot {
        Get-ColorScriptMetadataTableInternal
    }
}
