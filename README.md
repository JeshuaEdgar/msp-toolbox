# MSPToolBox

Module is in progress... created with MSP's in mind for unattended scripts on for example Microsoft Azure Runbooks using the Secure App Model and PartnerCenter for multi-tenant scripting.

## [Changelog](./CHANGELOG.MD)

## Installation

Download this repository as a .zip, in a PowerShell terminal run ```Import-Module .\MSPToolBox.psm1 -Force -Verbose```

## Connecting/getting tokens

To connect to the Partner Center use the following

```powershell
Connect-MSPToolbox -ApplicationID "YourSecretApplicationID" -ApplicationSecret "YourSecretApplicationID" -RefreshToken "ThatExtremelyLongPeskyRefreshToken" -TenantID "YourTenantID"  
```

Getting a Graph token for your tenant you want to control is easy, just provide the ```TenantID``` for the tenant you want to connect to after ```Connect-MSPToolbox```

```powershell
New-MSPToolboxPartnerToken -TenantID "TenantIDYouWantToConnectTo"
```