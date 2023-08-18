# MSPToolBox

![PSGalleryVersion](https://img.shields.io/powershellgallery/v/MSPToolBox?style=flat-square) ![PSGalleryDownloads](https://img.shields.io/powershellgallery/dt/MSPToolBox?style=flat-square)

Created with MSP's in mind for unattended scripts on for example Microsoft Azure Runbooks using the [Secure App Model](https://www.cyberdrain.com/connect-to-exchange-online-automated-when-mfa-is-enabled-using-the-secureapp-model/) and the PartnerCenter module for multi-tenant scripting. See below for some [example(s)](#examples) on how to use it.

Special credits to [Kelvin Tegelaar](https://github.com/KelvinTegelaar) for making the Secure App Model popular among MSP's

Microsoft's documentation about the [Secure App Model](https://learn.microsoft.com/en-us/powershell/partnercenter/secure-app-model?view=partnercenterps-1.5&viewFallbackFrom=partnercenterps-3.0)

## Changelog

For the changelog please look into the [changelog file](./CHANGELOG.MD)


## Installation

Before you install the module, for the best results, you will need to make sure you have the PartnerCenter module intalled in your environment.

```powershell
Install-Module PartnerCenter
```

Go ahead and install the MSPToolbox module by running the following:

```powershell
Install-Module MSPToolbox -AllowPrerelease
```

## Documentation

For the documentation please look into the [docs folder](Docs/)

## Connecting

To connect to the Partner Center use the following

```powershell
Connect-MSPToolbox -ApplicationID "YourSecretApplicationID" -ApplicationSecret "YourSecretApplicationID" -RefreshToken "ThatExtremelyLongRefreshToken" -TenantID "YourTenantID"  
```

Getting a Graph token for Partner tenant you want to control is easy, just provide the ```TenantID``` for the tenant you want to connect to after running ```Connect-MSPToolbox```

```powershell
Connect-MSPToolboxPartner -TenantID "TenantIDYouWantToConnectTo"
```

Once connected to a Partner tenant you are able to forget about tokens, just pass your endpoint, method and body and you are set!

If the endpoint reports errors these will output as a shiny errorobject, easy to decode what's going on.

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
    Refreshtoken      = "ThatExtremelyLongRefreshToken"
    TenantID          = "YourTenantID"
}

Connect-MSPToolbox @connect

foreach ($partner in Get-MSPToolboxPartnerList){
    Connect-MSPToolboxPartner -TenantID $partner.CustomerId

    # Run Microsoft Graph requests from here
    # We are showing an example that uses the following documentation: https://learn.microsoft.com/en-us/graph/api/organization-get?view=graph-rest-1.0

    Invoke-MSPGraphRequest -Endpoint "organization"
}
```