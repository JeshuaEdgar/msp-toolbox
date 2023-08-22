function Test-MSPToolboxConnection {
    $functionCallStack = (Get-PSCallStack | Select-Object -ExpandProperty FunctionName)[1]
    $functionExceptions = @("Connect-MSPToolbox")

    $sessionData = $script:mspToolBoxSession
    
    if ($functionCallStack -notin $functionExceptions) {
        if ([string]::IsNullOrEmpty($sessionData.MSPAuthHeader)) {
            Write-Error "Please connect to OpenProvider first using: 'Connect-MSPToolbox'"
        }
        if (-not [string]::IsNullOrEmpty($sessionData.CustomerTokenExpiry)) {
            if ($sessionData.CustomerTokenExpiry -lt (Get-Date).AddMinutes(-15)) {
                Write-Warning "Tokens for customer are about to expire, generating new ones"
                Connect-MSPPartner -TenantID $sessionData.CustomerTenantID | Out-Null
            }
        }
        if (-not [string]::IsNullOrEmpty($sessionData.MSPTokenExpiry)) {
            if ($sessionData.MSPTokenExpiry -lt (Get-Date).AddMinutes(-15)) {
                Write-Warning "MSP token is about to expire, generating a new one"
                Connect-MSPToolbox -TenantID $sessionData.TenantID -ApplicationID $sessionData.ApplicationID -ApplicationSecret $sessionData.ApplicationSecret -Refreshtoken $sessionData.Refreshtoken | Out-Null
            }
        }
    }
}