##Limpeza de Variaveis
$areas = @()
$area = @()

##Criacao de OU
$areas = Get-Content -Path C:\temp\teste.txt
Foreach ($area in $areas)
{
New-ADOrganizationalUnit -Server dcbar01 -Path "OU=Teste2,DC=unimedrj,DC=root" -Name $area
}