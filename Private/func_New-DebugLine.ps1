function New-DebugLine {
    param (
        [CmdletBinding()] 
        [parameter(Mandatory)][string]$Message
    )
    $timeStamp = Get-Date -Format "MM-dd-yy HH:mm:ss"
    Write-Debug "$timeStamp | MSPToolbox | $message"
}