param([string]$username, [string]$groupname)
Add-ADGroupMember -Identity $groupname -Members $username
Write-Host "Added $username to $groupname."