Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin

$saida = Get-Queue -Server boxprd01.unimedrj.root | ?{$_.MessageCount -gt 0}
$saida += Get-Queue -Server boxprd02.unimedrj.root | ?{$_.MessageCount -gt 0}
$saida
