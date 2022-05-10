$Aplicativos = @()
$Servidores = @()

$Servidores = Get-Content -Path C:/TEMP/Softwares/servidores.txt

foreach($servidor in $Servidores)
{
$Aplicativos = Get-WmiObject -ComputerName $servidor -Class win32_product | select Name | Export-Csv "c:/temp/Softwares/$servidor.txt"
}