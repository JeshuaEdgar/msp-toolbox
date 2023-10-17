function Format-ErrorCode {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )
    try {
        # Verbose output to generate debuggin info
        Write-Debug "MSPToolbox | Error full exception type: $($ErrorObject.Exception.GetType().FullName)"
        Write-Debug "MSPToolbox | Error message: $($ErrorObject.Exception.Message)"
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
            try {
                $errorJson = $ErrorObject | ConvertFrom-Json
                # token error
                if ($errorJson.PsObject.Properties.Match('error_description')) {
                    return $errorJson.error_description
                }
                # graph error
                elseif ($errorJson.PsObject.Properties.Match('error')) {
                    return "$($errorJson.error.code): $($errorJson.error.message)"
                }
                # else return just the error
                else {
                    return $errorJson
                }
            }
            catch {
                return "Error converting from JSON. Original error: $($ErrorObject.Exception.Message)"
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