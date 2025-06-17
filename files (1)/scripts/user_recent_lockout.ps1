param([string]$username)
$days = 3
$start = (Get-Date).AddDays(-$days)
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625; StartTime=$start} | 
    Where-Object { $_.Properties[5].Value -eq $username } | 
    Select-Object TimeCreated, Id, Message | Format-Table -AutoSize