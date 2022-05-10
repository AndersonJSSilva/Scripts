$Server = "dcbar01"
$Scriptblock = {cmd.exe /c ipconfig}   cmd.exe /c ipconfig  IISRESET

invoke-command -computername $server -scriptblock $Scriptblock

$IIS = Get-Service -DisplayName *iis* -ComputerName neoextprd02
$IIS.Stop()
$IIS.Status
WHILE($IIS.Status -ne "Stopped")
{
"Running"
}
$IIS.Start()

