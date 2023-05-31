function Get-MSPToolboxCurrentConnection {
    if ([string]::IsNullOrEmpty($script:mspToolBoxSession.ConnectedTenant)) {
        return [PSCustomObject]@{
            ConnectedTenant = "Not connected to any Partner tenant at the moment"
        }
    }
    else {
        return [PSCustomObject]@{
            ConnectedTenant = $script:mspToolBoxSession.ConnectedTenant
        }
    }
}