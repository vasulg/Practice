param([string]$Username)
Import-Module MSOnline
$User = Get-MsolUser -UserPrincipalName "$Username@homestart.com.au"
if (!$User) {
    Write-Host "User not found"
    exit
}
Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -RemoveLicenses "homestart:ENTERPRISEPACK" # Adjust SkuPartNumber
Write-Host "Revoked Microsoft 365 E3 license for $Username"