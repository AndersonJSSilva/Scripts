$Computadores = @();
$ComputadoresXP7 = @();
$ComputadoresOn = @();
$ComputadoresDBExpressXP7 = @();
$ComputadoresDBExpressOn = @();
$ComputadoresDBExpressXP = @();
$ComputadoresDBExpress7 = @();
$UsuarioXP = @();
$UsuariosXP = @();
$Usuario7 = @();
$Usuarios7 = @();


##Todos os Computadores

$Computadores = Get-ADComputer -filter * -Properties *


##Computadores com Windows XP ou 7

Foreach ($Computador in $Computadores)
{
if(($Computador.OperatingSystem -like "*7*") -or ($Computador.OperatingSystem -like "*xp*"))
{
$ComputadoresXP7 += $Computador
} 
}


##Computadores com DBExpress Instalado(Windows XP e 7)

Foreach ($ComputadorDbexpressXP7 in $ComputadoresXP7)
{
$registro = [microsoft.win32.registryKey]::openremotebasekey([microsoft.win32.registryhive]::LocalMachine,$ComputadorDbexpressXP7.Name)
$CaminhoRegistro32Bits = $registro.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Uninstall\DbxaddDbxOda_is1')
$CaminhoRegistro64Bits = $registro.OpenSubKey('Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DbxaddDbxOda_is1')
if(($CaminhoRegistro32Bits) -or ($CaminhoRegistro64Bits))
{
$ComputadoresDBExpressXP7 += $ComputadorDbexpressXP7
}
}


#Usuários com Windows XP(DBExpress Instalado)

Foreach ($ComputadorDBExpressXP in $ComputadoresDBExpressXP7)
{
if($ComputadorDBExpressXP.OperatingSystem -like "*xp*")
{
$ComputadoresDBExpressXP += $ComputadorDBExpressXP
$UsuarioXP = Get-WmiObject -Class win32_computersystem -ComputerName $ComputadorDBExpressXP.Name
$UsuariosXP += $UsuarioXP | ft UserName 
}
}
$ComputadoresDBExpressXP | ft name | Out-File C:\TEMP\xp.txt 
$UsuariosXP | Out-File C:\TEMP\xpusers.txt


#Usuários com Windows 7(DBExpress Instalado)

Foreach ($ComputadorDBExpress7 in $ComputadoresDBExpressXP7)
{
if($ComputadorDBExpress7.OperatingSystem -like "*7*")
{
$ComputadoresDBExpress7 += $ComputadorDBExpress7
$Usuario7 = Get-WmiObject -Class win32_computersystem -ComputerName $ComputadorDBExpress7.Name
$Usuarios7 += $Usuario7 | ft UserName 
} 
}
$ComputadoresDBExpress7 | ft name | Out-File C:\TEMP\7.txt
$Usuarios7 | Out-File C:\TEMP\7users.txt


##Computadores com Windows XP ou 7(Ligados)

Foreach ($ComputadorOn in $ComputadoresXP7)
{
if(Test-Connection $ComputadorOn.Name -Count 1 -ErrorAction SilentlyContinue)
{
$ComputadoresOn += $ComputadorOn
} 
}


##Computadores com DBExpress Instalado(Ligados)

Foreach ($ComputadorDbexpressOn in $ComputadoresOn)
{
$registro = [microsoft.win32.registryKey]::openremotebasekey([microsoft.win32.registryhive]::LocalMachine,$ComputadorDbexpressOn.Name)
$CaminhoRegistro32Bits = $registro.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Uninstall\DbxaddDbxOda_is1')
$CaminhoRegistro64Bits = $registro.OpenSubKey('Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DbxaddDbxOda_is1')
if(($CaminhoRegistro32Bits) -or ($CaminhoRegistro64Bits))
{
$ComputadoresDBExpressOn += $ComputadorDbexpressOn
}
}


##Totais de Computadores

Write-Host Computadores da Rede: $Computadores.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Computadores Windows XP e 7: $ComputadoresXP7.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Computadores com DBExpress com Windows XP e 7: $ComputadoresDBExpressXP7.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Usuários com DBExpress com Windows XP: $ComputadoresDBExpressXP.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Usuários com DBExpress com Windows 7: $ComputadoresDBExpress7.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Computadores Ligados: $ComputadoresOn.Length -ForegroundColor Yellow -BackgroundColor Red
Write-Host Computadores com DBExpress com Windows XP e 7 - Ligados: $ComputadoresDBExpressOn.Length -ForegroundColor Yellow -BackgroundColor Red