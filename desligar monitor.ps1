﻿#################################### Energia Windows 7###############################################################################

$computers = @("UNICOOP30409","pcjean-pc","UNICOOP30382")  
$computerOnline7 = @()
$computerOnlineXP = @()
$computerOffline = @()      

foreach ($computer in $computers) 
{
    if (test-Connection -count 1 -Cn $computer -quiet)
    {
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows 7*')
        {

            $computerOnline7 += $computer

        }
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows xp*')
        {
            
            $computerOnlineXP += $computer
        }
    }
     else {       
     $computerOffline += $computer
    } 
}

#####################################################################################################################################

Antes rodar o PSEXEC: C:\PsTools>PsExec.exe -d @server7.txt -u unimedrj\adm50610 -p SENH@FORT3 powercfg -energy -xml >> c:\temp\w7.txt

#####################################################################################################################################

foreach ($computer in $computerOnline7) 
{
          Copy-Item "\\$computer\c$\windows\system32\energy-report.xml" -Destination \\10.200.5.94\powercfg\$computer.xml
 
 }

$countNunca = 0
$countDesliga = 0 
$saidafinal = @()
foreach ($computer in $computerOnline7) 
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
        $saidafinal += "NUNCA;"+ $computer
        $countNunca ++
    } else {
        $saidafinal +=  "DESLIGAR;" +$computer
        $countDesliga ++
    }
}

$saidafinal += "`nQtd de PC que nunca desligam o monitor: "+ $countNunca
$saidafinal += "Qtd de PC que desligam o monitor: "+$countDesliga

$saidafinal

#################################### Energia Windows XP##############################################################################

C:\PsTools>PsExec.exe @serverXP.txt -u unimedrj\adm50610 -p SENH@FORT3 powercfg /query >> c:\temp\wxp.txt

#####################################################################################################################################

# Parse output xp file

#####################################################################################################################################

$txtfile = Get-Content "c:\temp\wxp.txt" -ErrorAction SilentlyContinue
$countNunca = 0
$countDesliga = 0 
$values = @()
$saidafinal = @()
foreach($line in $txtfile) 
{
    $strtmp = $line -replace " ",""
    if($strtmp -like "Desligarmonitor(AC)Nunca*")
    {
        $countNunca ++
        $values += $line
    }
        if($strtmp -like "Desligarmonitor(AC)Depoisde*")
    {
        $countDesliga ++
        $values += $line
    }
}

#$countNunca
#$countDesliga

$computersTXT = @()
foreach($line in $txtfile) 
{
    
    if($line -like "\\*")
    {
        $var1 = $line -replace "\\",""
        $var1 = $var1 -replace ":",""
        $computersTXT += $var1
    }
}

for($i=0;$i -lt $computersTXT.Count; $i++)
{
     += $computersTXT[$i] +" : " + $values[$i]

}
$saidafinal += "`nQtd de PC que nunca desligam o monitor: "+ $countNunca
$saidafinal += "Qtd de PC que desligam o monitor: "+$countDesliga

$saidafinal | Out-File c:\temp\picadasgalaxias.txt