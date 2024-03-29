﻿Function enableWinRM($server) {

$global:compName = $server

	$result = winrm id -r:$global:compName 2>$null

	Write-Host	
	if ($LastExitCode -eq 0) {
		Write-Host "WinRM already enabled on" $global:compName "..." -ForegroundColor green
	} else {
		Write-Host "Enabling WinRM on" $global:compName "..." -ForegroundColor red
		c:\pstools\psexec.exe \\$global:compName -s C:\Windows\system32\winrm.cmd qc -quiet
		if ($LastExitCode -eq 0) {
			c:\pstools\psservice.exe \\$global:compName restart WinRM
			$result = winrm id -r:$global:compName 2>$null
			
			if ($LastExitCode -eq 0) {Write-Host 'WinRM successfully enabled!' -ForegroundColor green}
			else {#exit 1
}
		} 
		else {#exit 1
}
	}
}



foreach($srv in $servers)
{
    enableWinRM -server $srv.Name
}



