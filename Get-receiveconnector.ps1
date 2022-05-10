$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session


$remoteip = Get-ReceiveConnector -Identity "CASPRD01\Aplicacoes"  |select remote* -ExpandProperty RemoteIPRanges
$FormatEnumerationLimit =-1

$remoteip | Export-Csv -Path C:\temp\remoteip.csv

$remoteip |Set-Content -Path C:\temp\remoteip.txt