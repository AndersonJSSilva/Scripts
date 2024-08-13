#Download Arquivo de Seriais
mkdir C:\temp
(new-object System.Net.WebClient).DownloadFile(‘https://xxxx.blob.core.windows.net/renomeardesktop/Seriais.txt’,’C:\temp\Seriais.txt’)

#Criação do Blob
#Microsoft 365 na Veia: https://www.youtube.com/watch?v=rT-Amdyao_Q

#Variáveis Globais
$Seriais = Get-content -Path c:\temp\seriais.txt
$Hostname = Get-WmiObject Win32_ComputerSystem | Select-Object Name
$SerialHostname = Get-WmiObject Win32_BIOS | Select SerialNumber

##Avaliação de Hostname
foreach($Serial in $Seriais){
$SerialID = @($Serial -split ";")[0]
$HostnameID = @($Serial -split ";")[1]
    If ($SerialHostname.SerialNumber -eq $SerialID){
        if ($Hostname.Name -eq $HostnameID){
        exit 0}
    else{
    $Saida = $HostnameID
    $Saida | Out-File -FilePath c:\temp\LogIntune.txt
    exit 1}
}}