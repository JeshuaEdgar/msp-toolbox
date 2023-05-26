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
        Write-Verbose "MSPToolBox | Connecting with Microsoft CSP with given values..."
        $graphToken = New-PartnerAccessToken -ServicePrincipal @{
            ApplicationId = $ApplicationID
            Credential    = New-Object System.Management.Automation.PSCredential($ApplicationID, $ApplicationSecret)
            RefreshToken  = $Refreshtoken
            Scopes        = 'https://graph.microsoft.com/.default'
            Tenant        = $TenantID
        }
        # build auth header
        $authHeader = @{ Authorization = $graphToken.AccessToken }

        Write-Verbose "MSPToolBox | Getting list of partner customers..."
        $customers = Invoke-RestMethod @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts?`$top=999"
            Header = $authHeader
        }

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
        Write-Error (Format-ErrorCodes).ErrorMessage
    }
}