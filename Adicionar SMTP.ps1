##Limpeza de Variáveis
$UsuarioExchange = @()
$Usuarios = @()
$Emails = @()
$Usuario = @()
$teste = @()

##Comandos Exchange
$Conexao = Add-PSSnapin *exchange*

##Importação de Usuários
$teste = Get-Content -path C:\TEMP\testando.txt
Foreach ($usuario in $teste)
{
$Usuarios = @($Usuario -split ";")[0]
$Emails = @($Usuario -split ";")[1]
$UsuarioExchange = Get-Mailbox -Identity $Usuarios
$UsuarioExchange.EmailAddresses += ("smtp:$Emails")
$UsuarioExchange | Set-Mailbox -EmailAddresses $UsuarioExchange.EmailAddresses
$UsuarioExchange | Set-Mailbox -PrimarySmtpAddress $Emails
}