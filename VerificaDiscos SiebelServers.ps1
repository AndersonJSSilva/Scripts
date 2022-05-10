$Servers = @("crmserprd01","crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02","crmwsprd01","crmwsprd02","crmgtwprd01","crmgtwprd02","crmbipprd01","crmappprd02")
$result = @()
foreach($srv in $servers)
{
    
    $result += gwmi win32_logicaldisk -computer $srv -filter "drivetype=3" 
}
$result | ft PSComputerName,deviceid, @{Label="Size";Expression={"{0:N2}" -f ((($_.size/1024)/1024)/1024)+" GB" }}, @{Label="Free Space";Expression={"{0:N2}" -f ((($_.freespace/1024)/1024)/1024)+" GB" }}, @{Label="Used";Expression={"{0:N2}" -f (((($_.size - $_.freespace)/1024)/1024)/1024)+" GB" }}