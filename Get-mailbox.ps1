Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
Import-Module ActiveDirectory
#Import-Module ServerManager
#Add-WindowsFeature RSAT-AD-PowerShell

$mbx = Get-Mailbox -ResultSize unlimited | select  samaccountname,displayname, PrimarySmtpAddress, servername, @{Label="cargo";Expression={((get-aduser $_.samaccountname -Properties * | select title) -replace "@{title=") -replace "}"}}

$mbx | export-csv -Path \\10.200.5.94\c$\contasexc.csv -Encoding Unicode

$mbx = Get-Mailbox -ResultSize unlimited | ?{($_.CustomAttribute1 -like "siebel*")}| select  samaccountname,displayname, PrimarySmtpAddress, servername, CustomAttribute1
#$mbx | %{Remove-Mailbox -Identity $_.samaccountname -Confirm}
