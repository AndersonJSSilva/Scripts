function Remove-TrendMicroRegistry($hostname)
{
    $Hive = [Microsoft.Win32.RegistryHive]“LocalMachine”;
    $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive,$hostname);
 

$Services = @("ntrtscan","Perf_iCrcPerfMonMgr","tmactmon","TMBMServer","tmccsf","tm_cfw","tmcomm","TMEBC","tmeevw","tmeext","tmel","tmevtmgr","TmFilter","Tmlisten","tmlwf","tmnciesc","tmpfw","TmPreFilter","tmumh","tmusa","TmProxy","tmtdi","tmwfp","VSApiNt")

Write-Host CurrentControlSet -ForegroundColor White
$regs = $regKey.OpenSubKey("SYSTEM\CurrentControlSet\services\").GetSubKeyNames()
foreach($svc in $Services)
{
 if ($regs -contains $svc)
 {
    Write-Host removendo o serviço $svc -ForegroundColor Green
    reg delete "\\$hostname\HKLM\SYSTEM\CurrentControlSet\Services\$svc" /f
 } 
}

$regs = $regKey.OpenSubKey("SYSTEM").GetSubKeyNames()
if($regs -contains "ControlSet001")
{
Write-Host ControlSet001 -ForegroundColor White
$regs = $regKey.OpenSubKey("SYSTEM\ControlSet001\services\").GetSubKeyNames()
foreach($svc in $Services)
{
 if ($regs -contains $svc)
 {
    Write-Host removendo o serviço $svc -ForegroundColor Green
    reg delete "\\$hostname\HKLM\SYSTEM\ControlSet001\Services\$svc" /f
 } 
}
}

$regs = $regKey.OpenSubKey("SYSTEM").GetSubKeyNames()
if($regs -contains "ControlSet002")
{
Write-Host ControlSet002 -ForegroundColor White
$regs = $regKey.OpenSubKey("SYSTEM\ControlSet002\services\").GetSubKeyNames()
foreach($svc in $Services)
{
 if ($regs -contains $svc)
 {
    Write-Host removendo o serviço $svc -ForegroundColor Green
    reg delete "\\$hostname\HKLM\SYSTEM\ControlSet002\Services\$svc" /f
 } 
}
}

$regs = $regKey.OpenSubKey("SYSTEM").GetSubKeyNames()
if($regs -contains "ControlSet003")
{
Write-Host ControlSet003 -ForegroundColor White
$regs = $regKey.OpenSubKey("SYSTEM\ControlSet003\services\").GetSubKeyNames()
foreach($svc in $Services)
{
 if ($regs -contains $svc)
 {
    Write-Host removendo o serviço $svc -ForegroundColor Green
    reg delete "\\$hostname\HKLM\SYSTEM\ControlSet003\Services\$svc" /f
 } 
}
}

}

$pcs = @("10.200.5.200","unicoop25563")
foreach ($pc in $pcs)
{
    try{
    
    $ping = Test-Connection -ComputerName $pc -Count 1 -ErrorAction Stop
    Write-Host trabalhando em $pc -ForegroundColor Green

    $Hive = [Microsoft.Win32.RegistryHive]“LocalMachine”;
    $regKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive,$pc);

    if((Get-WmiObject Win32_OperatingSystem -computername localhost).OSArchitecture -eq "64-bit")
    {
        
        if(Test-Path "\\$pc\c$\tm_installed.txt")
        {
            Remove-Item "\\$pc\c$\tm_installed.txt" -Force -Confirm:$false
        }
        
        if(Test-Path "\\$pc\c$\Program Files (x86)\Trend Micro")
        {
            Remove-Item "\\$pc\c$\Program Files (x86)\Trend Micro" -Force -Recurse -Confirm:$false
        }
        
     if($regKey.OpenSubKey("SOFTWARE\Wow6432node\").GetSubKeyNames() -contains "TrendMicro")
     {
        reg delete "\\$pc\HKLM\SOFTWARE\Wow6432node\TrendMicro" /f
     }     
     if($regKey.OpenSubKey("SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\").GetSubKeyNames() -contains "OfficeScanNT")
     {       
        reg delete "\\$pc\HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\OfficeScanNT" /f
     }

     if($regKey.OpenSubKey("SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run").GetValueNames() -contains "OfficeScanNT Monitor")
     {        
        reg delete "\\$pc\HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /v "OfficeScanNT Monitor" /f
     }

     Remove-TrendMicroRegistry -hostname $pc


    }
    if((Get-WmiObject Win32_OperatingSystem -computername localhost).OSArchitecture -eq "32-bit")
    {

        if(Test-Path "\\$pc\c$\tm_installed.txt")
        {
            Remove-Item "\\$pc\c$\tm_installed.txt" -Force -Confirm:$false
        }
        
        if(Test-Path "\\$pc\c$\Program Files\Trend Micro")
        {
            Remove-Item "\\$pc\c$\Program Files\Trend Micro" -Force -Recurse -Confirm:$false
        }


     if($regKey.OpenSubKey("SOFTWARE\").GetSubKeyNames() -contains "TrendMicro")
     {
        reg delete "\\$pc\HKLM\SOFTWARE\TrendMicro" /f
     }     
     if($regKey.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\").GetSubKeyNames() -contains "OfficeScanNT")
     {       
        reg delete "\\$pc\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OfficeScanNT" /f
     }

     if($regKey.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Run").GetValueNames() -contains "OfficeScanNT Monitor")
     {        
        reg delete "\\$pc\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OfficeScanNT Monitor" /f
     }
     Remove-TrendMicroRegistry -hostname $pc

          
    }
    }catch{Write-Host nao disponivel $pc -ForegroundColor Red}

}

