##Limpeza de Variáveis
$Usuarios = @()
$Usuario = @()
$AtivarOk = @()
$AtivarExpirar = @()
$SaidaOk = @()
$SaidaExpirar = @()
$AtivarUsuario = @()
$Date = @()
$ConsultarUsuario = @()
$NExpirarUsuario = @()

##Importação de Módulo Active Directory
Import-Module ActiveDirectory

##Importação de Usuários
$usuarios = Get-Content -Path c:\temp\disable.txt

##Redefinição de Senha de Usuários Importados
ForEach ($usuario in $usuarios) {

#Limpeza/Criação de Variável Local
$Date = Get-Date -Format ddMMyyHHmmss

##Verificação de Existência de Usuário
$ConsultarUsuario = Get-ADUser -Identity $usuario -Properties *
If ($ConsultarUsuario.Enabled -eq $False){
$AtivarOk += "$usuario"
$AtivarUsuario = $ConsultarUsuario | Set-ADUser -Enabled:$true}
else{
}

##Verificação de Usuário Expirado
If (($ConsultarUsuario.PasswordExpired -eq $True) -or ($ConsultarUsuario.PasswordNeverExpires -eq $False)){
$AtivarExpirar += "$usuario"
$NExpirarUsuario = $ConsultarUsuario | Set-ADUser -PasswordNeverExpires:$True}
else{
}
}

##Resultado Final da Execução (2 TXTs: AtivarOk | AtivarOk2)
If ($AtivarOk -ne $null){
$SaidaOk = $AtivarOk | Out-File "c:\temp\AtivarOk_$Date.txt"}
else{}

If ($AtivarExpirar -ne $null){
$SaidaExpirar = $AtivarExpirar | Out-File "c:\temp\AtivarExpirar_$Date.txt"}
else{}



