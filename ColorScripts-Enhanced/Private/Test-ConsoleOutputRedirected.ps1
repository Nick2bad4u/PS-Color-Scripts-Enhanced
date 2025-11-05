function Test-ConsoleOutputRedirected {
    try {
        return (& $script:IsOutputRedirectedDelegate)
    }
    catch {
        return $false
    }
}
