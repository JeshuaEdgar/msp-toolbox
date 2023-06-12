function New-MSPGraphRequest {
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

    if ($null -eq $script:CustomerAuthHeader) {
        Write-Warning "You are not using a Partner token, please run 'Connect-MSPToolboxPartner' to connect to a Partner"
        $reqSplat.Headers = $script:GraphAuthHeader
    }

    try {
        return Invoke-RestMethod @reqSplat
    }
    catch {
        throw (Format-ErrorCodes $_).ErrorMessage
    }
}