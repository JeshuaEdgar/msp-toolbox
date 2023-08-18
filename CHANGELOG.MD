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

- ```Invoke-MSPGraphRequest```
    - Previously called ```New-GraphRequest```
    - Returns 'value' by default if present. No need to add ```.value``` to extract it
    - Pagination of data if ```@odata.nextLink``` is returned
    - ```$Customer``` boolean switch, if you want to do a Graph request on your CSP tenant, default is set to ```$true```
    - Default method is now set to ```Get```

# [0.0.1-alpha]

## Added

- ```Connect-MSPToolbox```
- ```Connect-MSPToolboxPartner```
- ```Get-MSPToolboxCurrentConnection```
- ```Get-MSPToolboxPartnerList```
- ```New-GraphRequest```