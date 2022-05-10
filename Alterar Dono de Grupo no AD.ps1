##Limpeza de Variáveis
$grupos = @()
$manager = @()
$teste = @()

##Busca de Grupos
$grupos = get-ADGroup -filter 'ManagedBy -eq "CN=Alfonso Maselli,OU=_Usuarios Demitidos,DC=unimedrj,DC=root"'
foreach($manager in $grupos)
{   
set-ADGroup -Identity $manager.name -ManagedBy "CN=Priscila Babo,OU=Assessoria Jurídica,OU=_Barra,DC=unimedrj,DC=root"
}


Get-ADUser -Filter {name -like "priscila b*"} -Properties * | select dist*
