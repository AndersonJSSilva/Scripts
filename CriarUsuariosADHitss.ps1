##Limpeza de Variáveis
$Usuarios = @()
$Usuario = @()
$NovoUsuario = @()
$UsuariosErro = @()
$UsuariosOk = @()
$SaidaErro = @()
$SaidaOk = @()
$PrimeiroNome = @() 
$UltimoNome = @()
$OU = @()
$Email = @()
$Cargo = @()
$Date = @()

##Importação de Módulo Active Directory
Import-Module ActiveDirectory

##Funções de Criação de Senhas Randômicas
function Get-RandomCharacters($length, $characters) {
   $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
   $private:ofs=""
   return [String]$characters[$random]
}
function Scramble-String([string]$inputString){     
   $characterArray = $inputString.ToCharArray()   
   $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
   $outputString = -join $scrambledStringArray
   return $outputString 
}

##Importação de Usuários
$usuarios = Get-Content -Path c:\temp\usuarios.txt

##Criação de Usuários Importados e Definição de Senha
ForEach ($usuario in $usuarios) {

#Limpeza/Criação de Variável Local
$NovoUsuario = @()
$Date = Get-Date -Format ddMMyyHHmmss

$PrimeiroNome = @($usuario -split ";")[0]
$UltimoNome = @($usuario -split ";")[1]
$Email = @($usuario -split ";")[2]
$OU = @($usuario -split ";")[3]

##Criação de Senha Forte
$password = Get-RandomCharacters -length 5 -characters 'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 1 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 1 -characters '1234567890'
$password += Get-RandomCharacters -length 1 -characters '!"§$%&/()=?}][{@#*+'
$password = Scramble-String $password

$NovoUsuario = New-ADUser -Name "$PrimeiroNome $UltimoNome" -GivenName $PrimeiroNome -Surname $UltimoNome -UserPrincipalName "$PrimeiroNome.$UltimoNome@hildebra.intra" -Title "$Cargo" -SamAccountName "$PrimeiroNome.$UltimoNome" -Path $OU -EmailAddress $Email -Enabled $True -AccountPassword (ConvertTo-SecureString -AsPlainText "$password" -Force) -PassThru

##Verificação de Existência de Usuário
If ($NovoUsuario -ne $NULL){
$UsuariosOk += "$PrimeiroNome $UltimoNome;$password"}
else{$UsuariosErro += "$PrimeiroNome $UltimoNome"
}}

##Resultado Final da Execução (2 TXTs: UsuariosErro | UsuariosOk)
$SaidaErro = $UsuariosErro | Out-File "c:\temp\UsuariosErro_$Date.txt"
$SaidaOk = $UsuariosOk | Out-File "c:\temp\UsuariosOk_$Date.txt"
