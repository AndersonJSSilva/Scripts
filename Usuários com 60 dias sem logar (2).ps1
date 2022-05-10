$users = Get-ADUser -Filter {name -like "*"} -Properties *
$users2 = @()

Foreach ($user in $users)

{
if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[0-9]")
{
    $users2 += $user

}

if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[0-9]")
{
    $users2 += $user

}
if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[a-z]" -and $user.SamAccountName.Substring(3,1) -match "[0-9]")
{    
    $users2 += $user
}
}




$users2.Length
$usersfound = @()
foreach($user in $users2)

{    

if($user.lastlogondate -lt (Get-Date).adddays(-35))
    {
        if(($user.CanonicalName -like "*Desabilitados*") -or ($user.CanonicalName -like "*Afastados*"))
        {   
        }else
        {
            $usersfound += $user
        }
    }
} 
$usersfound.Length
$usersfound | select name, samaccountname, enabled, lastlogondate | export-csv C:\temp\60dias.csv

