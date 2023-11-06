function Disconnect-MSPPartner {
    $tenant = $script:mspToolBoxSession.ConnectedTenant
    $script:mspToolBoxSession.CustomerAuthHeader = $null
    $script:mspToolBoxSession.CustomerTokenExpiry = $null
    $script:mspToolBoxSession.CustomerTenantID = $null
    $script:mspToolBoxSession.ConnectedTenant = $null

    Write-Output "MSPToolbox | Successfully disconnected from $tenant"
}
