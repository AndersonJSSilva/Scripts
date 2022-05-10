$cvs = Import-Csv C:\temp\epoMachineUser.csv 
$users = Get-Content C:\temp\mxmger.txt
$saida = @()

$users | %{$usr = $_+"*" ;Get-ADUser -filter {displayname -like $usr } -Properties * | select samaccountname}

$users = Import-Csv C:\temp\gerentes.csv

foreach($user in $users)
{
    $saida += $cvs | ?{$_.username -eq $user.matricula} | select  username, systemname, ipaddress, lastcommunication 
}
$saida

clear
foreach ($s in $saida)
{

    Test-Connection -quiet -computer $s.SystemName -Count 1 | ForEach { 
    $s.SystemName +" / "+$s.UserName  
    $path1 = "\\"+$s.IPAddress+"\c$\mxmv21\fix\mxm.config"
    $path2 = "\\"+$s.IPAddress+"\c$\mxmv21\mxm.config"
    Copy-Item \\unimedrj.root\NETLOGON\pacotes\MXMv21\MXM.config -Destination $path1
    Copy-Item \\unimedrj.root\NETLOGON\pacotes\MXMv21\MXM.config -Destination $path2


}

}

#Invoke-command –computer $_.name -ScriptBlock {cmd.exe /c "gpupdate /force"}