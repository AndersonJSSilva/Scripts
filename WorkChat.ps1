##Limpeza de Variáveis
$Computadores = @();
$Computador = @();
$ComputadorWorkChat = @();
$AplicativoWorkChat = @();

##Todos os Computadores
$Computadores = Get-ADComputer -filter * -Properties *

##Computadores com WorkChat Instalado
Foreach ($Computador in $Computadores)
{
$AplicativoWorkChat = Get-WmiObject -Class Win32_Product -ComputerName $Computador.Name -ErrorAction SilentlyContinue | ?{$_.Name -like "*Workplace*"}
if($AplicativoWorkChat -ne $null){
$ComputadorWorkChat += $Computador.Name
}
}

##Totais de Computadores
Write-Host Computadores da Rede: $Computadores.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Computadores com WorkChat: $ComputadorWorkChat.Length -ForegroundColor Yellow -BackgroundColor Red