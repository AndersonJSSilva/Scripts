$servidor = Read-Host "Digite o servidor"
if (!$servidor)
{    Write-Host "Nada digitado"
    break
}
$servico = "neocrmmiddleware"

$pastaversao = "\\arqprd01\getin$\Sistemas Operacionais\Projetos\Projetos em andamento\CRM Atendimento\Desenvolvimento\NeoCrmMiddleware\Versoes\"
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
Get-ChildItem $ZipFile | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-oC:\temp\deploy"}

pause

#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Para os serviços
write-host "Parando: " $service.caption  " em " $servidor -ForegroundColor black -BackgroundColor yellow
$service.InvokeMethod('StopService',$Null)

$out = 0
$process = Get-WmiObject -Class Win32_Process -ComputerName $servidor -Filter "name like 'crm.exe'"
while ($process)
{
    $out += 1
    Start-Sleep 1
    $process = Get-WmiObject -Class Win32_Process -ComputerName $servidor -Filter "name like 'crm.exe'"
}

write-host "copiando para... $servidor -> C:\Neo.Servico\AtendimentoAutorizacao\Crm\" -ForegroundColor yellow
Copy-Item -path "c:\temp\deploy\$pasta\*.*" "\\$servidor\C$\Neo.Servico\AtendimentoAutorizacao\Crm\" -Force


#Inicia os serviços
$service.InvokeMethod('StartService',$Null)
write-host "Iniciando: " $service.caption  " em " $servidor -ForegroundColor black -BackgroundColor yellow

Get-ChildItem -path "c:\temp\deploy\" -Recurse | where-object {$_.PSiscontainer} | Remove-Item -Recurse -Force

write-host "Finalizado!!!!!" -ForegroundColor white -BackgroundColor green