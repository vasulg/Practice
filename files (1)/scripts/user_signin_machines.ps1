param([string]$username)
Get-ADComputer -Filter * | ForEach-Object {
    $computer = $_.Name
    try {
        $sessions = quser /server:$computer 2>$null
        if ($sessions -match $username) {
            Write-Host "$username has an active session on $computer"
        }
    } catch {}
}