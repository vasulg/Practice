# get_lockouts.ps1
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security';
    ID = 4740;
    StartTime = (Get-Date).AddDays(-1)
} | ForEach-Object {
    @{
        TimeCreated = $_.TimeCreated
        AccountLocked = $_.Properties[0].Value
        CallerComputer = $_.Properties[1].Value
    }
}

$events | ConvertTo-Json