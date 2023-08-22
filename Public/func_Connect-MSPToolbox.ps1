function Connect-MSPToolbox {
    param (
        [CmdletBinding()]
        [parameter(Mandatory = $true)]
        [string]$ApplicationID,
        [parameter(Mandatory = $true)]
        [string]$ApplicationSecret,
        [parameter(Mandatory = $true)]
        [string]$Refreshtoken,
        [parameter(Mandatory = $true)]
        [string]$TenantID
    )
    $ErrorActionPreference = "Stop"
    try {
        Test-MSPToolboxConnection
        Write-Debug "MSPToolBox | Connecting with Microsoft CSP with given values..."
        $graphBody = @{
            client_id     = $ApplicationID
            client_secret = $ApplicationSecret
            refresh_token = $Refreshtoken
            scope         = "https://graph.microsoft.com/.default"
            grant_type    = "refresh_token"
        }
        $graphToken = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantID)/oauth2/v2.0/token" -Body $graphBody
        $authHeader = @{ Authorization = "Bearer $($graphToken.access_token)"; "Content-Type" = "application/json" }

        Write-Debug "MSPToolBox | Checking connection and functionalities..."
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts"
            Header = $authHeader
        }
        $customers = Invoke-RestMethod @customerSplat

        Write-Debug "MSPToolBox | Verifying customers..."
        if (($customers.value).count -ge 1) {
            # set variables after confirmation of validity
            $script:mspToolBoxSession.ApplicationID = $ApplicationID
            $script:mspToolBoxSession.ApplicationSecret = $ApplicationSecret
            $script:mspToolBoxSession.Refreshtoken = $Refreshtoken
            $script:mspToolBoxSession.TenantID = $TenantID
            $script:mspToolBoxSession.MSPAuthHeader = $authHeader
            $script:mspToolBoxSession.MSPTokenExpiry = [datetime](Get-Date).AddMinutes($graphToken.expires_in)
            Write-Debug "MSPToolBox | Connected!"
        }
        else {
            Write-Debug "MSPToolBox | Oops! No customers found, check logs/error messsages for debugging"
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
    Write-Output "Connected to MSPToolbox!"
}