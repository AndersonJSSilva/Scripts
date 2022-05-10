function Restart-Service(){
#Requires -Version 2.0             
[CmdletBinding()]             
 Param              
   (                        
    [Parameter(Mandatory=$true, 
               Position=0,                           
               ValueFromPipeline=$true,             
               ValueFromPipelineByPropertyName=$true)]             
    [String[]]$ComputerName,
    [String[]]$Servicename
   )#End Param 
$servidor = $ComputerName
$servico = $Servicename
#Mostra os serviços encontrados
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Para os serviços
foreach( $service in $services){
$service.InvokeMethod('StopService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
Start-Sleep 5
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
#Inicia os serviços
foreach( $service in $services){
$service.InvokeMethod('StartService',$Null)
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
$services = Get-WmiObject -computer $servidor Win32_Service -Filter "name like '%$servico%'"
foreach( $service in $services){
write-host "Nome: " $service.caption "# Status: " $service.state -ForegroundColor black -BackgroundColor yellow
}
}

Restart-service -ComputerName excprd04 -Servicename rm.host
Restart-service -ComputerName excprd04 -Servicename w3svc

Restart-service -ComputerName spoappprd01 -Servicename ProcessExecutionService


