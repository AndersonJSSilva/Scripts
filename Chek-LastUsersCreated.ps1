$a = (Get-Date).AddDays(-3)
$b = Get-date
[int32]$hour = 0
[int32]$minute = 0
[int32]$second = 0
$datainicio = Get-Date -Year $a.Year -Month $a.Month -Day $a.day -Minute $minute -Hour $hour -Second $second
$datafim = Get-Date -Year $b.Year -Month $b.Month -Day $b.day -Minute $minute -Hour $hour -Second $second
$users = Get-ADUser -Filter {whencreated -gt $datainicio} -Properties * | select samaccountname, name, givenname, surname, displayname, department, office, description, company, emailaddress, whenCreated
[string]$data = $a.Year.ToString() + $a.Month.ToString() + $a.Day.ToString()
$users