$users = Import-Csv C:\temp\usuarioremovidos.txt

foreach($user in $users)
{

    $mail = $user.name
    Add-ADGroupMember -Identity workplaceusers -Members (Get-ADUser -Filter {mail -eq $mail})

}

$bkp = get-ADGroupMember -Identity workplaceusers
$bkp.Count
(get-ADGroupMember -Identity workplaceusers).count