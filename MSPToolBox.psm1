#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
#endregion discover module name

#load variables for module
$script:mspToolBoxSession = @{
    ApplicationID       = $null
    ApplicationSecret   = $null
    Refreshtoken        = $null
    TenantID            = $null
    MSPAuthHeader       = $null
    MSPTokenExpiry      = $null
    CustomerAuthHeader  = $null
    CustomerTokenExpiry = $null
    CustomerTenantID    = $null
    ConnectedTenant     = $null
}
#end of variables

#load functions
try {
    foreach ($Scope in 'Public', 'Private') {
        Get-ChildItem (Join-Path -Path $ScriptPath -ChildPath $Scope) -Recurse -Filter "func_*.ps1" | ForEach-Object {
            . $_.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function ($_.BaseName -Split "_")[1] -ErrorAction Stop
            }
        }
    }
    New-Alias -Name "Connect-MSPToolboxPartner" -Value "Connect-MSPPartner" -Scope Global
}
catch {
    Write-Error ("{0}: {1}" -f $_.BaseName, $_.Exception.Message)
    exit 1
}