function Format-ErrorCode {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )
    try {
        # Verbose output to generate debuggin info
        New-DebugLine "Error full exception type: $($ErrorObject.Exception.GetType().FullName)"
        New-DebugLine "Error message: $($ErrorObject.Exception.Message)"
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
                New-DebugLine "Converted JSON out of error object"

                # debug properties
                $errorJson.PsObject.Properties | foreach { New-DebugLine $_ }

                # testing the output
                if ($null -ne $errorJson.error_description) { return $errorJson.error_description }
                if ($null -ne $errorJson.error.code -and $null -ne $errorJson.error.message) { return "$($errorJson.error.code): $($errorJson.error.message)" }
                if ($null -ne $errorJson.message) { 
                    try {
                        $parsed = ConvertFrom-Json $errorJson.message
                        if ($null -ne $parsed.'odata.error'.code) {
                            return "$($parsed.'odata.error'.code). $($parsed.'odata.error'.message.value)"
                        }
                        else {
                            return $errorJson.message
                        }
                    }
                    catch {
                        return $errorJson.message
                    }
                }
                # else return just the error
                else { return $errorJson }
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