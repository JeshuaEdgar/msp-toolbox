function Connect-MSPPartner {
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
        $script:CustomerAuthHeader = @{ Authorization = "Bearer $((New-PartnerAccessToken @tokenSplat -ServicePrincipal).AccessToken)"; "Content-Type" = "application/json" }
        try {
            $organisationCheck = Invoke-MSPGraphRequest -Method Get -Endpoint "organization"
            $script:mspToolBoxSession.ConnectedTenant = $organisationCheck.displayName
            Write-Verbose ("Connected to tenant {0}" -f $organisationCheck.displayName)
        }
        catch {
            Write-Error (Format-ErrorCode $_).ErrorMessage
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_).ErrorMessage
    }
}