$userdisabled = Get-ADUser -Filter 'Enabled -eq $false' -Properties whenchanged

foreach ($user in $userdisabled)
{ 

if($user.whenchanged -gt (get-date).adddays(-15))

{
$user.Name

}

}

$userdisabled.count
