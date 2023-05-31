function Connect-MSPToolboxPartner {
    param (
        [CmdletBinding()]
        [parameter(Mandatory = $true)]
        [string]$TenantID
    )
    
    $tokenSplat = @{
        Scopes        = "https://graph.microsoft.com/.default"
        Tenant        = $TenantID
        ApplicationID = $script:mspToolBoxSession.ApplicationID
        Credential    = New-Object System.Management.Automation.PSCredential($script:mspToolBoxSession.ApplicationID, ($script:mspToolBoxSession.ApplicationSecret | ConvertTo-SecureString -AsPlainText -Force))
    }
    try {
        Test-MSPToolboxConnection
        $script:CustomerAuthHeader = @{ Authorization = "Bearer $((New-PartnerAccessToken @tokenSplat -ServicePrincipal).AccessToken)" }
        try {
            $organisationCheck = New-GraphRequest -Method "Get" -Endpoint "organization"
            $script:mspToolBoxSession.ConnectedTenant = $organisationCheck.value.displayName
            Write-Verbose ("Connected to tenant {0}" -f $organisationCheck.value.displayName)
        }
        catch {
            throw (Format-ErrorCodes $_).ErrorMessage
        }
    }
    catch {
        throw (Format-ErrorCodes $_).ErrorMessage
    }
}