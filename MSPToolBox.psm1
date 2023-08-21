[CmdletBinding()]

#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
#endregion discover module name

#load variables for module
$mspToolBoxData = @{
    ApplicationID      = $null
    ApplicationSecret  = $null
    Refreshtoken       = $null
    TenantID           = $null
    GraphAuthHeader    = $null
    CustomerAuthHeader = $null
    ConnectedTenant    = $null
}
$script:mspToolBoxSession = $mspToolBoxData
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

# dependencies
$module = Get-Module -ListAvailable PartnerCenter
$loadedModule = Get-Module PartnerCenter
$minVer = "3.0.10"
$importSplat = @{
    Name           = "PartnerCenter"
    MinimumVersion = $minver
    Force          = $true
    Global         = $true
}
if ($PSVersionTable.PSEdition -eq "Core" -and $IsWindows -eq $true) { 
    $importSplat.SkipEditionCheck = $true
}
if (-not ($loadedModule.Version -ge [version]$minVer)) {
    if ($module.version -ge [version]$minver) {
        try {
            Import-Module @importSplat
        }
        catch {
            Write-Error ("Failed to import 'PartnerCenter': {0}" -f $_.Exception.Message)
        }
    }
    elseif ($module.version -lt [version]$minVer) {
        try {
            Update-Module PartnerCenter -Force
            Import-Module @importSplat
        }
        catch {
            Write-Error ("Failed to update 'PartnerCenter': {0}" -f $_.Exception.Message)
        }
    }
    else {
        try {
            Install-Module PartnerCenter -MinimumVersion $minver
            Import-Module @importSplat
        }
        catch {
            Write-Error ("Module 'PartnerCenter' is not present, tried installing but raised an error: {0}" -f $_.Exception.Message)
        }
    }
}