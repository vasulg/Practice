param([string]$Username)
Import-Module MSOnline
$User = Get-MsolUser -UserPrincipalName "$Username@homestart.com.au"
if (!$User) {
    Write-Host "User not found"
    exit
}
$License = "homestart:ENTERPRISEPACK" # Adjust to your tenant's license SkuPartNumber
Set-MsolUserLicense -UserPrincipalName $User.UserPrincipalName -AddLicenses $License
Write-Host "Assigned Microsoft 365 E3 license to $Username"