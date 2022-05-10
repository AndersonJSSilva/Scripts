$t = @()
$teste = @()
$teste = Get-Content -Path C:\temp\teste.txt
foreach($i in $teste)
{
$f = Test-Connection $i
if($f -ne $Null)
{
$t += $i
}
} 
write-host "---------------Máquinas---------------"-ForegroundColor Red -BackgroundColor White
Write-Host $t -ForegroundColor Red -BackgroundColor White 
$t | Out-File c:\temp\testei.txt
