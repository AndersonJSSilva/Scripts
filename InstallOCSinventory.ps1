
$servers = (Get-ADComputer -Filter {OperatingSystem -like "*2003*"} -Properties description -SearchBase  "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root").name
$servers = (Get-ADComputer -Filter {OperatingSystem -like "*2008*"} -Properties description -SearchBase  "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root").name
$servers = (Get-ADComputer -Filter {OperatingSystem -like "*2012*"} -Properties description -SearchBase  "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root").name

$servers.Count
$servers = @("webprd01","webprd02")

foreach($srv in $servers)
{
   
   if (get-wmiobject win32_service -ComputerName $srv | where-object {$_.Name -eq "OCS Inventory Service"} )
   {
        Write-Host $srv já instalado -ForegroundColor Yellow
   }
   else
   {
        if(test-path \\$srv\C$\TEMP)
        {  
            cp \\unimedrj.root\NETLOGON\pacotes\OCS-NG-Windows-Agent-Setup.exe -Destination "\\$srv\C$\TEMP\" -Force
        }
        else
        { 
            New-Item "\\$srv\C$\TEMP" -ItemType Directory
            cp \\unimedrj.root\NETLOGON\pacotes\OCS-NG-Windows-Agent-Setup.exe -Destination "\\$srv\C$\TEMP\" -Force
        }
        Write-Host $srv instalando ... -ForegroundColor Green
        C:\PsTools\PsExec.exe -d \\$srv C:\temp\OCS-NG-Windows-Agent-Setup.exe /SERVER=http://ocsinventory.unimedrj.root/ocsinventory /S /NOSPLASH /NOW
    }
}

foreach($srv in $servers){get-wmiobject win32_process -ComputerName $srv | where-object {$_.Name -like "OCS*"}  | select PSComputerName, ProcessName, Path}


$Services = @()
foreach($srv in $servers){Write-Host $srv -ForegroundColor Green;$Services+=get-wmiobject win32_service -ComputerName $srv | where-object {$_.Name -eq "OCS Inventory Service"}}
$Services | select PSComputerName, Displayname, Startname
$Services.Count


