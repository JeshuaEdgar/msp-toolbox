function Get-MSPToolboxPartnerList {
    try {
        return Invoke-MSPGraphRequest -Endpoint "contracts?`$top=999" -Beta -AsMSP
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
}