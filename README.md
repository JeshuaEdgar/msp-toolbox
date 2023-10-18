# MSPToolBox

![PSGalleryVersion](https://img.shields.io/powershellgallery/v/MSPToolBox?style=flat-square) ![PSGalleryDownloads](https://img.shields.io/powershellgallery/dt/MSPToolBox?style=flat-square)

Created with MSP's in mind for unattended scripts on for example Microsoft Azure Runbooks using the [Secure App Model](https://www.cyberdrain.com/connect-to-exchange-online-automated-when-mfa-is-enabled-using-the-secureapp-model/) and the PartnerCenter module for multi-tenant scripting. See below for some [example(s)](#examples) on how to use it.

Special credits to [Kelvin Tegelaar](https://github.com/KelvinTegelaar) for making the Secure App Model popular among MSP's

Microsoft's documentation about the [Secure App Model](https://learn.microsoft.com/en-us/powershell/partnercenter/secure-app-model?view=partnercenterps-1.5&viewFallbackFrom=partnercenterps-3.0)

## Changelog

For the changelog please look into the [changelog file](./CHANGELOG.MD)


## Installation

Install the MSPToolbox module by running the following:

```powershell
Install-Module MSPToolbox
```

## Documentation

For the documentation please look into the [docs folder](Docs/) or by invoking `Get-Help {cmdlet} -Full`

## Connecting

To connect to the Partner Center use the following

```powershell
Connect-MSPToolbox -ApplicationID "YourSecretApplicationID" -ApplicationSecret ("YourApplicationSecret" | Convertto-SecureString -AsPlainText) -RefreshToken ("ThatExtremelyLongRefreshToken" | Convertto-SecureString -AsPlainText) -TenantID "YourTenantID"  
```

Getting a Graph token for Partner tenant you want to control is easy, just provide the `-TenantID` for the tenant you want to connect to after running `Connect-MSPToolbox`

```powershell
Connect-MSPToolboxPartner -TenantID "TenantIDYouWantToConnectTo"
```

Once connected to a Partner tenant you are able to forget about tokens, just pass your endpoint, method and body and you are set!

If the endpoint reports errors these will output as an errorobject, easy to decode what's going on.

## Getting partner resources

Get a list of all tenants you manage in the Partner Center (get tenant Id's etc.)

```powershell
Get-MSPToolboxPartnerList
```

Note that the tenant ID in this return object is denoted by `customerId`.

## Examples

### Connecting with MSPToolbox

```powershell
# Fill in all parameters to connect to your Secure App Model application
$connect = @{
    ApplicationID     = "YourSecretApplicationID"
    ApplicationSecret = "YourApplicationSecret" | Convertto-SecureString -AsPlainText
    Refreshtoken      = "ThatExtremelyLongRefreshToken" | Convertto-SecureString -AsPlainText 
    TenantID          = "YourTenantID"
}

Connect-MSPToolbox @connect

foreach ($partner in Get-MSPToolboxPartnerList){
    Connect-MSPToolboxPartner -TenantID $partner.customerId

    # Run Microsoft Graph requests from here
    # We are showing an example that uses the following documentation: https://learn.microsoft.com/en-us/graph/api/organization-get?view=graph-rest-1.0

    Invoke-MSPGraphRequest -Endpoint "organization"
}
```

### Granting application permissions across your tenants

This requires the delegated permission `user_impersonation` from the Microsoft Partner Center in your Azure AD Application. It also requires the `Application.Read.All` permission, this will read out the permissions that are needed by your CSP application and grant them at the partner side, of course if you have a `ReadWrite` permissions you don't need to add it. If these are not present, the cmdlet will return an error.

First of all make sure you connect with `Connect-MSPToolbox`, this is necesary. Since the information of your application you want to grant is stored within the session of the module no need to use any refresh tokens or application secrets.

Note: it is okay for some of your tenants to fail, keep an eye on the error messages. The tenant ID will be outputted in these errors for you to investigate these.

```powershell
# For all your tenants
Grant-CSPApplication

# Output (while running):
Granting Application Permissions [Granting 38/394...   ]

# Output (when finished):
Success Failed                                                                                                          
------- ------                                                                                                          
    374     20

# For a specific tenant
Grant-CSPApplication -CustomerTenantID "6babcaad-604b-40ac-a9d7-9fd97c0b779f"
```