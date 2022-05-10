$servers = Get-Content c:\temp\servers.txt
$saida =@()
foreach($srv in $servers)
{
    
    if(Test-Connection -ComputerName $srv -Count 1 -Quiet)
    {
        try{$servername = [System.Net.Dns]::GetHostByAddress($srv).Hostname;$servername = $srv + ";pingou;" + $servername}catch{$servername = $srv + ";pingou;não resolveu"}

    }else
    {
        try{$servername = [System.Net.Dns]::GetHostByAddress($srv).Hostname}catch{}
        if($servername)
        {
            $servername = $srv+";não pingou;" + $servername

        }else{
            $servername = $srv + ";não pingou;não resolveu"
        }
    }
    $servername
    $saida += $servername
    $conn = $servername = $null
}
$saida | Set-Content \\10.200.5.43\c$\saidamurilo.txt -Encoding Unicode


