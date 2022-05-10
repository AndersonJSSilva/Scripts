$ArrComputers =  "neoextprd01", "neoextprd02", "neobarprd01","neobarprd02","neobarprd03","neopdoprd01","neopdoprd02","casprd01", "casprd02", "boxprd01","boxprd02"
$ArrComputers =  "crmserprd01","crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02","crmbipprd01","crmwsprd01","crmwsprd02","crmgtwprd01","crmgtwprd02"


Clear-Host
foreach ($Computer in $ArrComputers) 
{
    $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer
    $computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
    $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
    $computerCPU = get-wmiobject Win32_Processor -Computer $Computer
    [array]$computerCPUCore = get-wmiobject Win32_Processor -Computer $Computer
    if($computerCPU.Length -ne $null){$computerCPU = $computerCPU.Length.ToString() + " x " + $computerCPU[0].Name} else {$computerCPU = "1 x " + $computerCPU.Name}
    $computerHDD = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter drivetype=3
    
        write-host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
        "-------------------------------------------------------"
        "Manufacturer: " + $computerSystem.Manufacturer
        "Model: " + $computerSystem.Model
        #"Serial Number: " + $computerBIOS.SerialNumber
        "CPU: " + $computerCPU
        "Core / CPU: "+ $computerCPUCore.NumberOfLogicalProcessors[0]
        if($computerHDD.Length -ne $null){$i=1;$computerHDD | %{"HDD "+$i+" Capacity: "+ "{0:N2}" -f ($_.Size/1GB)  + "GB";$i++}}else {"HDD Capacity: "+"{0:N2}" -f ($computerHDD.Size/1GB) + "GB"}
        #"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
        "RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
        "Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
        #"User logged In: " + $computerSystem.UserName
        #"Last Reboot: " + $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
        ""
        "-------------------------------------------------------"
}

