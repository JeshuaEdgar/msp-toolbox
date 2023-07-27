function Invoke-MSPGraphRequest {
    param (
        [CmdletBinding()]
        [parameter (Mandatory = $true)][string]$Endpoint,
        [parameter (Mandatory = $true)][ValidateSet("Delete", "Get", "Patch", "Post", "Put")]$Method,
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
        Write-Verbose "Parameter : $($_.Key)"
        Write-Verbose "Value     : $($_.Value)"
    }

    if ($null -eq $script:CustomerAuthHeader) {
        Write-Warning "You are not using a Partner token, please run 'Connect-MSPToolboxPartner' to connect to a Partner"
        $reqSplat.Headers = $script:GraphAuthHeader
    }

    # internal function
    function Add-OutputData ($data) {
        if ($data.PsObject.Members.Name -contains "value") {
            $output += $data.value
        }
        else {
            $output += $data
        }
    }

    try {
        $output = @()
        $request = Invoke-RestMethod @reqSplat
        Add-OutputData $request
        if ($request.'@odata.nextLink') {
            do {
                $request = Invoke-RestMethod $request.'@odata.nextLink' -Headers $script:CustomerAuthHeader 
                Add-OutputData $request
            } until (
                (-not $request.'@odata.nextLink')
            )
        }
        return $output
    }
    catch {
        throw (Format-ErrorCodes $_).ErrorMessage
    }
}