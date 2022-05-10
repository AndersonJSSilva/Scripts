#$hosts = Get-WmiObject -ComputerName dcben01 -Namespace 'root\MicrosoftDNS' -Class MicrosoftDNS_AType
#$hosts[1]
$data = Get-Date
$data = $data.AddDays(-7)
$desktops = Get-AdComputer -Filter {(name -like "uni*") -and (lastlogondate -ge $data)} -Properties * | FT cn, ipv4address, operatingsystem, CanonicalName -AutoSize 
$result = @()
foreach ($desktop in $desktops)
{

    $ip = $null
    $ip = ($desktop.ipv4address).tostring()
    if($ip -like "10.101.*")
    {
       $result+= $desktop | FT cn, ipv4address, operatingsystem, lastlogondate, CanonicalName -AutoSize 

    }
}
$result.Length