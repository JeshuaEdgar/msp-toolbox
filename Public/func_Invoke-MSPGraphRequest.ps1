function Invoke-MSPGraphRequest {
    param (
        [CmdletBinding()]
        [parameter (Mandatory = $true)][string]$Endpoint,
        [parameter (Mandatory = $false)][ValidateSet("Delete", "Get", "Patch", "Post", "Put")]$Method = "Get",
        $Body,
        [switch]$Beta
    )
    # checks before connection
    Test-MSPToolboxConnection

    # build the request
    if ($Beta) { $baseURL = "https://graph.microsoft.com/{0}/" -f "beta" }
    else { $baseURL = "https://graph.microsoft.com/{0}/" -f "v1.0" }
    if ($Endpoint.StartsWith("/")) { $Endpoint = $Endpoint.Substring(1) }
    # check if customerAuthHeader is present
    if (-not $script:mspToolBoxSession.CustomerAuthHeader) { $authHeader = $script:mspToolBoxSession.MSPAuthHeader }
    else { $authHeader = $script:mspToolBoxSession.CustomerAuthHeader }
    # make request splat
    $reqSplat = @{
        Method  = $Method
        URI     = $baseUrl + $Endpoint
        Headers = $authHeader
    }
    if ($Body -is [hashtable] -or [pscustomobject]) {
        $reqSplat.Body += $Body | ConvertTo-Json -Depth 5
    }
    elseif ($Body) {
        Write-Warning "Body is not of type [hashtable] or [PsCustomObject]"
    }
    if ($AsMSP) {
        $reqSplat.Headers = $script:mspToolBoxSession.MSPAuthHeader
        New-DebugLine "Running as MSP"
    }

    # debugging
    $reqSplat.GetEnumerator() | ForEach-Object {
        if ($_.Value -is [System.Collections.Hashtable]) {
            New-DebugLine "-------------- Body Values"
            $_.Value.GetEnumerator() | ForEach-Object {
                if ($_.Key -eq "Authorization") {
                    $_.Value = ($_.Value.Substring(0, 31) + "..." + ($_.value.Substring($_.value.length - 16)))
                }
                New-DebugLine "Body Key     : $($_.Key)"
                New-DebugLine "Body Value   : $($_.Value)"
            }
        }
        else {
            New-DebugLine "Param Key    : $($_.Key)"
            New-DebugLine "Param Value  : $($_.Value)"
        }
    }

    # internal function
    function Check-OutputData ($data) {
        if ($data.PsObject.Members.Name -contains "value") { $output = $data.value }
        else { $output = $data }
        return $output
    }

    try {
        $output = @()
        $request = Invoke-RestMethod @reqSplat
        $output += (Check-OutputData $request)
        if ($request.'@odata.nextLink') {
            do {
                $request = Invoke-RestMethod $request.'@odata.nextLink' -Headers $script:mspToolBoxSession.CustomerAuthHeader 
                $output += (Check-OutputData $request)
            } until (
                (-not $request.'@odata.nextLink')
            )
        }
        return $output
    }
    catch {
        Write-Error (Format-ErrorCode $_)
    }
}