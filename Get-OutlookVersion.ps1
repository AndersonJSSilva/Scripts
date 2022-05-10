Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

$data = Get-Date
$data = $data.AddDays(-5)

Get-MailboxServer | Get-LogonStatistics | ?{($_.clientversion -like "11*") -and ($_.lastaccesstime -gt $data)}|
Select UserName,Windows2000Account,ClientVersion,Clientipaddress,clientname,ServerName,DatabaseName | sort -Unique Windows2000Account,ClientVersion,Clientipaddress,clientname
Export-Csv c:\temp\outlookclients03032015-2.csv -Encoding Unicode


Get-MailboxServer | Get-LogonStatistics |
?{($_.username -like "adm17*")} |
ft UserName,Windows2000Account,ClientVersion,Clientipaddress,clientname,ServerName,DatabaseName 

Get-MailboxServer | Get-LogonStatistics | ?{($_.clientname -like "UNIBAR00032050*")}|
ft UserName,Windows2000Account,ClientVersion,Clientipaddress,clientname,lastaccesstime

?{($_.clientversion -like "11*") -and ($_.lastaccesstime -gt $data)}
Export-Csv c:\temp\outlookclientslastaccess.csv -Encoding Unicode


