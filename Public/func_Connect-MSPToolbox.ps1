function Connect-MSPToolbox {
    param (
        [CmdletBinding()]
        [parameter(Mandatory = $true)]
        [string]$ApplicationID,
        [parameter(Mandatory = $true)]
        [SecureString]$ApplicationSecret,
        [parameter(Mandatory = $true)]
        [SecureString]$Refreshtoken,
        [parameter(Mandatory = $true)]
        [string]$TenantID
    )
    $ErrorActionPreference = "Stop"
    # internal function to decode passwords
    function Decode-SecureString($secureString) {
        $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($secureString)
        $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
        return [string]$result 
    }
    try {
        Test-MSPToolboxConnection
        New-DebugLine "Connecting with Microsoft CSP with given values..."
        $graphBody = @{
            client_id     = $ApplicationID
            client_secret = (Decode-SecureString $ApplicationSecret)
            refresh_token = (Decode-SecureString $Refreshtoken)
            scope         = "https://graph.microsoft.com/.default"
            grant_type    = "refresh_token"
        }
        $graphToken = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($TenantID)/oauth2/v2.0/token" -Body $graphBody
        $authHeader = @{ Authorization = "Bearer $($graphToken.access_token)"; "Content-Type" = "application/json" }

        New-DebugLine "Checking connection and functionalities..."
        $permissions = Read-JwtTokenPermissions -Token $graphToken.access_token
        New-DebugLine "Appliaction has following permissions:"
        $permissions | foreach { New-DebugLine $_ }
        $customerSplat = @{
            Method = "Get"
            URI    = "https://graph.microsoft.com/beta/contracts"
            Header = $authHeader
        }
        $customers = Invoke-RestMethod @customerSplat

        New-DebugLine "Verifying customers..."
        if (($customers.value).count -ge 1) {
            # set variables after confirmation of validity
            $script:mspToolBoxSession.ApplicationID = $ApplicationID
            $script:mspToolBoxSession.ApplicationSecret = (Decode-SecureString $ApplicationSecret)
            $script:mspToolBoxSession.Refreshtoken = (Decode-SecureString $Refreshtoken)
            $script:mspToolBoxSession.TenantID = $TenantID
            $script:mspToolBoxSession.MSPAuthHeader = $authHeader
            $script:mspToolBoxSession.MSPTokenExpiry = [datetime](Get-Date).AddSeconds($graphToken.expires_in)
            New-DebugLine "Connected!"
        }
        else {
            New-DebugLine "Oops! No customers found, check logs/error messsages for debugging"
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
    Write-Output "Connected to MSPToolbox!"
}