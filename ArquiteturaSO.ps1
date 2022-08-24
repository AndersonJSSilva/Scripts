$ArquiteturaSO=get-wmiobject win32_operatingsystem | select-object OSArchitecture
$Servicos=Get-Service | select name

Foreach( $Servico in $Servicos){
If ($Servico.Name -eq 'OCS Inventory Service'){
}else{
If ($ArquiteturaSO.OSArchitecture -eq "64 bits"){
c:/OCS-Windows-Agent-Setup-x64.exe /SERVER=http://10.24.22.122/ocsinventory /S /NOSPLASH /tag="Teste" /user=ocsagentes /pwd=PSWAgente /NOW
}else{
c:/OCS-Windows-Agent-Setup-x86.exe /SERVER=http://10.24.22.122/ocsinventory /S /NOSPLASH /tag="Teste" /user=ocsagentes /pwd=PSWAgente /NOW
}}}