param([string]$Username)
$User = Get-ADUser $Username -Properties MemberOf
if (!$User) {
    Write-Host "User not found"
    exit
}
foreach ($group in $User.MemberOf) {
    Remove-ADGroupMember -Identity $group -Members $Username -Confirm:$false
}
Write-Host "Removed all group memberships for $Username"