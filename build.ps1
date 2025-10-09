param(
    [string]$version = (Get-Date).ToString("yyyy.MM.dd.HHmm")
)
$manifestParams = @{
    "ModuleVersion"        = $version
    "Path"                 = "./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1"
    "Author"               = "Nick2bad4u"
    "CompanyName"          = "Nick2bad4u"
    "RootModule"           = "./ColorScripts-Enhanced/ColorScripts-Enhanced.psm1"
    "CompatiblePSEditions" = @("Desktop", "Core")
    "FunctionsToExport"    = @("Show-ColorScript")
    "Description"          = "An almost like for like port of Scott McKendry port of Derek Taylor's Popular shell-color-scripts package for PowerShell."
    "ProjectUri"           = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced"
    "LicenseUri"           = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE"
    "PowerShellVersion"    = "5.1"
    "PassThru"             = $true
}

Copy-Item -Path "./README.md" -Destination "./ColorScripts-Enhanced/README.md" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "./ColorScripts-Enhanced/ColorScripts-Enhanced.psd1" -Force -ErrorAction SilentlyContinue
New-ModuleManifest @manifestParams
