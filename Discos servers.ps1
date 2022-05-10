$servers = @("SCSMPRD01","SCSMWCPRD01","SCSMDBPRD01","SCSMDWDBPRD01","SCSMDWPRD01","SCSMSPPRD01","SCORCHPRD01")

$saida = $null
foreach ($server in $servers)
{
 $saida += Get-WmiObject -ComputerName $server win32_logicaldisk -filter "drivetype = 3"  

}

$saida |  fl systemname,DeviceID,@{name="FreeSpace";expression={("{0:N2}" -f (($_.freespace)/1GB) + "GB")}},@{name="Size";expression={("{0:N2}" -f (($_.size)/1GB) + "GB")}},@{name="UsedSpace";expression={("{0:N2}" -f (($_.size - $_.freespace)/1GB) + "GB")}} | Out-File -FilePath C:\temp\SCSM.txt
$saida.gettype()

Out-File -FilePath C:\temp\SCSM.txt

Set-Content -Path C:\temp\SCSM.txt -Value $saida
