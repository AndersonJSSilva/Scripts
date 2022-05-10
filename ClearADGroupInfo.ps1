$grupos = Get-ADGroup -Properties * -Filter {info -like "*"} | select samaccountname, info

#$grupos | Export-Csv c:\temp\grupoinfo.csv -Encoding Unicode

foreach($grupo in $grupos)
{


    Set-ADGroup -Identity $grupo.samaccountname -clear info

}


Get-ADGroupMember _infra-ti_vmware
