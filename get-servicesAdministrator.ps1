$hostnames = Get-Content c:\temp\servers.txt

foreach($server in $hostnames)
{
    try {
    $services = Get-WmiObject -computer $server Win32_Service | ?{$_.startname -like "*adm*"}
    foreach($service in $services)
    {
        if($service)
        { 
           Write-Host $server
           $service | ft displayname, startname
        }
    }
    }catch{}

}
