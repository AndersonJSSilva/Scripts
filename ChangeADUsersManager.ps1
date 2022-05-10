$managernovo = get-aduser -Filter {name -eq "NEUMARLING GODOY"} | select DistinguishedName
$managerantigo = get-aduser -Filter {name -eq "Rosemere Gomes"} | select DistinguishedName
[string]$tmp = $managerantigo.DistinguishedName
$users = Get-ADUser -Filter {manager -eq $tmp} -Properties manager, displayname
$users.count
$users | select displayname
[string]$tmp = $managernovo.DistinguishedName
$users | Set-ADUser -Manager $tmp