#Get-WmiObject -Class win32_NTEventlogfile -ComputerName dcbar02 | Where-Object {$_.LogfileName -eq "Security"}
$timestamp = ((Get-Date).ToString('ddMMyyyy'))
$logname = "\\arqprd01\backup_log$\"+$env:COMPUTERNAME+"_SecurityLog_"+$timestamp+".html"
$evtlog = Get-Eventlog -LogName Security
$logfiltrados = @()

if($evtlog){
write-host  "EventLog Lido"
foreach($log in $evtlog)
{
        if(($log.InstanceID -eq '4722') -or ($log.InstanceID -eq '4725')  -or ($log.InstanceID -eq '4720') -or ($log.InstanceID -eq '4738') -or ($log.InstanceID -eq '1102') -or ($log.InstanceID -eq '4728') -or ($log.InstanceID -eq '4729') -or ($log.InstanceID -eq '5139'))
        {
           $logfiltrados += $log
        }
}
}else{"Erro ao ler o arquivo de log"}

if($logfiltrados.count -ge 1){
write-host  "EventLog Filtrado"
$logfiltrados = $logfiltrados | Sort-Object TimeGenerated 
$enddate = [datetime]::ParseExact((Get-Content C:\Script\Timegenerated.txt),'MM/dd/yyyy HH:mm:ss',$null)
foreach($logf in $logfiltrados)
{
    if(($logf.TimeGenerated -gt $enddate))
    {
       $logf | select  machinename, message, instanceid, TimeGenerated | ConvertTo-Html | Out-File $logname -Append
    }
}
$enddate = $logfiltrados[$logfiltrados.count-1].TimeGenerated  -F "dd/MM/yyyy HH:mm:ss"
$enddate | Set-Content C:\Script\Timegenerated.txt
}

exit