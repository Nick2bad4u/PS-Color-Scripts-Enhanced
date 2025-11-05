function Reset-ScriptInventoryCache {
    Invoke-ModuleSynchronized $script:InventorySyncRoot {
        $script:ScriptInventory = $null
        $script:ScriptInventoryStamp = $null
        $script:ScriptInventoryInitialized = $false
        $script:ScriptInventoryRecords = $null
    }
}
