Get-ADuser -identity "domain admins" -Properties *
Get-ADGroup  -filter { name -like "_infra-ti_ser*"} |  get-ADGroupMember | select name, samaccountname, managedby

$groups = Get-ADGroup -filter { groupcategory -eq "distribution"} -Properties managedby,info,description  -Server dcbenprd06
$groups.Length
#$groups | select name,samaccountname,info,description,managedby | Export-csv -Path c:\temp\distgroups.csv -Encoding Unicode
$groups | select name,samaccountname,info,description,managedby | ConvertTo-Html | Set-Content c:\temp\distgps.html

$groups[500].managedby

(Get-ADObject -Identity $groups[500].managedby -Properties *).Displayname

$managers =@()
foreach($group in $groups)
{
    $str = $group.managedby
    #$managers += Get-ADObject -Identity $group.managedby -Properties *
}
$managers

$gp = Get-ADGroup -filter {name -like "_infra*"} -Properties *
$gp

Get-ADComputer -Identity supwinprd01 -Properties *

$pcs = Get-ADComputer -Properties * -Filter  {OperatingSystem  -like "*2003*"} -Server dcbenprd06 | select name,OperatingSystem
$pcs.Length