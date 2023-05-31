$moduleRoot = (Get-Item $PSScriptRoot).Parent.FullName
### Read the local.settings.json file and convert to a PowerShell object.
$devSettings = Get-Content "$moduleRoot\Tools\local.settings.json" | ConvertFrom-Json
### Loop through the settings and set environment variables for each.
$validKeys = @('ApplicationId', 'RefreshToken', 'ApplicationSecret', 'TenantId')
ForEach ($key in $devSettings.PSObject.Properties.Name) {
    if ($validKeys -Contains $key) {
        [Environment]::SetEnvironmentVariable($key, $devSettings.$key)
    }
}

Import-Module "$moduleRoot\MSPToolBox.psm1" -Force -Verbose

$connectSplat = @{
    ApplicationID     = $env:ApplicationID
    ApplicationSecret = $env:ApplicationSecret
    Refreshtoken      = $env:Refreshtoken
    TenantID          = $env:TenantID
}

Connect-MSPToolbox @connectSplat -Verbose