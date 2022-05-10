##Limpeza de variáveis
$conteudo = @()
$server = @()
$dns = @()
$serverdns = @()

##Servidores Windows
$conteudo = Get-ADComputer -Filter {name -like "*"} -Properties * | ?{$_.operatingsystem -like "*server*"}
$server += $conteudo
$server.length

##Configuração DNS
foreach($comp in $server)
{
$dns = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $comp.Name | ?{$_.DNSServerSearchOrder -like "10.100.*"}
$serverdns += $dns.IPAddress[0] 
}
$serverdns.length