function Invoke-MSPGraphRequest {
    param (
        [CmdletBinding()]
        [parameter (Mandatory = $true)][string]$Endpoint,
        [parameter (Mandatory = $false)][ValidateSet("Delete", "Get", "Patch", "Post", "Put")]$Method = "Get",
        [bool]$Customer = $true,
        [array]$Body,
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
    if ($Body -is [array]) {
        $reqSplat.Body += $Body
    }

    $reqSplat.GetEnumerator() | ForEach-Object {
        if ($_.Value -is [System.Collections.Hashtable]) {
            $_.Value.GetEnumerator() | ForEach-Object {
                Write-Verbose "Parameter : $($_.Key)"
                Write-Verbose "Value     : $($_.Value)"
            }
        }
        else {
            Write-Verbose "Parameter : $($_.Key)"
            Write-Verbose "Value     : $($_.Value)"
        }
    }

    if (($null -eq $script:CustomerAuthHeader) -or ($Customer -eq $false)) {
        Write-Verbose "You are not using a Partner token, please run 'Connect-MSPToolboxPartner' to connect to a Partner"
        $reqSplat.Headers = $script:GraphAuthHeader
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
        Write-Error (Format-ErrorCode $_).ErrorMessage
    }
}