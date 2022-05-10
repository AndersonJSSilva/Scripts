Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin

$servers = "hubcasprd01","hubcasprd02","excboxprd"
$sender = Read-Host "Remetente"
$recip = Read-Host "Destinatario"
$datainicio = read-host "Data de Inicio ("(Get-Date).AddHours(-24)")"
$datafim = read-host "Data de fim ("(Get-Date).AddHours(5)")"

if(!$datainicio)
{
$datainicio = (Get-Date).AddHours(-10)
}

if(!$datafim)
{
$datafim = (Get-Date).AddHours(10)
}

Write-Host "Pesquisando a partir: "$datainicio -ForegroundColor Green -BackgroundColor Red
foreach ($server in $servers)
{ 
    
    Write-Host "servidor: " $server -ForegroundColor DarkBlue -BackgroundColor Yellow
    if($sender -and $recip){
      
     get-messagetrackinglog -Recipients:$recip -Sender $sender -Server $server -Start "$datainicio" -End "$datafim" | ft -Property timestamp,eventid,source,Sender,Recipients,MessageSubject 

    }
    if ($sender -and !$recip){
    
    get-messagetrackinglog -Sender $sender -Server $server -Start $datainicio -End $datafim | ft -Property timestamp,eventid,source,Sender,Recipients,MessageSubject}
    if ($recip -and !$sender){
     
    get-messagetrackinglog -Recipients:$recip -Server $server -Start $datainicio | ft -Property timestamp,eventid,source,Sender,Recipients,MessageSubject}
     

}
