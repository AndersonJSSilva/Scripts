Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

#############  backup para arquivo  #################################
$rconn = Get-ReceiveConnector | ?{$_.Identity -like "*02\aplicacoes"}
$ips = @()
foreach($conn in $rconn)
{
    $rconn
    Foreach($ip in $conn.RemoteIPRanges)
    {
       $ips += $ip.ToString()

    }
    
}
Set-Content c:\temp\ipsrc02.txt $ips
#####################################################################



######## add single ip  #######
$ip = "10.0.0.99"
$RecvConn = Get-ReceiveConnector "hubcasprd01\aplicacoes"
$RecvConn.RemoteIPRanges += $ip
Set-ReceiveConnector "hubcasprd01\aplicacoes" -RemoteIPRanges $RecvConn.RemoteIPRanges
$RecvConn = Get-ReceiveConnector "hubcasprd02\aplicacoes"
$RecvConn.RemoteIPRanges += $ip
Set-ReceiveConnector "hubcasprd02\aplicacoes" -RemoteIPRanges $RecvConn.RemoteIPRanges
###############################

#### add ips from files  ######

$RecvConn = Get-ReceiveConnector "hubcasprd01\aplicacoes"
Get-Content c:\temp\ipsrc01.txt | foreach {$RecvConn.RemoteIPRanges += "$_"}
Set-ReceiveConnector "hubcasprd01\aplicacoes" -RemoteIPRanges $RecvConn.RemoteIPRanges
$RecvConn = Get-ReceiveConnector "hubcasprd02\aplicacoes"
Get-Content c:\temp\ipsrc02.txt | foreach {$RecvConn.RemoteIPRanges += "$_"}
Set-ReceiveConnector "hubcasprd02\aplicacoes" -RemoteIPRanges $RecvConn.RemoteIPRanges

###############################