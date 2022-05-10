$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session

[Int] $intSent = $intRec = 0
$datainicio = "11/09/2015 00:00:00"
$datafim = "11/09/2015 23:59:00"

Get-MessageTrackingLog -ResultSize Unlimited -Server boxprd01 -Start $datainicio -End $datafim -EventID RECEIVE | ? {$_.Source -eq "STOREDRIVER"} | ForEach { $intSent++ }
Get-MessageTrackingLog -ResultSize Unlimited -Server boxprd02 -Start $datainicio -End $datafim -EventID RECEIVE | ? {$_.Source -eq "STOREDRIVER"} | ForEach { $intSent++ }

Get-MessageTrackingLog -ResultSize Unlimited -Server boxprd01 -Start $datainicio -End $datafim -EventID DELIVER | ForEach { $intRec++ }
Get-MessageTrackingLog -ResultSize Unlimited -Server boxprd02 -Start $datainicio  -End $datafim -EventID DELIVER | ForEach { $intRec++ }

Write-Host "E-mails sent:    ", $intSent

Write-Host "E-mails received:", $intRec