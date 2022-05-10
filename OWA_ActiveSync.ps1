(Get-CASMailbox -ResultSize unlimited | where { $_.OWAEnabled } | ft DisplayName,  samaccountname).count

(Get-CASMailbox -ResultSize unlimited | where { $_.ActiveSyncEnabled } | ft DisplayName, samaccountname).count

Get-CASMailbox -ResultSize unlimited | where { $_.DisplayName -like "Roose*" } | select  samaccountname, ActiveSyncEnabled, OWAEnabled 

Set-CASMailbox -Identity m70327 -OWAEnabled $true -ActiveSyncEnabled $true

Get-CASMailbox | select * -First 1

get-mailbox -Identity m41718 | select *