param(
    [string]$FirstName,
    [string]$LastName,
    [string]$Description,
    [string]$Title,
    [string]$Department
)

$UserName = "$($FirstName.Substring(0, [Math]::Min($FirstName.Length, 1)))$($LastName.Substring(0, [Math]::Min(7, $LastName.Length)))"
$Password = "Henley@Helen@123" | ConvertTo-SecureString -AsPlainText -Force
$OU = "OU=Users,OU=HomeStart,DC=homestart,DC=local"
$Groups = @("All HomeStart", "Azure AD MFA", "Content Manager", "CSOD Production Access", "HomeStart", "HSF BYOD", "HSImprivata Users", "Offline_synce_user", "PhriendlyPhishing", "Proton", "Roaming User Profiles Users and Computers", "Wireless Access", "ZzZ_inMailX.License", "VPN Staff SSL")
$UserPrincipalName = "$UserName@homestart.com.au"
$DisplayName = "$FirstName $LastName"
$Company = "HomeStart"

New-ADUser -Name $DisplayName `
    -GivenName $FirstName `
    -Surname $LastName `
    -UserPrincipalName $UserPrincipalName `
    -SamAccountName $UserName `
    -Path $OU `
    -AccountPassword $Password `
    -Enabled $true `
    -DisplayName $DisplayName `
    -Description $Description `
    -Company $Company `
    -Title $Title `
    -Department $Department `
    -ChangePasswordAtLogon $true `
    -PassThru

foreach ($Group in $Groups) {
    if ($Group -ne "") {
        Add-ADGroupMember -Identity $Group -Members $UserName
    }
}
Write-Host "User $DisplayName ($UserPrincipalName) has been created and added to the specified groups."