$pc = "unibar02014002"
([WMI]'').ConvertToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $pc ).InstallDate)

