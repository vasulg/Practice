param([string]$username)
Get-ADComputer -Filter * | ForEach-Object {
    $computer = $_.Name
    try {
        $sessions = quser /server:$computer 2>$null
        if ($sessions -match $username) {
            $props = Get-ADComputer $computer -Properties *
            Write-Host "User $username is logged in to $computer"
            Write-Host ($props | Format-List | Out-String)
        }
    } catch {}
}