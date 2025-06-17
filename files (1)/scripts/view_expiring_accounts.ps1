Get-ADUser -Filter * -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" | 
    Select-Object DisplayName,
        @{Name="ExpiryDate"; Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
    Where-Object { $_.ExpiryDate -ne $null } |
    Sort-Object ExpiryDate | Format-Table -AutoSize