function Reset-ScriptInventoryCache {
    Invoke-ModuleSynchronized $script:InventorySyncRoot {
        $script:ScriptInventory = $null
        $script:ScriptInventoryStamp = $null
        $script:ScriptInventoryInitialized = $false
        $script:ScriptInventoryRecords = $null
    }

    Invoke-ModuleSynchronized $script:MetadataSyncRoot {
        $script:MetadataCache = $null
        $script:MetadataLastWriteTime = $null
        $script:MetadataInventoryLastWriteTime = $null
    }
}
