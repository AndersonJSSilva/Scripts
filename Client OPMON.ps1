#Limpando Variáveis
$Servidores = @()
$Conexao = @()
$Arquivo = @()
$Text = @()
$timestamp = Get-Date -Format yyyyMMdd-hhmmss
$patern = @()
$restart = @()

#Importando Listagem de Servidores
$Servidores = Get-Content -Path 'C:\temp\Servidores.txt'
ForEach($Servidor in $Servidores)
{
$restart = $false
$Servidor

#Acessando Arquivo
$Arquivo = "\\"+$servidor+"\C$\Program Files\NSClient++\NSC.ini"

#Faz Backup do arquivo NSC.ini atual
Copy-Item -Path $Arquivo -Destination  ("\\"+$servidor+"\C$\Program Files\NSClient++\NSC-"+$timestamp+".ini")

#Lendo o arquivo NSC.INI
$Text = Get-Content -Path $Arquivo

#Alterando os IP's do arquivo NSC.INI 
$patern = @("allowed_hosts=127.0.0.1/32,10.100.2.23,opmonprd01,opmonprd02,opmondev","allowed_hosts=10.100.2.23,opmonprd01,opmonprd02,opmondev")
if ($Text | Select-String -Pattern $patern[0] )
{
    write-host Já Existe
}else
{
    $Text = $Text | Foreach-Object {$_ -replace "allowed_hosts=127.0.0.1/32,10.100.2.23","allowed_hosts=127.0.0.1/32,10.100.2.23,opmonprd01,opmonprd02,opmondev"}
    $restart = $true
}

if (($Text | Select-String -Pattern $patern[1]).count -eq 2 )
{
    write-host Já Existe
}else
{
    $Text = $Text | Foreach-Object {$_ -replace "allowed_hosts=10.100.2.23","allowed_hosts=10.100.2.23,opmonprd01,opmonprd02,opmondev"}
    $restart = $true
}

#Salvando o arquivo NSC.INI
$Text | Set-Content ($Arquivo)

#Restart do Serviço NSClient
if($restart)
{
    $svc = Get-Service -ComputerName $Servidor NSClientpp
    $svc.Stop()
    Start-Sleep 3
    while((Get-Service -ComputerName $Servidor NSClientpp).status -ne "stopped")
    {
        (Get-Service -ComputerName $Servidor NSClientpp).status
        Start-Sleep 3
    }
    $svc.Start()
    (Get-Service -ComputerName $Servidor NSClientpp).status
}

}

