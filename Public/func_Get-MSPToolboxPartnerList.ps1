function Get-MSPToolboxPartnerList {
    try {
        return Invoke-MSPGraphRequest -Endpoint "contracts?`$top=999" -Beta
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
}