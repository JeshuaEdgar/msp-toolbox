function Get-PartnerToken {
    param (
        [parameter(Mandatory = $true)]
        [string]$TenantID
    )
    
    $tokenSplat = @{
        Scopes        = "https://graph.microsoft.com/.default"
        Tenant        = $TenantID
        ApplicationID = $scipt:mspToolBoxSession.ApplicationID
        Credential    = New-Object System.Management.Automation.PSCredential($scipt:mspToolBoxSession.ApplicationID, $scipt:mspToolBoxSession.ApplicationSecret)
    }
    try {
        return @{
            Authorization = "Bearer $((New-PartnerAccessToken @tokenSplat -ServicePrincipal).AccessToken)"
        }
    }
    catch {
        Write-Error (Format-ErrorCodes $_).ErrorMessage
    }
}