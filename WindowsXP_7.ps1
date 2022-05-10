$máquinas = @()
$conteudo = @()
$conteudo = Get-Content -Path c:\temp\teste.txt

$máquinas = Get-WmiObject -class win32_operatingsystem -ComputerName $conteudo

foreach($maq in $máquinas)
{
if($maq.name -like "*windows 7*"){
Write-Host $maq.PSComputerName "- Windows 7"
}
else
{
write-host $maq.PSComputerName "- Windows XP"
}
}