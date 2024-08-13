#Variáveis Globais
$Hostname = Get-content -Path C:\temp\LogIntune.txt
$Usuario = "Domínio\renomeardesktop"

#Download Arquivo de Senha (Primeira Opção)
mkdir C:\temp
(new-object System.Net.WebClient).DownloadFile(‘https://xxxx.blob.core.windows.net/renomeardesktop/.txt’,’C:\temp\.txt’)
$Senha = "c:\temp\.txt"
$SenhaCriptografada = Get-Content $Senha | ConvertTo-SecureString
$Credencial = new-object -typename System.Management.Automation.PSCredential -argumentlist $Usuario, $SenhaCriptografada

#KeyVault com Senha (Segunda Opção)
#Cloud na Quebrada: https://www.youtube.com/watch?v=6Xt0AaD9420&t=1237s

#Alterar Hostname
Rename-Computer -NewName $Hostname -DomainCredential $Credencial

#Remover Arquivos
Remove-Item -Path C:\temp\.txt