function Get-MSPToolboxCurrentConnection {
    if ($null -ne $script:mspToolBoxSession) {
        return [PSCustomObject]@{
            ConnectedTenant = $script:mspToolBoxSession.CurrentTenant
        }
    }
    else {
        return [PSCustomObject]@{
            ConnectedTenant = "Not connected to any Partner tenant at the moment"
        }
    }
}