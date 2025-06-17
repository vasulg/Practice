param([string]$machinename)
Invoke-Command -ComputerName $machinename -ScriptBlock {
    Get-PSDrive C | Select-Object Used, Free, @{Name="Total(GB)";Expression={($_.Used + $_.Free)/1GB}}
}