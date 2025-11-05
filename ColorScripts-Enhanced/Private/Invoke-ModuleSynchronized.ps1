function Invoke-ModuleSynchronized {
    param(
        [Parameter(Mandatory)][object]$SyncRoot,
        [Parameter(Mandatory)][scriptblock]$Action
    )

    if (-not $SyncRoot) {
        return & $Action
    }

    $lockTaken = $false
    try {
        [System.Threading.Monitor]::Enter($SyncRoot, [ref]$lockTaken)
        return & $Action
    }
    finally {
        if ($lockTaken) {
            [System.Threading.Monitor]::Exit($SyncRoot)
        }
    }
}
