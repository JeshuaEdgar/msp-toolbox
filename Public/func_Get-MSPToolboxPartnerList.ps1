function Get-MSPToolboxPartnerList {
    try {
        $partnerListSplat = @{
            Uri     = "https://graph.microsoft.com/beta/contracts?`$top=999"
            Headers = $script:mspToolboxSession.MSPAuthHeader
        }
        return (Invoke-RestMethod @partnerListSplat).value
        # return Invoke-MSPGraphRequest -Endpoint "contracts?`$top=999" -Beta
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
}