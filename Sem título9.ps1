$groups = Get-ADGroup -filter {(name -like "_adm*") -and (GroupCategory -eq "Security")} -Properties * 
#$groups = Get-ADGroup -filter {name -like "*admsas*"} -Properties * | select -First 10
$groups.Length
$groups | select name
$members = $null

foreach($group in $groups)
{
    $group.samaccountname+";"+(get-ADGroupMemberofGroupRecurse $group.samaccountname)
}

function get-ADGroupMemberofGroupRecurse($samaccountname)
{

    $members = Get-ADGroupMember -Identity $samaccountname
    foreach($member in $members)
    {
        if($member.objectclass -eq "Group")
        {
           $saida =  ($member.distinguishedName -split ",")[0] -replace "CN=",""   
           $saida +";"+(get-ADGroupMemberofGroupRecurse $saida)
        }
        $saida = $null
    }

}



Get-ADGroup -Filter {MemberOf -ne "{}"} -Properties *| select name


$filter = "(useraccountcontrol:1.2.840.113556.1.4.803:=2)"
$start  = Get-Date "21/09/2015"
$end    = Get-Date "24/09/2015"
Get-ADUser -LDAPFilter $filter -Properties * | ? {($_.modifyTimeStamp -gt $start -and $_.modifyTimeStamp -lt $end) -and $_.enabled -eq $false} | ft name, samaccountname, enabled -AutoSize

$user  = Get-ADUser -filter {(enabled -eq $true)}-Properties * |
?{($_.samaccountname.substring(0,1) -eq "m") -or ($_.samaccountname.substring(0,1) -eq "e") -or ($_.samaccountname.substring(0,1) -eq "j") -or ($_.samaccountname.substring(0,1) -eq "c") -or ($_.samaccountname.substring(0,1) -eq "tr")} |
 select name, EmailAddress, samaccountname, department, CanonicalName

$user  = Get-ADUser -filter {(enabled -eq $true)}-Properties * -Server adsrv33.uremh.local|
?{($_.samaccountname.substring(0,2) -eq "pj") -or ($_.samaccountname.substring(0,1) -eq "h")} |
select name, EmailAddress, samaccountname


$user | export-csv c:\temp\usersUREH.csv -encoding unicode
$user.Length

Get-ADUser -filter {displayname -like "ana*caro*reira*"}-Properties * | select name, displayname, description, department


Get-ADUser -filter {(enabled -eq $true)}-Properties * |
?{($_.samaccountname.substring(0,1) -eq "m") -or ($_.samaccountname.substring(0,1) -eq "e") -or ($_.samaccountname.substring(0,1) -eq "j") -or ($_.samaccountname.substring(0,1) -eq "c") -or ($_.samaccountname.substring(0,1) -eq "tr")} |
select name, EmailAddress, samaccountname, department | sort-object samaccountname