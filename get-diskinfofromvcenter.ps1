$vms = Get-vmHost -Name esxiprd19.unimedrj.root | get-vm
foreach($vm in $vms)
{
    gwmi win32_logicaldisk -computer $vm -filter "drivetype=3" | ft PSComputerName,deviceid, @{Label="Size";Expression={"{0:N2}" -f ((($_.size/1024)/1024)/1024)+" GB" }}, @{Label="Free Space";Expression={"{0:N2}" -f ((($_.freespace/1024)/1024)/1024)+" GB" }}, @{Label="Used";Expression={"{0:N2}" -f (((($_.size - $_.freespace)/1024)/1024)/1024)+" GB" }}
}

gwmi win32_logicaldisk -computer gedceprd01 -filter "drivetype=3" | ft PSComputerName,deviceid, @{Label="Size";Expression={"{0:N2}" -f ((($_.size/1024)/1024)/1024)+" GB" }}, @{Label="Free Space";Expression={"{0:N2}" -f ((($_.freespace/1024)/1024)/1024)+" GB" }}, @{Label="Used";Expression={"{0:N2}" -f (((($_.size - $_.freespace)/1024)/1024)/1024)+" GB" }}



$adapters = gwmi -ComputerName "polnhmg01" Win32_NetworkAdapterConfiguration |? {$_.ipenabled -eq $true}
$adapters | select description,Index,TcpIpNetbiosOptions,IPEnabled|ft -a
$adapters |%{$_.SetTcpipNetbios(0)}
foreach($nic in $adapters)
{
    $nic.SetTcpipNetbios(0)
}

$servers = "polnhmg01"
Foreach ($server in $servers){
  $adapter=(gwmi -computer $server win32_networkadapterconfiguration | where {$_.ipenabled -eq $true})
  $adapter.SetTcpipNetbios(0)
}


$Servers = @("crmserprd01","crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02","crmwsprd01","crmwsprd02","crmgtwprd01","crmgtwprd02","crmbipprd01")
foreach($srv in $servers)
{
     gwmi win32_logicaldisk -computer $srv -filter "drivetype=3" | ft PSComputerName,deviceid, @{Label="Size";Expression={"{0:N2}" -f ((($_.size/1024)/1024)/1024)+" GB" }}, @{Label="Free Space";Expression={"{0:N2}" -f ((($_.freespace/1024)/1024)/1024)+" GB" }}, @{Label="Used";Expression={"{0:N2}" -f (((($_.size - $_.freespace)/1024)/1024)/1024)+" GB" }}
}
 gwmi win32_logicaldisk -computer "uninet" -filter "drivetype=3" | ft PSComputerName,deviceid, @{Label="Size";Expression={"{0:N2}" -f ((($_.size/1024)/1024)/1024)+" GB" }}, @{Label="Free Space";Expression={"{0:N2}" -f ((($_.freespace/1024)/1024)/1024)+" GB" }}, @{Label="Used";Expression={"{0:N2}" -f (((($_.size - $_.freespace)/1024)/1024)/1024)+" GB" }}