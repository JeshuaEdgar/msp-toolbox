function Connect-MSPPartner {
    param (
        [CmdletBinding()]
        [parameter(Mandatory = $true)]
        [string]$TenantID
    )
    Test-MSPToolboxConnection
    $customerTokenSplat = @{
        client_id     = $script:mspToolBoxSession.ApplicationID
        client_secret = $script:mspToolBoxSession.ApplicationSecret
        refresh_token = $script:mspToolBoxSession.Refreshtoken
        scope         = "https://graph.microsoft.com/.default"
        grant_type    = "refresh_token"
    }
    try {
        $customerTokenRequest = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantID)/oauth2/v2.0/token" -Body $customerTokenSplat
        $script:CustomerAuthHeader = @{ Authorization = "Bearer $($customerTokenRequest.access_token)"; "Content-Type" = "application/json" }
        # checking one graph request with new token
        $organisationCheck = Invoke-MSPGraphRequest -Method Get -Endpoint "organization"
        $script:mspToolBoxSession.ConnectedTenant = $organisationCheck.displayName
        $script:mspToolBoxSession.CustomerTokenExpiry = [datetime](Get-Date).AddMinutes($customerTokenRequest.expires_in)
        Write-Output ("Connected to tenant {0}" -f $organisationCheck.displayName)
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
}