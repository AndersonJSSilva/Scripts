$users = @()
$users =  Get-ADUser -Filter {samaccountname -like "m*"}   -Properties *
$users += Get-ADUser -Filter {samaccountname -like "c*"}   -Properties *
$users += Get-ADUser -Filter {samaccountname -like "tr*"}  -Properties *
$users += Get-ADUser -Filter {samaccountname -like "ja*"}  -Properties *
$users += Get-ADUser -Filter {samaccountname -like "e*"}   -Properties *
$users += Get-ADUser -Filter {samaccountname -like "h*"}   -Properties *
$users += Get-ADUser -Filter {samaccountname -like "est*"} -Properties *
$users.Length
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
           if(($user.SamAccountName).Length -gt 3)
           {
                if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[a-z]" -and $user.SamAccountName.Substring(3,1) -match "[0-9]")
                {
                    $usersFiltered += $user
                }
            }
        }
    }
}
$usersFiltered.Lenght
$usersfound = @()
foreach($user in $usersFiltered)
{    

    if($user.LastLogonDate -lt (get-date).AddDays(-35))
    {
        if(!($user.CanonicalName -like "*desativados*") -or !($user.CanonicalName -like "*afastados*"))
        {
            $usersfound += $user
        }
    }

}
$usersfound.Length
$usersfound | select name, samaccountname,enabled, lastlogondate | export-csv \\10.200.5.22\c$\35dias.csv -Encoding Unicode

#####################################################################
Get-ADgroup -Filter {name -like "_admans*"} 
$user = (Get-ADUser -Filter {name -like "flavio ferro*"}).samaccountname
$grp = (Get-ADgroup -Filter {name -like "_admans_sib*"}).name
Add-ADGroupMember -identity $grp -members $user
Get-ADGroupMember $grp

foreach($user in $users){
if(($user.SamAccountName).Length -le 3)
{
    $user.SamAccountName
}
}