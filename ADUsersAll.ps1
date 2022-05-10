$users = Get-ADUser -Filter 'Enabled -eq $true' -Properties * 
$users.Count
$pattern = @("^m[0-9]","^ja[0-9]","^e[0-9]","^est[0-9]","^tr[0-9]")#,"^adm[0-9]","^c[0-9]",

$usersFiltered = @()
foreach($user in $users)
{
    if($user.SamAccountName | Select-String -Pattern $pattern)
    {
        $usersFiltered += $user
    }
    else
    {
        #Write-Host fora do padrão de login $user.SamAccountName -ForegroundColor Red
    }
} 



$usersFiltered.count
$usersFiltered | select SamAccountName, UserPrincipalName, GivenName, Surname, Name, cn, DisplayName, office, department, description, title, company, mail, OfficePhone, MobilePhone, telephoneNumber `
| export-csv c:\temp\revisaoAD.csv -Encoding Unicode

$users = Import-Csv c:\temp\saneamentoAD.csv 


$usersFiltered | %{$_.samaccountname + ";"}


