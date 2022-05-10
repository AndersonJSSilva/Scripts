$psexec = C:\PsTools\PsExec.exe \\unicoop30427 powercfg /x /monitor-timeout-ac 0


$computers = @("unicoop304255557","unicoop55555555","unicoop30427","unicoop30410")   
$saida = $null

foreach ($computer in $computers) {
    if (test-Connection -count 1 -Cn $computer -quiet) {
     C:\pstools\psexec.exe -d \\$computer powercfg /x /monitor-timeout-ac 0
     $saida += "`n" + $computer + "`t" + "is online"
    }
     else {
        #"$computer is not online"
        $saida += "`n" + $computer + "`t" + "is not online"
           } 
}

$session = New-PSSession -Credential unimedrj\adm50610

Get-WmiObject -ComputerName Unibar02025032 -Class Win32_OperatingSystem | select *

$computer = "pcjean-pc"

$computers = @("pcjean-pc","Unibar02025032")  
$computerOnline = @()
$computerOffline = @() 

foreach ($computer in $computers) 
{
    if (test-Connection -count 1 -Cn $computer -quiet)
    {
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows 7*')
        {
            Invoke-Command -ComputerName $computer -ScriptBlock {powercfg -energy -xml} -AsJob     
            $computerOnline += $computer
        }
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows xp*')
        {
            
            #$cmdline = "/query >> c:\$computer.txt"
            #Invoke-Command -ComputerName $computer -ScriptBlock {}
            #start-process -Wait -PSPath "c:\pstools\PsExec.Exe" -ArgumentList $cmdline -RedirectStandardError c:\temp\$computer-error.log -RedirectStandardOutput c:\temp\$computer-output.log
            $computerOnline += $computer

            $command = "powercfg -query @> C:\teste.txt"
            $process = [WMICLASS]"\\$Computer\ROOT\CIMV2:win32_process"
            $result = $process.Create($command) 


        }
    }
     else {       
     $computerOffline += $computer
    } 
}



Get-Job



foreach ($computer in $computerOnline) 
{
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem 
        if($OS.caption -like '*Windows 7*'){
          Copy-Item "\\$computer\c$\users\adm50610\documents\energy-report.xml" -Destination \\10.200.5.94\powercfg\$computer.xml
        }
        if($OS.caption -like '*Windows XP*'){
          Copy-Item "\\$computer\c$\documents and settings\adm50610\Meus documentos\energy-report.xml" -Destination \\10.200.5.94\powercfg\$computer.xml
        }
}

foreach ($computer in $computerOnline) 
{

    [xml]$xmlfile = Get-Content "C:\powercfg\$computer.xml" -ErrorAction SilentlyContinue
    $achou = $false
    foreach($line in $xmlfile.GetElementsByTagName("Name"))
    {

        if ($line.InnerText -eq "Tempo limite do monitor desabilitado (conectado)")
        {
            $achou = $true
            break
        }
    }
    if($achou)
    {
        Write-host "NUNCA" $computer -ForegroundColor red
    } else {
        Write-Host "DESLIGAR" $computer -ForegroundColor yellow
    }
}


Get-Job -Id 14 | select *


Test-Connection -Count 1 -ComputerName unicoop30427