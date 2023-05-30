function Get-MSPToolboxPartnerList {
    try {
        Test-MSPToolboxConnection
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts?`$top=999"
            Header = $script:mspToolBoxSession.GraphAuthHeader
        }
        $customers = Invoke-RestMethod @customerSplat
        return [PSCustomObject]$customers.value
    }
    catch {
        (Format-ErrorCodes $_).ErrorMessage
    }    
}