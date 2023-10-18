---
external help file: MSPToolBox-help.xml
Module Name: MSPToolBox
online version:
schema: 2.0.0
---

# Connect-MSPPartner

## SYNOPSIS
Use this commandlet to connect to a CSP Partner just by using their tenant ID

## SYNTAX

```
Connect-MSPPartner [-TenantID] <String> [-Scope <String>] [<CommonParameters>]
```

## DESCRIPTION
Use this commandlet to connect to a CSP Partner just by using their tenant ID

## EXAMPLES

### Example 1
```powershell
PS C:\> Connect-MSPPartner -TenantID "12abc-*********************"
```

## PARAMETERS

### -TenantID
Tenant ID of the tenant you wan to connect to

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

### -Scope
Fill a custom scope in if necessary, default is "https://graph.microsoft.com/.default"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
