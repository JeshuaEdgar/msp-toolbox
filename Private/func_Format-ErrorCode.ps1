function Format-ErrorCode {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )
    try {
        # Verbose output to generate debuggin info
        Write-Debug "Error full exception type: $($ErrorObject.Exception.GetType().FullName)"
        Write-Debug "Error message: $($ErrorObject.Exception.Message)"
        if ($ErrorObject.Exception -is [Microsoft.PowerShell.Commands.HttpResponseException]) {
            switch ($PSVersionTable.PSEdition) {
                "Desktop" {
                    $ErrorObject = New-Object System.IO.StreamReader($ErrorObject.Exception.Response.GetResponseStream())
                    $ErrorObject.BaseStream.Position = 0 
                    $ErrorObject.DiscardBufferedData() 
                    $ErrorObject = $ErrorObject.ReadToEnd()
                }
                "Core" { $ErrorObject = $ErrorObject.ErrorDetails.Message }
            }
            $errorJson = $ErrorObject | ConvertFrom-Json
            # getting token error
            if ($errorJson.error) {
                return $errorJson.error_description
            }
            # graph error
            elseif ($errorJson.error.message) {
                return "Error $($errorJson.error.code)! $($errorJson.error.message)"
            }
            # else return just the error
            else {
                return $errorJson
            }
        }
        else {
            return $ErrorObject.Exception.Message
        }
    }
    catch {
        return $_.Exception.Message
    }
}