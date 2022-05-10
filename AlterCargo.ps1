##Limpeza de Variáveis
$Emails = @()
$Email = @()
$UserEmail = @()
$Usuario = @()
$Cargo = @()
$Alteracao = @()

##Usuários e Cargos associados
$Emails = Get-Content -Path c:/usuarios.txt

##Alteração de Cargo no AD
foreach ($Email in $Emails)
{
$Cargo = @($Email -split ";")[0]
$UserEmail = @($Email -split ";")[1]
$Usuario = Get-ADUser -Filter {mail -like $UserEmail}
$Alteracao = Set-ADUser -Identity $Usuario.samaccountname -Title $Cargo
}