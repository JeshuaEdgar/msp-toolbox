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
        Write-Debug "MSPToolbox | MSPToolBox | Connecting with Microsoft CSP with given values..."
        $graphBody = @{
            client_id     = $ApplicationID
            client_secret = $ApplicationSecret
            refresh_token = $Refreshtoken
            scope         = "https://graph.microsoft.com/.default"
            grant_type    = "refresh_token"
        }
        $graphToken = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantID)/oauth2/v2.0/token" -Body $graphBody
        $authHeader = @{ Authorization = "Bearer $($graphToken.access_token)"; "Content-Type" = "application/json" }

        Write-Debug "MSPToolbox | MSPToolBox | Checking connection and functionalities..."
        Write-Debug $graphToken.access_token
        $permissions = Read-JwtTokenPermissions -Token $graphToken.access_token
        Write-Debug "MSPToolbox | MSPToolbox | Appliaction has following permissions:"
        $permissions | foreach { Write-Debug $_ }
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts"
            Header = $authHeader
        }
        $customers = Invoke-RestMethod @customerSplat

        Write-Debug "MSPToolbox | MSPToolBox | Verifying customers..."
        if (($customers.value).count -ge 1) {
            # set variables after confirmation of validity
            $script:mspToolBoxSession.ApplicationID = $ApplicationID
            $script:mspToolBoxSession.ApplicationSecret = $ApplicationSecret
            $script:mspToolBoxSession.Refreshtoken = $Refreshtoken
            $script:mspToolBoxSession.TenantID = $TenantID
            $script:mspToolBoxSession.MSPAuthHeader = $authHeader
            $script:mspToolBoxSession.MSPTokenExpiry = [datetime](Get-Date).AddSeconds($graphToken.expires_in)
            Write-Debug "MSPToolbox | MSPToolBox | Connected!"
        }
        else {
            Write-Debug "MSPToolbox | MSPToolBox | Oops! No customers found, check logs/error messsages for debugging"
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
    Write-Output "Connected to MSPToolbox!"
}