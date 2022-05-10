
$users = Get-ADUser -Filter 'Name -like "*"' -Properties *
$users.length
$usersfound = @()
$usersFiltered = @()
foreach($user in $users)
{
    if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[0-9]")
    {
        $usersFiltered += $user
    }
    else
    {
        if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[0-9]")
        {
            $usersFiltered += $user
        }else
        {
            if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[a-z]" -and $user.SamAccountName.Substring(3,1) -match "[0-9]")
            {
                $usersFiltered += $user
            }
        }
    }
} 
$usersFiltered.Length


Foreach($user in $usersFiltered)
{
    if($user.lastlogondate -lt (Get-Date).adddays(-35))
    {
        if(($user.CanonicalName -like "*Demitidos*") -or ($user.CanonicalName -like "*Afastados*") -or ($user.CanonicalName -eq "Férias"))
        {   
        }else
        {
            $usersfound += $user
        }
    }
} 
$usersfound | select name, samaccountname, enabled, lastlogondate | export-csv \\10.200.5.22\c$\35diasnovo.csv -Encoding Unicode
$usersfound.length
