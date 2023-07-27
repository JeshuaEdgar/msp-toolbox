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
        $appSecret = $ApplicationSecret | ConvertTo-SecureString -AsPlainText -Force
        Write-Verbose "MSPToolBox | Connecting with Microsoft CSP with given values..."
        $graphSplat = @{
            ApplicationId = $ApplicationID
            Credential    = New-Object System.Management.Automation.PSCredential($ApplicationID, $appSecret)
            RefreshToken  = $Refreshtoken
            Scopes        = 'https://graph.microsoft.com/.default'
            Tenant        = $TenantID
        }
        $graphToken = New-PartnerAccessToken -ServicePrincipal @graphSplat
        # build auth header
        $authHeader = @{ Authorization = "Bearer $($graphToken.AccessToken)" }

        Write-Verbose "MSPToolBox | Checking connection and functionalitys..."
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts"
            Header = $authHeader
        }
        $customers = Invoke-RestMethod @customerSplat

        Write-Verbose "MSPToolBox | Verifying customers..."
        if (($customers.value).count -ge 1) {
            # set variables after confirmation of validity
            $script:mspToolBoxSession.ApplicationID = $ApplicationID
            $script:mspToolBoxSession.ApplicationSecret = $ApplicationSecret
            $script:mspToolBoxSession.Refreshtoken = $Refreshtoken
            $script:mspToolBoxSession.TenantID = $TenantID
            $script:mspToolBoxSession.GraphAuthHeader = $authHeader
            Write-Verbose "MSPToolBox | Connected!"
        }
        else {
            Write-Verbose "MSPToolBox | Oops! No customers found, check logs/error messsages for debugging"
        }
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
    return $true | Out-Null
}