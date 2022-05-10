$pcs = Get-Content C:\temp\sccmnoclient.txt
foreach($pc in $pcs)
{
    try{
    write-host $pc -ForegroundColor Yellow
    Copy-Item C:\script\repairwmi.bat \\$pc\c$\repairwmi.bat -Force
    #Get-WMIObject -class Win32_ComputerSystem -ComputerName $pc | select username -ErrorAction Stop
    }
    catch{}
}

foreach($pc in $pcs)
{
   if(Test-Path \\$pc\c$\repairwmi.bat)
   {
        write-host $pc -ForegroundColor Yellow
   }else
   {
        write-host $pc -ForegroundColor Red
        Copy-Item C:\script\repairwmi.bat \\$pc\c$\repairwmi.bat -Force
   }
}

Copy-Item C:\script\repairwmi.bat \\unicoop26257\c$\repairwmi.bat -Force
Get-WMIObject -class Win32_ComputerSystem -ComputerName unicoop29081 | select username
ping unicoop29081
