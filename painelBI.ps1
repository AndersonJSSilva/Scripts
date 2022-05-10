<#
file://siecoopprd02/painelfiles$/A01%20-%20Painel%20Pedidos%20Pendentes%20Autoriza%E7%E3o.mht
file://siecoopprd02/painelfiles$/A02%20-%20Painel%20Gerencial%20%20Entrega.mht
file://siecoopprd02/painelfiles$/A03%20-%20Benefici%E1rios%20Internados.mht
file://siecoopprd02/painelfiles$/A04%20-%20Painel%20POSU.mht
file://siecoopprd02/painelfiles$/A04.1%20Painel%20Contratos%20Cancelados%20(Pr%E9via).mht
file://siecoopprd02/painelfiles$/A04.2%20Painel%20Contratos%20Novos%20(Pr%E9via).mht

$path = 'HKCU:\Software\Microsoft\Internet Explorer\Main\'
$name = 'start page'
(Get-Itemproperty -Path $path -Name $name).$name

#>

$mhts = Get-ChildItem -Path \\siecoopprd02\PainelFiles$\*.mht
$value = ""
$path = 'HKCU:\Software\Microsoft\Internet Explorer\Main\'
$name = 'start page'
foreach($file in $mhts)
{
    $value += "file://siecoopprd02/PainelFiles$/"+$file.name+"`n"
}
Set-Itemproperty -Path $path -Name $name -Value ""
Set-Itemproperty -Path $path -Name $name -Value $value

cmd.exe /c "C:\Program Files (x86)\Internet Explorer\iexplore.exe" 

sleep ($mhts.count * 2)

$wshell=New-Object -ComObject wscript.shell;
$wshell.AppActivate('Internet Explorer');
sleep 10
$wshell.SendKeys('{F11}');

while(1 -eq 1)
{
  Sleep 5;
  $wshell.SendKeys('^{TAB}');
}