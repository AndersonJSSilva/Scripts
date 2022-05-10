$data = Get-Date -Format yyyyMMdd-HHmmss
$file = "siebel_sia.srf"
$bkpfile = "siebel_sia.srf_"+$data

function BakcupCopy-itemSRF ($server, $driver)
{
    #Realiza backup do SRF
    Copy-Item "\\$server\$driver\SIBPRDDIR\siebsrvr\objects\PTB\$file" -Destination "\\$server\$driver\SIBPRDDIR\siebsrvr\objects\PTB\$bkpfile" -force
    #copia o novo SRF 
    Copy-Item "\\crmserprd01\D$\temp\$file" -Destination "\\$server\$driver\SIBPRDDIR\siebsrvr\objects\PTB\$file" -Force
}

function Stop-SiebelServer ($server)
{
    write-host "Parando servico servidor: "$server
    $services = gwmi win32_service -ComputerName $server | ?{$_.displayname -like "Siebel Server*"} 
    foreach($svc in $services)
    {
        $svc.StopService()
    }
    write-host "Servico Parado no servidor: "$server
}

function Start-SiebelServer ($server)
{
    write-host "verificando a existencia de processos sieb* no servidor: "$server
    $process = $null
    $process = gwmi win32_process -ComputerName $server | ?{$_.processname -like "sieb*"}
    while($process)
    {
       Start-Sleep 1
       $process = gwmi win32_process -ComputerName $server | ?{$_.processname -like "sieb*"}
    }
    write-host "iniciando servico no servidor: "$server
    $services = gwmi win32_service -ComputerName $server | ?{$_.displayname -like "Siebel Server*"} 
    foreach($svc in $services)
    {
        $svc.startService()
    }
    write-host "Servico no servidor: "$server
}

################# CRMSERPRD01 #####################
$server = "CRMSERPRD01"
$driver = "D$"
Stop-SiebelServer -server $server
BackupCopy-itemSRF -server $server -driver $driver
Start-SiebelServer -server $server

######### CRMAOMPRD01 ###########
$server = "CRMAOMPRD01"
$driver = "D$"

######### CRMAOMPRD02 ###########
$server = "CRMAOMPRD02"
$driver = "D$"

######### CRMEAIPRD01 ###########
$server = "CRMEAIPRD01"
$driver = "E$"

######### CRMEAIPRD02 ###########
$server = "CRMEAIPRD02"
$driver = "D$"
