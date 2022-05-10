$servers += Get-ADComputer -Filter {OperatingSystem -like "*2003*"} -Properties * -SearchBase  "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"

$servers | ft name

#$saida =$null

$servers = @("crmfinsprd01","crmfinsprd02","crmwsprd03","crmwsprd04")

foreach($srv in $servers)
{
Write-Host $srv.name -ForegroundColor Green
    if ((Get-WmiObject win32_operatingsystem -ComputerName $srv.name| select osarchitecture).osarchitecture -eq "64-bit")
    {
        $saida += Invoke-Command -ComputerName $srv.name -ScriptBlock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Publisher, InstallDate }
        $saida += Invoke-Command -ComputerName $srv.name -ScriptBlock {Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Publisher, InstallDate }
    }
    else
    {
        $saida += Invoke-Command -ComputerName $srv.name -ScriptBlock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Publisher, InstallDate }
    }
}


$saida | ?{$_.displayname -like "*outsystem*"} | ft -AutoSize

$saida = Import-Csv C:\temp\ServersInventory.csv
$saida | Export-Csv c:\temp\ServersInventory.csv -Encoding Unicode


