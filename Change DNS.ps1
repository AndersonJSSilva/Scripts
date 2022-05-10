#$computer = Get-Content C:\temp\dns\dns.txt

#$computer = "fimprd02"

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |where{$_.IPEnabled -eq “TRUE”}

  Foreach($NIC in $NICs) {
 $DNSServers = “10.100.1.60",”10.100.1.61"
 $NIC.SetDNSServerSearchOrder($DNSServers)
 $NIC.SetDynamicDNSRegistration(“TRUE”)
}