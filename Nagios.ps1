$servers = Get-Content C:\nagios\servers.txt

$Equipe = " - Windows"
$comentario = "'Windows Update'"

foreach($srv in $servers)
{
     $tmp = $srv + $Equipe
     cscript c:\nagios\nagios_downtime.vbs /H "siecooppprd01 - Windows" /t 700 /c "Change DW" /u _infra-ti_servidores_windows /P 1q2w3e4r
}



cscript c:\nagios\nagios_downtime.vbs /H "solrprd01 - Windows" /t 60 /c "Windows Update" /u _infra-ti_servidores_windows /P 1q2w3e4r
cscript c:\nagios\nagios_downtime.vbs /H "crmaomprd01 - Windows" /t 60 /c "Windows Update" /u _infra-ti_servidores_windows /P 1q2w3e4r
cscript c:\nagios\nagios_downtime.vbs /H "crmeaiprd01 - Windows" /t 60 /c "Windows Update" /u _infra-ti_servidores_windows /P 1q2w3e4r
cscript c:\nagios\nagios_downtime.vbs /H "crmaomprd02 - Windows" /t 60 /c "Windows Update" /u _infra-ti_servidores_windows /P 1q2w3e4r
cscript c:\nagios\nagios_downtime.vbs /H "crmeaiprd01 - Windows" /t 60 /c "Windows Update" /u _infra-ti_servidores_windows /P 1q2w3e4r