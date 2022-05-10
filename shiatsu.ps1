$PlainPassword = Read-Host -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PlainPassword)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$scriptblock = {cmd.exe \c c:\pstools\psfile.exe \\arqprd01 \u unimedrj\m41718 \p $PlainPassword C:\arqprd01\Departament\Shiatsu$\SHIATSU_BARRA.xls /c}
Invoke-Command -ScriptBlock $scriptblock
Write-Host $saida
pause

