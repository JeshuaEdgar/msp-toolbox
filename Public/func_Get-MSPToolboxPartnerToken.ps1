function Get-MSPToolboxPartnerToken {
    param (
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
        return @{
            Authorization = "Bearer $((New-PartnerAccessToken @tokenSplat -ServicePrincipal).AccessToken)"
        }
    }
    catch {
        Write-Error (Format-ErrorCodes $_).ErrorMessage
    }
}