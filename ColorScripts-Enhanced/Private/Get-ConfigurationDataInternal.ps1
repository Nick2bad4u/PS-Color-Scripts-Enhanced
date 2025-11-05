function Get-ConfigurationDataInternal {
    Initialize-Configuration
    return $script:ConfigurationData
}
