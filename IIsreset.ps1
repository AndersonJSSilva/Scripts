Write-Host "Script para reiniciar IIS remotamente"
$servidor = Read-Host "Digite o nome do servidor"
if (!$servidor)
{
    Write-Host "Nada digitado"
    break
}

if(Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'")
{
    $service = Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'"
    $service.InvokeMethod('StopService',$Null)
    Write-Host "Serviço: " $service.State
    while((Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'").State -ne "Stopped")
    {
        Write-Host "Serviço: " (Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'").State
    }
    $service.InvokeMethod('StartService',$Null)
    while((Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'").State -ne "Running")
    {
    Write-Host "Serviço: " (Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'").State
    }
    Write-Host "Serviço: " (Get-WmiObject -computer $servidor Win32_Service -Filter "Name='IISAdmin'").State
}
else
{
    Write-Host "Servico nao encontrado!!!!"
}

$bios = get-WmiObject -class Win32_DriverForDevice -computer "localhost" -Filter "name like '%fax%'"
foreach ($item in $bios)
{
    write-host $item.Path   
}

