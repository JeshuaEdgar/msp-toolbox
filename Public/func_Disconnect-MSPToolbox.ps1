function Disconnect-MSPToolbox {
    $script:mspToolBoxSession = @{
        ApplicationID       = $null
        ApplicationSecret   = $null
        Refreshtoken        = $null
        TenantID            = $null
        MSPAuthHeader       = $null
        MSPTokenExpiry      = $null
        CustomerAuthHeader  = $null
        CustomerTokenExpiry = $null
        CustomerTenantID    = $null
        ConnectedTenant     = $null
    }
    Remove-Variable $script:mspToolBoxSession -Verbose
    Write-Output "MSPToolbox | Successfully disconnected"
}