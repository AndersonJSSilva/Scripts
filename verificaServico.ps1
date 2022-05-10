$servidor = Read-Host "Digite o nome do servidor"
$servico = read-host "Digite o nome do servico"
if (!$servidor -or !$servico){
    Write-Host "Nada digitado"
    break
}

#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}

$option = read-host "Digite stop ou start"
switch ($option) 

    { 
        stop {
                #Para os serviços
                foreach( $service in $services){
                $service.InvokeMethod('StopService',$Null)
                write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
                }
        }
         
        start {
            #Inicia os serviços
            foreach( $service in $services){
            $service.InvokeMethod('StartService',$Null)
            write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
            }
        }
        default {"Opcao errada"}
    }