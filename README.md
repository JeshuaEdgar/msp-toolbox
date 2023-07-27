# MSPToolBox

![PSGalleryVersion](https://img.shields.io/powershellgallery/v/MSPToolBox?style=flat-square) ![PSGalleryDownloads](https://img.shields.io/powershellgallery/dt/MSPToolBox?style=flat-square)

Module is in progress... created with MSP's in mind for unattended scripts on for example Microsoft Azure Runbooks using the [Secure App Model](https://www.cyberdrain.com/using-the-secure-app-model-to-connect-to-microsoft-partner-resources/) and the PartnerCenter module for multi-tenant scripting. See below for some example(s) on how to use it.

Special credits to [Kelvin Tegelaar](https://github.com/KelvinTegelaar) for coining the Secure App Model for MSP's

## [Changelog](./CHANGELOG.MD)

## Installation

Before you install the module, you will need to make sure you have the PartnerCenter module intalled in your environment.

```powershell
Install-Module PartnerCenter
```

### PowerShell Gallery

Go ahead and install the MSPToolbox module by running the following:

```powershell
Install-Module MSPToolbox -AllowPrerelease
```

### Manual

You can also download a release from Github if that is your prefered method. Download the source code and paste it in your modules folder.

You can look this up by running ```$env:PSModulePath -split ";"```

## Connecting/getting tokens

To connect to the Partner Center use the following

```powershell
Connect-MSPToolbox -ApplicationID "YourSecretApplicationID" -ApplicationSecret "YourSecretApplicationID" -RefreshToken "ThatExtremelyLongPeskyRefreshToken" -TenantID "YourTenantID"  
```

Getting a Graph token for Partner tenant you want to control is easy, just provide the ```TenantID``` for the tenant you want to connect to after running ```Connect-MSPToolbox```

```powershell
Connect-MSPToolboxPartner -TenantID "TenantIDYouWantToConnectTo"
```

Once connected to a Partner tenant you are able to forget about tokens, just pass your endpoint, method and body and you are set!

## Getting partner resources

Get a list of all tenants you manage in the Partner Center (get tenant Id's etc.)

```powershell
Get-MSPToolboxPartnerList
```

## Example(s)

```powershell
# Fill in all parameters to connect to your Secure App Model application
$connect = @{
    ApplicationID     = "YourSecretApplicationID"
    ApplicationSecret = "YourSecretApplicationID"
    Refreshtoken      = "ThatExtremelyLongPeskyRefreshToken"
    TenantID          = "YourTenantID"
}

Connect-MSPToolbox @connect

foreach ($partner in Get-MSPToolboxPartnerList){
    Connect-MSPToolboxPartner -TenantID $partner.CustomerId

    # Run Microsoft Graph requests from here
    # We are showing an example that uses the following documentation: https://learn.microsoft.com/en-us/graph/api/organization-get?view=graph-rest-1.0

    Invoke-GraphRequest -Endpoint "organization"
}
```