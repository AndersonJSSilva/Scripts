$ips = Get-Content C:\temp\dnsnamedani.txt
$ips | %{try{Resolve-DnsName $_ -Server dcben01.unimedrj.root}catch{$_ +" nao existe"} }


$servers = get-content C:\temp\dnsname.txt
foreach($server in $servers)
{
    $tmpname = ($server.Split(";"))[1]
    $tmpip = ($server.Split(";"))[0]
   
    Add-DnsServerResourceRecordA -Name $tmpname -ZoneName "unimedrj.root" -AllowUpdateAny -IPv4Address $tmpip -CreatePtr:$true -ComputerName dcben01.unimedrj.root

}