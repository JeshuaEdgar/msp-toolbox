function Grant-CSPApplication {
    [CmdletBinding()]
    param (
        [string]$CustomerTenantID
    )

    # ignore list... for now (with reasons)
    $ignoreRoleList = @("user_impersonation", "profile", "offline_access", "openid") # no CSP tenant needs these permissions in any case
    $ignoreAppList = @("fc780465-2017-40d4-a0c5-307022471b92", "00000002-0000-0000-c000-000000000000") #defender ATP & AAD Graph (defender ATP gives an error on tenants that do not have it, will look into it. AAD Graph will de discontinued)

    New-DebugLine "Starting the Application Granter"
    if (-not $CustomerTenantID) {
        [array]$CustomerTenantID = Get-MSPToolboxPartnerList | Select-Object -ExpandProperty customerId
    }

    # Get the session data and get CSP token
    $sessionData = $script:mspToolBoxSession

    $cspTokenSplat = @{
        Uri     = "https://login.microsoftonline.com/$($sessionData.TenantID)/oauth2/v2.0/token"
        Method  = "Post"
        Headers = @{
            "Content-Type" = "application/x-www-form-urlencoded"
        }
        Body    = @{
            client_id     = $sessionData.ApplicationID
            client_secret = $sessionData.ApplicationSecret
            refresh_token = $sessionData.Refreshtoken
            grant_type    = "refresh_token"
            scope         = "https://api.partnercenter.microsoft.com/user_impersonation"
        }
    }
    try {  
        $cspAccessToken = (Invoke-RestMethod @cspTokenSplat).access_token
        if ((Read-JwtTokenPermissions $cspAccessToken) -eq "user_impersonation") {
            $cspAuthHeader = @{
                Authorization  = "Bearer $cspAccessToken"
                "Content-Type" = "application/json"
            }
            New-DebugLine "Got CSP token and required permission"
        }
        else {
            throw "MSPToolbox | No 'user_impersonation' permission found, please add the permissions and try again"
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_)
        return
    }
    
    if ($CustomerTenantID.count -gt 1 -and $PSBoundParameters.Keys -notcontains "Debug") {
        $progress = $true
    }
    # get application permissions and build the consent body
    try {
        if($progress -eq $true) { Write-Progress -Activity "Granting Application Permissions" -Status "Getting and building application consent body..." }

        $appInformation = Invoke-MSPGraphRequest -Endpoint ("applications(appId='{0}')" -f $script:mspToolBoxSession.ApplicationId) -AsMSP
        New-DebugLine "Got application information"

        $requiredResource = Invoke-MSPGraphRequest -Endpoint "applications/$($appInformation.id)/?`$select=requiredResourceAccess" -AsMSP | Select-Object -ExpandProperty requiredResourceAccess
        New-DebugLine "Required resources collected"

        $bodyBuilder = @()
        foreach ($resourceApp in $requiredResource) {
            if($progress -eq $true){ Write-Progress -Activity "Granting Application Permissions" -Status ("Getting enterprise application permissions for app {0}" -f $resourceApp.resourceAppId) -PercentComplete (([array]::IndexOf($requiredResource, $resourceApp) / $requiredResource.Count) * 100)}
            New-DebugLine ("Getting enterprise application permissions for app {0}" -f $resourceApp.resourceAppId)
            $enterPriseAppPermissions = Invoke-MSPGraphRequest -Endpoint ("servicePrincipals?`$filter=appid eq '{0}'&`$select=oauth2PermissionScopes" -f $resourceApp.resourceAppId) -AsMSP | Select-Object -ExpandProperty oauth2PermissionScopes
            [pscustomobject]$applicationAndRoles = @{
                enterpriseApplicationId = $resourceApp.resourceAppId
                scope                   = ($enterPriseAppPermissions | Where-Object { $_.id -in $resourceApp.resourceAccess.id } | Select-Object -ExpandProperty value | Where-Object { $_ -notin $ignoreRoleList }) -join ","
            }
            if (($applicationAndRoles.scope) -and ($applicationAndRoles.enterpriseApplicationId -notin $ignoreAppList)) {
                $bodyBuilder += $applicationAndRoles
            }
        }
    }
    catch {
        Write-Error (Format-ErrorCode $_)
        return
    }

    # consent body for all permissions
    $applicationGrant = $bodyBuilder | foreach { @{enterpriseApplicationId = $_.enterpriseApplicationId; scope = $_.scope } }
    $applicationConsentBody = @{
        applicationId     = $script:mspToolBoxSession.ApplicationID
        applicationGrants = @($applicationGrant)
    } | ConvertTo-Json -Depth 4

    # output table
    $outputTable = [PSCustomObject]@{
        Success = 0
        Failed  = 0
    }

    # loop through all customer(s)
    foreach ($customer in $CustomerTenantID) {
        if ($progress -eq $true) { Write-Progress -Activity "Granting Application Permissions" -Status "Granting $([array]::IndexOf($CustomerTenantID, $customer))/$($CustomerTenantID.Count)..." -PercentComplete (([array]::IndexOf($CustomerTenantID, $customer) / $CustomerTenantID.Count) * 100) }
        # Remove any existing Grants
        New-DebugLine "Processing tenantID $customer"
        try {
            $applicationRevokeSplat = @{
                Method = "Delete"
                Uri    = "https://api.partnercenter.microsoft.com/v1/customers/$($customer)/applicationconsents/$($script:mspToolBoxSession.ApplicationId)"
                Header = $cspAuthHeader
            }
            Invoke-RestMethod @applicationRevokeSplat | Out-Null
            New-DebugLine "Removed application grant successfully"
        }
        catch {
            $outputTable.Failed++
            New-DebugLine "Failed to remove application grant"
            Write-Error "Customer Tenant ID: $customer .$(Format-ErrorCode $_)"
            continue
        }

        # Grant application
        $applicationConsentSplat = @{
            Method  = "Post"
            Uri     = "https://api.partnercenter.microsoft.com/v1/customers/$($customer)/applicationconsents"
            Body    = $applicationConsentBody
            Header  = $cspAuthHeader
            Content = "application/json"
        }
        try {
            Invoke-RestMethod @applicationConsentSplat | Out-Null
            New-DebugLine "Application granted successfully"
        }
        catch {
            $outputTable.Failed++
            New-DebugLine "Failed to grant application successfully"
            Write-Error "Customer Tenant ID: $customer .$(Format-ErrorCode $_)"
            continue
        }
        $outputTable.Success++
    }
    return $outputTable
}