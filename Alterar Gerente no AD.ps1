##Limpeza de Variáveis
$usuarios = @()
$teste = @()
$ge = @()
$u = @()
$us = @()

##Usuários e Gerentes associados
$usuarios = Get-Content -Path C:\TEMP\usuarios.txt

##Alteração do Gerente
foreach($u in $usuarios)
{
$us = @($u -split ";")[0]
$ge = @($u -split ";")[1]
$teste = set-aduser -Identity $us -Manager $ge
}

