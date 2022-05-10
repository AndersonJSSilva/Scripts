$servidor = "opmehmg01"

$path = "\\OPMEHMG01\c$\Inetpub\wwwroot\unimed\opme20\"
$folderbk1 = "src"
$folderbk2 = "www"
$strpathdst1 = "BK_"+$folderbk1+"_"+(get-date).ToString("yyyyMMdd")
$strpathdst2 = "BK_"+$folderbk2+"_"+(get-date).ToString("yyyyMMdd")
$pathori1 = $path+$folderbk1
$pathori2 = $path+$folderbk2
$pathdest1 = $path+$strpathdst1
$pathdest2 = $path+$strpathdst2

Copy-Item -Path $pathori1 -Destination $pathdest1 -Recurse
Copy-Item -Path $pathori2 -Destination $pathdest2 -Recurse

$servico = "IISadmin"
$Servico2 = "World Wide Web"

$pastaversao = "C:\OPMEHMG"
$versoes = Get-ChildItem $pastaversao | Sort-Object basename
$count=0
write-host "########## Zip encontrados ###########" -ForegroundColor black -BackgroundColor yellow
write-host "######################################" -ForegroundColor black -BackgroundColor yellow
foreach ($filezip in $versoes){
    $count +=1
    write-host $count " - " $filezip.Name -ForegroundColor yellow

}
write-host "######################################" -ForegroundColor black -BackgroundColor yellow
write-host "######################################" -ForegroundColor black -BackgroundColor yellow
$int = read-host "digite o numero do zip"
$ZipFile = $versoes[$int-1].FullName
$pasta = $versoes[$int-1].BaseName
Get-ChildItem $ZipFile | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-oC:\temp\deploy\$pasta"}

$files = @()
if (test-path "c:\temp\deploy\$pasta\*.sql")
{
    write-host "Possui Script SQL. Enviando email para _infra-ti_dba"
    $filestoatt = Get-Item "c:\temp\deploy\$pasta\*.sql"
    $corpo = "`nPrezados,`n`nFavor aplicar em OPME HMG.`nScripts em Anexo.`n`nAtt,"
    Send-MailMessage -to "Infra DBA <_infra-ti_dba@unimedrio.com.br>" -from "Infra Windows <_infra-ti_servidores_windows@unimedrio.com.br>" -subject "Aplicar em OPME HMG" -SmtpServer "mail.unimedrio.com.br" -Body $corpo -Attachments $filestoatt
}

pause

#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}

#Para os serviços
write-host "Parando: " $service.caption  " em " $servidor -ForegroundColor black -BackgroundColor yellow
(Get-Service -ComputerName $servidor -Name 'IISAdmin').stop()
$out = 0
$process = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
while ($process.state -ne "stopped")
{
    $out += 1
    Start-Sleep 1
    $process = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
}

write-host "copiando para... $servidor -> C:\Inetpub\wwwroot\unimed\opme20\" -ForegroundColor yellow

Get-ChildItem "c:\temp\deploy\$pasta\" | where-object {$_.PSiscontainer} | Copy-Item -Destination $path -Recurse -Force



#Inicia os serviços
(Get-Service -ComputerName $servidor -Name 'IISAdmin').start()
write-host "Iniciando: " $service.caption  " em " $servidor -ForegroundColor black -BackgroundColor yellow
Start-Sleep 10
(Get-Service -ComputerName $servidor -Name 'w3svc').start()
write-host "Iniciando: " $servico2 " em " $servidor -ForegroundColor black -BackgroundColor yellow


Get-ChildItem -path "c:\temp\deploy\" -Recurse | where-object {$_.PSiscontainer} | Remove-Item -Recurse -Force

$pathdelete = "\\opmehmg01\c$\Inetpub\wwwroot\unimed\opme20\cache\smarty-template-c\"
Get-ChildItem -path $pathdelete -Recurse |  Remove-Item -Recurse -Force 

write-host "Finalizado!!!!!" -ForegroundColor white -BackgroundColor green

