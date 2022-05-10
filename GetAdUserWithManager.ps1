#gera lista Unimed
Get-ADUser -filter {samaccountname -like "*"} -Properties * |
select Name, samaccountname, department, @{L='Manager';E={($_.Manager.Substring($_.Manager.IndexOf("=") + 1, $_.Manager.IndexOf(",") - $_.Manager.IndexOf("=") - 1)).tostring()}} |
Export-Csv c:\temp\userADwithmanagerUnimed.csv -Encoding Unicode

#gera lista UREMH
Get-ADUser -filter {samaccountname -like "h003*"} -Properties * -Server adsrv33.uremh.local|
select Name, samaccountname, department, @{L='Manager';E={($_.Manager.Substring($_.Manager.IndexOf("=") + 1, $_.Manager.IndexOf(",") - $_.Manager.IndexOf("=") - 1)).tostring()}} |
Export-Csv c:\temp\userADwithmanagerUREMH.csv -Encoding Unicode


$entrada = Get-Content C:\temp\adusermanager.txt
foreach($users in $entrada)
{
    $user = ($users -split ";")[0]
    $manager = ($users -split ";")[1]
    write-host Usuário: $user -> Manager: $manager -foregroundColor Yellow
    Set-ADUser -Identity $user -Manager $manager -Server adsrv33.uremh.local

}


get-aduser -Identity m41718 -Server dcben01.unimedrj.root


Get-ChildItem -path '\\10.200.5.94\c$\Users\m50610\' -Include *.ps1 -Recurse