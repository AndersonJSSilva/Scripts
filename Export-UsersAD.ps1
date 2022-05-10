$users = Get-ADUser -Filter {samaccountname -like "*"} -Properties * | select samaccountname, name, description, title, department, manager
$userad = @()
foreach ($user in $users)
{
   
    if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[0-9]")
    {
        $userad += $user
    } else
    {
        if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[0-9]")
        { 
            $userad += $user
        } else
        {
            if($user.SamAccountName.ToString().length -ge 4){
            
            if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[a-z]" -and $user.SamAccountName.Substring(3,1) -match "[0-9]")
            {            
                     $userad += $user
            } else {
                #Write-Host "Fora do padrao: "$user.SamAccountName
            }
            }
        }
    }
}
$userad | Export-Csv c:\temp\saidaAD.csv -Encoding Unicode

