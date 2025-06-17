$username = Read-Host "Enter the username of the AD account"
$days = Read-Host "Enter the number of days to check for changes"
$date = (Get-Date).AddDays(-$days)

Get-ADObject -Filter "SamAccountName -eq '$username' -and WhenChanged -ge '$date'" -Properties * |
Select-Object Name, ObjectClass, WhenChanged, @{Name="Changed By";Expression={(Get-ADObject $_.lastKnownParent).Name}},@{Name="Change Type";Expression={$_.LastKnownParent}} |
Format-Table -AutoSize