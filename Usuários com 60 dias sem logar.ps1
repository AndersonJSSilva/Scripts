$users = Get-ADUser -Filter {name -like "*"} -Properties *
$users.Length
$usersfound = @()
foreach($user in $users)
{    

    if($user.LastLogonDate -lt (get-date).AddDays(-60))
    {
        #$user.Name + "`t"+$user.SamAccountName  + "`t"+ $user.LastLogonDate
        $usersfound += $user
    }

}
$usersfound.Length
$usersfound | select name, samaccountname, enabled, lastlogondate | export-csv \\10.200.5.22\c$\60diasnovo.csv -Encoding Unicode 
