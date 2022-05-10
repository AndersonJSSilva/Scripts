
$MyHost="esxiprd28.unimedrj.root"
$ESXiHost=Get-VMHost $MyHost

<#
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-07" -Path naa.6000d310008a1b000000000000000024 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-08" -Path naa.6000d310008a1b000000000000000025 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-09" -Path naa.6000d310008a1b000000000000000026 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-10" -Path naa.6000d310008a1b000000000000000027 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-11" -Path naa.6000d310008a1b000000000000000028 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-12" -Path naa.6000d310008a1b000000000000000029 -FileSystemVersion 5
#>