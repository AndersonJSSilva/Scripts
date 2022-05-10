Get-ADUser -Filter {(title -like "superintendente*") -and (enabled -eq $true)} -Properties * | select name,mail, manager

Get-ADUser -Filter {(title -like "coord*") -and (enabled -eq $true)} -Properties * | select name,mail, manager, distinguishedname

Get-ADUser -Filter {(title -like "coord*") -and (enabled -eq $true)} -Properties * | %{ $_.samaccountname + ";" }

