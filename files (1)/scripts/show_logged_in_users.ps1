Get-ADComputer -Filter * | ForEach-Object {
    $computer = $_.Name
    try {
        $sessions = quser /server:$computer 2>$null
        if ($sessions) {
            Write-Host "On $computer:`n$sessions`n"
        }
    } catch {}
}