$Server = Get-Process -ComputerName avtst01 -Name avp| select ProcessName, *CPU*

$Server | Out-GridView -Title teste