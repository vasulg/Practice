param([string]$username)
Get-ADComputer -Filter * | ForEach-Object {
    $computer = $_.Name
    try {
        $sessions = quser /server:$computer 2>$null
        if ($sessions -match $username) {
            $ip = (Test-Connection -ComputerName $computer -Count 1).IPv4Address.IPAddressToString
            Write-Host "$username is logged in on $computer with IP: $ip"
        }
    } catch {}
}