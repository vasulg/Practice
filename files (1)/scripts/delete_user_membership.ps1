param([string]$username, [string]$groupname)
Remove-ADGroupMember -Identity $groupname -Members $username -Confirm:$false
Write-Host "Removed $username from $groupname."