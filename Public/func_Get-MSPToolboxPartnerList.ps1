function Get-MSPToolboxPartnerList {
    try {
        Test-MSPToolboxConnection
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts?`$top=999"
            Header = $script:mspToolBoxSession.MSPAuthHeader
        }
        $customers = Invoke-RestMethod @customerSplat
        return [PSCustomObject]$customers.value
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }    
}