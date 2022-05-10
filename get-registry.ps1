$hosts =  @("Uniben04002272","Uniben04002270","uniben03002064") 
$hosts = Get-Content C:\PsTools\maquinas.txt
$hosts = Get-Content C:\temp\maquinascc.txt
$hosts = Get-Content C:\temp\erro40.txt
$hosts = Get-Content C:\temp\sccmwin7.txt

$hosts | %{
$Reg = $RegKey = $null
Get-ADComputer $_ -Properties *| select name, operatingsystem
$_
try {
    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $_)
    $RegKey= $Reg.OpenSubKey("SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\")
    $RegKey.GetSubKeyNames() | Sort-Object -Descending | select -First 1 
    }catch{
    write-host maquina offline -ForegroundColor Yellow
    }
}


$hosts | %{Get-ADComputer $_ -Properties *| select name, operatingsystem}
$hosts | %{Get-WmiObject -ComputerName $_ Win32_OperatingSystem  | select name, OSArchitecture}

############################ verifica se tem 3.5 sp1
$hosts | %{
$Reg = $RegKey = $null
#Get-ADComputer ($_ -replace ".unimerj.root","")-Properties *| select name, operatingsystem
$_
try {

    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$_)
    $RegKey= $Reg.OpenSubKey("SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v3.5\\")
    if($RegKey.getvalue("SP"))
    {
        Write-host SP1 instalado!!!
    } else {Write-host SP1 nao instalado!!!}
    }catch{
    write-host maquina offline -ForegroundColor Yellow
    }
}


################ vcredit SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{9A25302D-30C0-39D9-BD6F-21E6EC160475}
$hosts | %{
$Reg = $RegKey = $null
#Get-ADComputer ($_ -replace ".unimerj.root","")-Properties *| select name, operatingsystem
$_
try {

    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$_)
    $RegKey= $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\")
    #$regkey.GetSubKeyNames() |?{$_ -like "*9A25302D*"}
    if($regkey.GetSubKeyNames() |?{$_ -like "{9A25302D-30C0-39D9-BD6F-21E6EC160475}"})
    {
        Write-host vcredist 2008 sp1 instalado!!!
    } else {Write-host vcredist 2008 sp1 nao instalado!!!}
    }catch{
    write-host maquina offline -ForegroundColor Yellow
    }
}


#################### remove software distribution folder
$hostsSD = Get-Content "c:\temp\erro40.txt"
$hostsSD | %{
$serv = Get-Service WuAuServ -ComputerName $_ 
$serv | select machinename, servicename, status, displayname
$serv.Stop()
Start-Sleep 3
$serv = Get-Service WuAuServ -ComputerName $_ 
$serv | select machinename, servicename, status, displayname
remove-Item -Path "\\$_\c$\Windows\SoftwareDistribution" -Confirm:$false -Recurse -Force
$serv.Start()
Start-Sleep 3
$serv = Get-Service WuAuServ -ComputerName $_ 
$serv| select machinename, servicename, status, displayname
}

Get-Process -ComputerName unicoop30381 | ?{$_.name -like "*setup*"} | ft machinename, processname, id -AutoSize -Wrap



####Configuration Manager Client	{FD794BF1-657D-43B6-B183-603277B8D6C8}	20140425	Microsoft Corporation	5.00.7804.1000
$hosts | %{
$Reg = $RegKey = $null
#Get-ADComputer ($_ -replace ".unimerj.root","")-Properties *| select name, operatingsystem
$_
try {

    $Reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine',$_)
    $RegKey= $Reg.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\")
    if($regkey.GetSubKeyNames() |?{$_ -like "{FD794BF1-657D-43B6-B183-603277B8D6C8}"})
    {
        Write-host sccm client instalado!!!
    } else {Write-host sccm client nao instalado!!! -ForegroundColor Red}
    }catch{
    write-host maquina offline -ForegroundColor Yellow
    }
}