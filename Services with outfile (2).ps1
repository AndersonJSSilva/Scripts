$hostnames = Get-Content c:\temp\servers.txt

$saida=""
foreach($server in $hostnames)
{
    try {
    $services = Get-WmiObject -computer $server Win32_Service | ?{$_.startname -like "*adm*"}
    foreach($service in $services)
    {
        if($service)
        { 
           Write-Host $server
           $saida +="`n"+ $server +"`n"
            $saida +="`t"+$service.displayname +" - "  + $service.startname + "`n"
        }
    }
    }catch{}
    
        
}
#$saida
if(!$saida)
{
    write-host "nada encontrado" 
    
} else
{
    Set-Content -Path C:\SERVERS\Result_services_HMG.txt -Value $saida
    
}