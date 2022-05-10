function get-trustedhost {

[CmdletBinding()]

param (

[string]$computername = $env:COMPUTERNAME

)

 

if (Test-Connection -ComputerName $computername -Quiet -Count 1) {

Get-WSManInstance -ResourceURI winrm/config/client -ComputerName $computername |

select -ExpandProperty TrustedHosts

}

else {

Write-Warning -Message “$computername is unreachable”

}

}

get-trustedhost -computername sccmprd01

$grupo = "GS_libera_leitura_pendriver"
$saida = (get-adgroup -Filter {samaccountname -like $grupo} -Properties * -Server adsrv33.uremh.local).members | %{try{get-aduser -Identity $_ -Server adsrv33.uremh.local -Properties * | ?{$_.enabled -eq $true}| Select samaccountname, name, Title, Department -ErrorAction Stop} catch{}}
$saida | Export-Csv C:\temp\GS_libera_leitura_pendriverr.csv


