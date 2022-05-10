Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -like "rita ner*" } | select displayname,databasename, *date*, *item*, DisconnectReason

$mbx = (Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisplayName -like "rita ner*" })[1] | select displayname,databasename, *date*, *item*, DisconnectReason

Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisconnectReason -eq "Disabled" } | select displayname,databasename, DisconnectDate, ItemCount, DisconnectReason
Get-MailboxDatabase | Get-MailboxStatistics | Where { $_.DisconnectReason -eq "SoftDeleted" } | select displayname,databasename, DisconnectDate, ItemCount, DisconnectReason

Connect-Mailbox -Identity "Rita Neri - Administração de Pessoal" -Database Usuarios2013_Q-U -User "M38687"
$mbx | Connect-Mailbox -Database Usuarios2013_Q-U -User "M38687"


get-aduser -filter {displayname -like "rita neri*"} -Properties * | FT officephone, samaccountname, displayname

Get-MailboxStatistics -Identity M38687 | select *