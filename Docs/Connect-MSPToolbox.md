---
external help file: MSPToolBox-help.xml
Module Name: MSPToolBox
online version:
schema: 2.0.0
---

# Connect-MSPToolbox

## SYNOPSIS
This will connect to the secure app model application hosted in your CSP tenant

## SYNTAX

```
Connect-MSPToolbox [-ApplicationID] <String> [-ApplicationSecret] <String> [-Refreshtoken] <String>
 [-TenantID] <String> [<CommonParameters>]
```

## DESCRIPTION
This will connect to the secure app model application hosted in your CSP tenant

## EXAMPLES

### Example 1
```powershell
PS C:\> Connec-MSPToolbox -ApplicationID "12abc-****************" -ApplicationSecret "************" -RefreshToken "***********" -TenantID "112abc-***************"
```

All parameters are mandatory, to create the Azure AD Application with the required permissions visit [this blog](https://www.cyberdrain.com/using-the-secure-app-model-to-connect-to-microsoft-partner-resources/)

## PARAMETERS

### -ApplicationID
The Application ID of the application you are trying to connect to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicationSecret
The Application Secret, must be a valid, non-expired secret

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Refreshtoken
The refresh token received from setting up your application using the [blog](https://www.cyberdrain.com/using-the-secure-app-model-to-connect-to-microsoft-partner-resources/)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantID
The Tenant ID of where the application is hosted

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
