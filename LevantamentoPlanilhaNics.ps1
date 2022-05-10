$computers = Get-ADComputer -Filter {OperatingSystem -Like "Windows Server*"} -Property *
$computers.count
$saida = @()

foreach($srv in $computers)
{

$computername = $srv.Name
try{
if(Test-Connection -Count 1 -ComputerName $computername -ErrorAction Stop)
{

[array]$nics = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $computername | select *

[string]$nicmodel = ""
[string]$nicmodel += $nics | %{$_.description.trim()}

[string]$mac = ""
[string]$mac += $nics| %{$_.MACAddress.trim()}

[string]$ips = ""
[string]$ips += $nics| %{$_.ipaddress.trim()}

[string]$subnets = ""
[string]$subnets += $nics| %{$_.ipsubnet.trim()}

[string]$gtw = ""
[string]$gtw += $nics| %{if($_.DefaultIPGateway){$_.DefaultIPGateway.trim()}}

[string]$dns = ""
[string]$dns += $nics| %{if($_.DNSServerSearchOrder){$_.DNSServerSearchOrder.trim()}}

$server = new-object PSObject
$server | add-member -type NoteProperty -Name "Nics" -Value $nics.Count
$server | add-member -type NoteProperty -Name "Model" -Value $nicmodel
$server | add-member -type NoteProperty -Name "macaddress" -Value $mac
$server | add-member -type NoteProperty -Name "cabos" -Value ""
$server | add-member -type NoteProperty -Name "IPs" -Value $ips
$server | add-member -type NoteProperty -Name "Subnets" -Value $subnets
$server | add-member -type NoteProperty -Name "gateway" -Value $gtw
$server | add-member -type NoteProperty -Name "DNS" -Value $dns
$server | add-member -type NoteProperty -Name "WINS" -Value ""

$saida += $server 
$srv.Name
#$server 

}
else{Write-Host $srv.Name OFFLINE -BackgroundColor Red}
}catch{$erromesg = $_;Write-Host $srv.Name -BackgroundColor Red}


}

$saida | export-csv -Delimiter ";" -Encoding Unicode -Path \\10.200.5.57\c$\nics.csv