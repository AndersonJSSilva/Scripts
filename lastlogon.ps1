$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session


$users = Get-MailboxStatistics -Server boxprd01| Sort LastLogonTime -Descending |select displayname, lastlogontime

$users | Export-Csv -Path C:\temp\lastlogonboxprd02.csv

Get-MailboxStatistics -Identity 9b7367e5-6bf8-4d16-ac99-a1e19ff3413d  | select *