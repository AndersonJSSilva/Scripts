$userdisabled = Get-ADUser -Filter 'Enabled -eq $false' -Properties whenchanged
$usersd = @()

foreach ($user in $userdisabled)
{ 

if($user.whenchanged -gt (get-date).adddays(-1))

{
$usersd += $user.Name

}

}

$userdisabled.count

$usersd.count

