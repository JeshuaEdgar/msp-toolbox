# [1.2.1]

## Added

- Logo in PowerShellGallery
- `Disconnect-MSPToolbox`, how did I not think about this before..?

## Fixed

-

# [1.2.0]

## Changed

### Breaking change!

`Connect-MSPToolbox` no longer accepts plaintext input for the following parameters:

- `-ApplicationSecret`
- `-RefreshToken`

Please add `| ConvertTo-SecureString -AsPlainText -Force` at the end of your secrets in your script (for example from AZ Keyvault) and you should be good to go.

## Added

- New cmdlet `Grant-CSPApplication` !
  - This will grant your CSP application across all your managed tenants, if the app is already present in the tenant it will remove the application and grant it again, this is useful when you need to update the permissions since those won't be copied over anymore.
  - Optional parameter `-CustomerTenantID` for when you want to run it on just one tenant.
  - Example can be found in the [examples section](/README.md#examples)
- Debugging on all cmdlet's to help troubleshoot + a new internal debug printer

## Fixed

- Error formatting/output is greatly enhanced, if you are still experiencing issues please open an issue
- `GetMSPToolboxPartnerList` now uses `Invoke-MSPGraphRequest`

# [1.1.1]

## Added

- Reading out permissions with the `-Debug` switch on `Connect-MSPToolbox` and `Connect-MSPPartner`
- Optional parameter `-Scope` was added to `Connect-MSPPartner`, by default this is `https://graph.microsoft.com/.default`

## Changed

- `-Customer [bool]` is now `-AsMSP [switch]` on `Invoke-MSPGraphRequest`. Simply add this switch if you want to run a command on the MSP tenant

# [1.1.0]

## Removed

- Dependencies! Module is now independant, switched `New-PartnerAccessToken` for `Invoke-RestMethod`'s
  - With this comes a drastic improvement on speed when connecting to multiple tenants

## Added

- Debugging mode in tools and other cmdlets
- Check if tokens are about to expire, if so generate new ones

# [1.0.1]

## Fixed

- Accept `[hashtable]` and `[pscustomobject]` on `Invoke-MSPGraphRequest`
- `Write-Error` is the default method for handling errors now

## Added

- Alias for `Connect-MSPPartner`: `Connect-MSPToolboxPartner`

# [1.0.0]

This marks the first non-prerelease version of MSPToolbox! I feel like this version is production ready. Must there be any problems you are facing please don't hesitate to make an issue request. Please read the changelog below for previous versions. For this first non-prerelease version the following has been changed/added:

## Changed

- `Connect-MSPToolboxPartner` is now `Connect-MSPPartner`
- Docs have been updated, use `Get-Help <command>` to get help and/or examples on how to use this module

## Fixed

- Dev environment has been fixed

# [0.1.7-beta]

## Fixed

- `Content-Type` of requests is now `application/json`
- Body parameter for `Invoke-MSPGraphRequest` was set to `[array]`, this is now accepts a `[hashtable]`

# [0.1.5-alpha]

## Fixed

- Module now exports cmdlet's instead of functions
- PartnerCenter module import
- Unnecesary throws

# [0.1.0-alpha]

## Changed

- `Invoke-MSPGraphRequest`
  - Previously called `New-GraphRequest`
  - Returns 'value' by default if present. No need to add `.value` to extract it
  - Pagination of data if `@odata.nextLink` is returned
  - `$Customer` boolean switch, if you want to do a Graph request on your CSP tenant, default is set to `$true`
  - Default method is now set to `Get`

# [0.0.1-alpha]

## Added

- `Connect-MSPToolbox`
- `Connect-MSPToolboxPartner`
- `Get-MSPToolboxCurrentConnection`
- `Get-MSPToolboxPartnerList`
- `New-GraphRequest`
