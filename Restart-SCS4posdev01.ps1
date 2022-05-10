function Restart-SCS4(){
$servidor = "posdev02"
$servico = "scs4"
#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Para os serviços
foreach( $service in $services){
$service.InvokeMethod('StopService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
Start-Sleep 5
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Inicia os serviços
foreach( $service in $services){
$service.InvokeMethod('StartService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
}

Restart-SCS4

function Restart-ClientD(){
$servidor = "posdev02"
$servico = "clientd"
#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Para os serviços
foreach( $service in $services){
$service.InvokeMethod('StopService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
Start-Sleep 5
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Inicia os serviços
foreach( $service in $services){
$service.InvokeMethod('StartService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "Caption like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
}

Restart-ClientD

