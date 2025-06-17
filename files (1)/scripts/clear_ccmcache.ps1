param([string]$machinename)
Invoke-Command -ComputerName $machinename -ScriptBlock {
    Remove-Item -Path "C:\Windows\ccmcache\*" -Recurse -Force
}
Write-Host "Cleared CCMCache folder on $machinename."