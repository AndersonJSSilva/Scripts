$entradas = Get-DnsServerResourceRecord -ZoneName "unimedrj.root" -RRType "A" | select HostName,RecordData 
$valores = @()
$data = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
$tmp = ""
foreach($entrada in $entradas)
{
    $tmp = $entrada.HostName
    if(($tmp -like "uniben-*") -or (($tmp -notlike "unibar*") -and ($tmp -notlike "unipdo*") -and ($tmp -notlike "unicoo*") -and ($tmp -notlike "uniloj*") -and ($tmp -notlike "unimac*") -and ($tmp -notlike "uniemp*") -and ($tmp -notlike "uniben*") -and ($tmp -notlike "uniblf*")))
    {
        $valores += $entrada.HostName+$entrada.recorddata.IPv4Address.IPAddressToString
    }
}
$itensremovidos = $null
$snap = Get-Content C:\powershell\dnssnapshot$data.txt
foreach($dnsrecord in $snap)
{
    if($valores -notcontains $dnsrecord)
    {
       $itensremovidos += $dnsrecord+"`n"
        
    }
}

$itensremovidos
$corpo = $null
$corpo = "Entradas DNS Removidas"+"`n`n"
$corpo += $itensremovidos
if($corpo)
{
    Write-Host "Entradas DNS Removidas"
    Send-MailMessage -to "Servidores Windows <_infra-ti_Servidores_windows@unimedrio.com.br>" -from "DNS Monitor <dnsmonitor@unimedrio.com.br>" -subject "Entradas DNS removidas" -SmtpServer "mail.unimedrio.com.br" -Body $corpo
}  