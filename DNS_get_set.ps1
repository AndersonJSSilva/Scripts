$computers = Get-Content C:\temp\lojacopa.txt

$DNSServers = “10.200.100.61",”10.200.100.60"
$range = "10.105"

foreach($computer in $computers)
{
    write-host $computer -ForegroundColor Yellow
    $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer | where{($_.IPEnabled -eq “TRUE”) -and ((($_.ipaddress[0]).Substring(0,6)) -eq $range)}
    if(($NICs.DNSServerSearchOrder[0] -ne $DNSServers[0]) -and ($NICs.DNSServerSearchOrder[1] -ne $DNSServers[1]))
    {
        Foreach($NIC in $NICs)
        {
            $NIC.SetDNSServerSearchOrder($DNSServers)
            $NIC.SetDynamicDNSRegistration(“TRUE”)
        }
    }
    else { Write-Host dns já setado -ForegroundColor red  }
}


$computers
$pcs = @()
foreach($computer in $computers)
{
    $computer 
    $pcs += get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer | where{($_.IPEnabled -eq “TRUE”) -and ((($_.ipaddress[0]).Substring(0,6)) -eq $range)} | select pscomputername, ipaddress,DHCPServer,DNSServerSearchOrder
}
$pcs 


$pcs = @()
foreach($computer in $computers)
{
    $computer 
    if((test-connection -ComputerName $computer -Count 1))
    {
        $pcs += get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer | where{($_.IPEnabled -eq “TRUE”)} | select pscomputername, ipaddress,DHCPServer,DNSServerSearchOrder
    }else{Write-Host maquina offline}
}
$pcs