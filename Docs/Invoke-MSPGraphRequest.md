---
external help file: MSPToolBox-help.xml
Module Name: MSPToolBox
online version:
schema: 2.0.0
---

# Invoke-MSPGraphRequest

## SYNOPSIS
Invoke a Microsoft Graph request using the current connected tenant

## SYNTAX

```
Invoke-MSPGraphRequest [-Endpoint] <String> [[-Method] <Object>] [[-Customer] <Boolean>] [[-Body] <Hashtable>]
 [-Beta] [<CommonParameters>]
```

## DESCRIPTION
Invoke a Microsoft Graph request using the current connected tenant

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-MSPGraphRequest -Endpoint "organization"
```

This will return the organization information based on the information found in: https://learn.microsoft.com/en-us/graph/api/organization-get

### Example 2

```powershell
PS C:\> $body = @{
    id = "domain.com"
}

Invoke-MSPGraphRequest -Method Post -Endpoint "/domains" -Body $body
```

You are able to pass down bodies in your request, the commandlet will automatically change the hashtable into a JSON object so that Graph can understand it. Example is taken from: https://learn.microsoft.com/en-us/graph/api/domain-post-domains?tabs=http#example

## PARAMETERS

### -Beta
Use this switch in a command when you want to use a beta endpoint

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
Accepts a hasthable as input

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Customer
Optional boolean if you want to run a graph request on the customer or on the parent tenant. By default this is set to $true

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
The endpoint of the Graph call, this can be found in most of the documentation found on https://learn.microsoft.com/en-us/graph/api/overview?view=graph-rest-1.0

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

### -Method
Define method for the Graph Request

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Delete, Get, Patch, Post, Put

Required: False
Position: 1
Default value: Get
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
