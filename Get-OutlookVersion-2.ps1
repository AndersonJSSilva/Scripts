Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$data =(Get-Date).adddays(-1)
$saida = Get-MailboxServer | Get-LogonStatistics | ?{($_.LastAccessTime -ge $data)}| Select UserName,clientname,ClientIPAddress,Windows2000Account,ClientVersion,LastAccessTime,ServerName,@{Label="Email";expression={
$name = ($_.username -split "-")[0] 
$name += "*"
(get-aduser -filter {displayname -like $name} -Properties *).mail
}} 
$saida | Export-Csv '\\10.200.5.50\c$\temp\saidaoutlook.csv' -Encoding Unicode
c:\temp\outlookversions30032015.csv

#$saida | Out-GridView
