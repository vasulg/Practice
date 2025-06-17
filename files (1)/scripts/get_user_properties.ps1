param([string]$username)
Get-ADUser $username -Properties * | Select-Object * | Format-List