Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

$servers = "hubcasprd01","hubcasprd02"

foreach ($server in $servers)
{ 
    $queues = Get-Queue -Server $server
    #Get-Queue -Server $server
    foreach ($queue in $queues)
    {
        $queueid = $queue.identity
        Write-Host "Id da fila: " $queueid -ForegroundColor Green -BackgroundColor red
        $messages = $queue | Get-Message
        # Write-Host $queue | Get-Message | Format-Table -Property recipients,size,subject,FromAddress
        foreach ($msg in $messages)
        {
            Write-Host "`t Remetente: " $msg.FromAddress "Destinatario: "$msg.Recipients "Tamanho: "$msg.Size "Assunto: "$msg.Subject
        }
    }
}

