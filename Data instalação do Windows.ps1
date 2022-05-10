$pc = "unicoop30923"
([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $pc ).InstallDate) 
