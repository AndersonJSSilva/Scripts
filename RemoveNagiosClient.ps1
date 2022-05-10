#Share where the server source file and the log file will be stored. It has to be a UNC path.
$path="\\10.100.10.4\c$\temp\"

#Path to the Nagios agent setup file NSClient++.exe 
$nagiospath="\\10.100.10.4\c$\temp\NSClient++-0.3.9-Win32.msi /uninstall /qn"
$nagiospath64="\\10.100.10.4\c$\temp\NSClient++-0.3.9-Win64.msi /uninstall /qn"

#File which includes the server names (one server name per line)
$serverfile = $path + "server.txt"

#Path to the log file
$log=$path + "NagiosRemoval.log"

$ARCH=(gwmi -Computer localhost -Query "Select OSArchitecture from Win32_OperatingSystem").OSArchitecture
If ($ARCH -eq "32-bit") {'Install 32 bit version'} 
Else {'Install 64 bit version'} 


If (!(Test-Path -path $serverfile)) {Write-Host "Provide a file in $path named server.txt containing server names"}

If (!(Test-Path -path $log)) {New-Item $log -type file}

#Read the server.txt file
$servers= Get-Content $serverfile

ForEach ($server in $servers) {


#Check if the service is installed on the remote machine
$nagiosservice = Get-Service -ComputerName $server | Where-Object {$_.Name -eq "NSClientpp"}

        #If the service is installed
        If (!($nagiosservice -eq $null)) { 

            #Command to remotly remove the Nagios agent
            Invoke-WmiMethod -Path win32_process -Name create -ArgumentList $nagiospath -ComputerName $server

            #Get the current date/time
            [string]$date=date

            #Write to log file if the agent is being uninstalled
            "$date Uninstalling Nagios Agent from Server $server" | Out-File -FilePath $log -Append

        }
        #Write to log file if Nagios agent service has been found
        else
        {"$date No Nagios Agent on $server found!" | Out-File -FilePath $log -Append }

}
