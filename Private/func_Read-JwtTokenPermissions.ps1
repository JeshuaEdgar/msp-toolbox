function Read-JwtTokenPermissions {
    param (
        [string]$Token
    )
    $tokenPayload = $Token.Split(".")[1].Replace('-', '+').Replace('_', '/')
    while ($tokenPayload.Length % 4) { $tokenPayload += "=" }
    $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
    $applicationRoles = [System.Text.Encoding]::ASCII.GetString($tokenByteArray) | ConvertFrom-Json | Select-Object -ExpandProperty scp
    return ($applicationRoles -split " ")
}