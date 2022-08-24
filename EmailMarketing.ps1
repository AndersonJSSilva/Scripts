##Limpeza de Variáveis
$nomes = @()
$sobrenomes = @()
$dominios = @()
$nome = @()
$sobrenome = @()
$dominio = @()
$nomesobrenome = @()
$Email = @()

##Importação de Nomes, Sobrenomes e Domínios
$nomes = Get-Content -Path c:\temp\nome.txt
$sobrenomes = Get-Content -Path c:\temp\sobrenome.txt
$dominios = @("@outlook.com";"@hotmail.com";"@gmail.com")

##Geração de Emails para Mail Marketing
ForEach ($nome in $nomes) {
ForEach ($sobrenome in $sobrenomes) {
ForEach ($dominio in $dominios) {
$Email += "$nome.$sobrenome$dominio"
}}}
$Email
$Saida = $Email | Out-File "c:\temp\emails.txt" 