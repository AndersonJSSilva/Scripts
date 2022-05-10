###################Verificar espaço Usado no DISCO###########

$servers = @("unicoop30427","excprd04","excboxprd02")
$saida = ""
Get-WmiObject -ComputerName $servers win32_logicaldisk -Filter "drivetype = 3" | % { $saida += "`n"+ $_.systemname + "`t" + $_.name + "`t" +("{0:N2}" -f (($_.size - $_.freespace)/1GB) + "GB") +"`n"  } | Out-File -FilePath C:\temp\serverperf.txt


$saida | Out-File -FilePath C:\temp\serverperf.txt


Get-WmiObject -ComputerName $servers win32_logicaldisk -Filter "drivetype = 3" | select *

#Select-Object name,Size,FreeSpace

#Get-WMIObject Win32_LogicalDisk | ForEach-Object {$_.freespace / 1GB}

get-date -f "dd/MM/yyyy hh:mm:ss"

############Conexões correntes##########

GWmi -List *_server*

$computer = @("neoappprd01","neoappprd02","neoappprd03","neoappprd04","neoappprd05","neoappprd06")

Get-WmiObject -ComputerName $computer Win32_ServerConnection | select *name, *number* | Out-GridView

