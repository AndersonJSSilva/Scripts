##Limpeza de Variáveis
$usersfound = @()
$usersFiltered = @()
$users = @()
$users.length

##Importação de Usuários
$users = Get-ADUser -Filter 'Name -like "*"' -Properties *

##Filtro para usuários com 1, 2 ou 3 letras no início e números no final(M..., TR..., EST...)
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

##Filtro para excluir os usuários da OU de Demitidos
Foreach($user in $usersFiltered)
{
        if($user.CanonicalName -like "*Demitidos*")
        {   
        }else
        {
            $usersfound += $user
        }
}

##Exportando listagem de usuário do AD
$usersfound | select samaccountname, name, Displayname, EmailAddress, telephoneNumber, title, Department, office, company, manager | export-csv c:\usuariosad.csv -Encoding Unicode