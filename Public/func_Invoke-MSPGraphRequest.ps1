function Invoke-MSPGraphRequest {
    param (
        [CmdletBinding()]
        [parameter (Mandatory = $true)][string]$Endpoint,
        [parameter (Mandatory = $false)][ValidateSet("Delete", "Get", "Patch", "Post", "Put")]$Method = "Get",
        $Body,
        [switch]$Beta
    )
    Test-MSPToolboxConnection

    if ($Beta) {
        $baseURL = "https://graph.microsoft.com/{0}/" -f "beta"
    }
    else {
        $baseURL = "https://graph.microsoft.com/{0}/" -f "v1.0"
    }

    if ($Endpoint.StartsWith("/")) { $Endpoint = $Endpoint.Substring(1) }

    #create the splat first
    $reqSplat = @{
        Method  = $Method
        URI     = $baseUrl + $Endpoint
        Headers = $script:CustomerAuthHeader
    }
    if ($Body -is [hashtable] -or [pscustomobject]) {
        $reqSplat.Body += $Body | ConvertTo-Json -Depth 5
    }
    elseif ($Body) {
        Write-Warning "Body is not of type [hashtable] or [PsCustomObject]"
    }

    $reqSplat.GetEnumerator() | ForEach-Object {
        if ($_.Value -is [System.Collections.Hashtable]) {
            Write-Debug "MSPToolbox | -------------- Body Values"
            $_.Value.GetEnumerator() | ForEach-Object {
                if ($_.Key -eq "Authorization") {
                    $_.Value = ($_.Value.Substring(0, 31) + "..." + ($_.value.Substring($_.value.length - 16)))
                }
                Write-Debug "MSPToolbox | Body Key     : $($_.Key)"
                Write-Debug "MSPToolbox | Body Value   : $($_.Value)"
            }
        }
        else {
            Write-Debug "MSPToolbox | Param Key    : $($_.Key)"
            Write-Debug "MSPToolbox | Param Value  : $($_.Value)"
        }
    }

    if ($null -eq $script:CustomerAuthHeader) {
        throw "MSPToolbox | You are not connected to a Partner, please run 'Connect-MSPPartner' to connect to a Partner or use '`-AsMSP' to run the Graph Request under the MSP tenant"
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
                $request = Invoke-RestMethod $request.'@odata.nextLink' -Headers $script:CustomerAuthHeader 
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