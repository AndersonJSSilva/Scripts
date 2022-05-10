$users = Get-ADUser -Server unirjad01 -Filter {samaccountname -like "*"} -Properties * | select samaccountname, name, created, Enabled, whenChanged

$users | Export-Csv c:\temp\saidaAD_ureh.csv -Encoding Unicode

Get-ADUser -Identity M59692 -Properties * | select samaccountname, name, created, deleted, enabled