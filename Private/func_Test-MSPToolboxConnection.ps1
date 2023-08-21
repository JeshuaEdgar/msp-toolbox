function Test-MSPToolboxConnection {
    $functionCallStack = (Get-PSCallStack | Select-Object -ExpandProperty FunctionName)[1]
    $functionExceptions = @("Connect-MSPToolbox")
    
    if ([string]::IsNullOrEmpty($script:mspToolBoxSession.GraphAuthHeader)) {
        if ($functionCallStack -notin $functionExceptions) {
            Write-Error "Please connect to OpenProvider first using: 'Connect-MSPToolbox'"
        }
    }
}