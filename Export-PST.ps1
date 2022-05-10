$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session

Export-Mailbox –Identity "m50610" -PSTFolderPath c:\temp\pst\pstm50610.pst -StartDate "01/01/2001" -EndDate "30/11/2015"
New-MailboxExportRequest "m50610" -FilePath c:\temp\pst -StartDate "01/01/2001" -EndDate "30/11/2015"

New-MailboxExportRequest -ContentFilter {(Received -lt '01/01/2001') -and (Received -gt '11/30/2015')} -Mailbox "m50610" -Name Rogerio -FilePath \\10.200.5.94\pst\rogerioteste.pst

New-MailboxExportRequest -ContentFilter {(Received -lt '11/30/2015') -and (Received -gt '01/01/2001')} -Mailbox "m50610" -Name Rogerio -FilePath \\10.200.5.94\pst\rogerioteste.pst

New-MailboxExportRequest -ContentFilter {(Received -lt '11/30/2015')} -Mailbox "m50610" -Name Rogerio -FilePath \\10.200.5.94\pst\rogerioteste.pst

Get-MailboxExportRequest
Remove-MailboxExportRequest -Identity "Rogerio"

Get-MailboxExportRequest -Status completed | Remove-MailboxExportRequest

Deletar periodo
Search-Mailbox -id m50610 -SearchQuery "Received:2016-01-20..2016-01-20" –DeleteContent

Criar pst
New-MailboxExportRequest -Mailbox "m50610" -Name Rogerio -FilePath \\10.200.5.94\pst\rogeriotestefull.pst 


New-MailboxExportRequest -ContentFilter {(Received -lt '01/01/2001') -and (Received -gt '11/30/2015')} -Mailbox "m50610" -Name Rogerio -FilePath \\10.200.5.94\pst\rogerioteste.pst
