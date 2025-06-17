param([string]$username)
$targetUser = $username
$domainControllers = Get-ADDomainController -Filter *
foreach ($dc in $domainControllers) {
    $events = Get-WinEvent -ComputerName $dc.HostName -FilterHashtable @{ LogName = 'Security'; ID = 4740; StartTime = (Get-Date).AddDays(-7) } -ErrorAction SilentlyContinue
    foreach ($event in $events) {
        $xml = [xml]$event.ToXml()
        $lockedUser = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }
        if ($lockedUser.'#text' -ieq $targetUser) {
            $callerComputer = $xml.Event.EventData.Data | Where-Object { $_.Name -eq 'CallerComputerName' }
            Write-Host "Account '$targetUser' was locked on DC '$($dc.HostName)' from computer: $($callerComputer.'#text')"
        }
    }
}