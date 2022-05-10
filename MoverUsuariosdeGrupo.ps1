get-adobject -filter {objectclass -eq "user" -and IsDeleted -eq $True} -IncludeDeletedObjects -properties IsDeleted,LastKnownParent | Format-List Name,IsDeleted,LastKnownParent,DistinguishedName

################### SW_default
$usersSW_default = Get-ADGroupMember -Identity SW_default
$usersSW_default.Length
$usersSW_default | select samaccountname | Export-Csv c:\temp\sw_default.csv -Encoding Unicode
$usersSW_default | %{$_.samaccountname}
###################

################### Default
$users_default = Get-ADGroupMember -Identity default
$users_default.Length
$users_default | select samaccountname | Export-Csv c:\temp\default.csv -Encoding Unicode
$users_default | %{$_.samaccountname}
###################

################### VIP
$userssw_vip = Get-ADGroupMember -Identity vip
$userssw_vip.Length
$userssw_vip | select samaccountname | Export-Csv c:\temp\vip.csv -Encoding Unicode
$userssw_vip  | %{$_.samaccountname}
###################

################### block
$usersblock = Get-ADGroupMember -Identity block
$usersblock.Length
$usersblock | select samaccountname | Export-Csv c:\temp\block.csv -Encoding Unicode
$usersblock  | %{$_.samaccountname}
###################

foreach($user in $usersSW_default)
{
    $user.SamAccountName
    Add-ADGroupMember -Identity default -Members $user.SamAccountName
} 

################### SW_VIP_*
$users_sw_vip = @()
$groups = Get-ADGroup -Filter {name -like "sw_vip_*"}
$groups.Length
foreach($group in $groups )
{
    $group.name
    $tmpname = $group.name
    (Get-ADGroupMember -Identity $tmpname).count
    $memberstmp = Get-ADGroupMember -Identity $tmpname
    foreach($user in $memberstmp)
    {
        $user.SamAccountName
        $users_sw_vip += $user.SamAccountName
    } 
    $memberstmp | select samaccountname | Export-Csv "c:\temp\$tmpname.csv" -Encoding Unicode
    
} 
$users_sw_vip.Length
foreach($user in $users_sw_vip)
{
    $user
    Add-ADGroupMember -Identity vip -Members $user
} 
##################################

################### SW_BLOCK*
$users_sw_block = @()
$groups = Get-ADGroup -Filter {name -like "sw_block_*"}
$groups.Length
foreach($group in $groups )
{
    $group.SamAccountName
    $tmpname = $group.SamAccountName
    (Get-ADGroupMember -identity $tmpname).count
    $memberstmp = Get-ADGroupMember -Identity $tmpname
    foreach($user in $memberstmp)
    {
        $user.SamAccountName
        $users_sw_block += $user.SamAccountName
    } 
    $memberstmp | select samaccountname | Export-Csv "c:\temp\$tmpname.csv" -Encoding Unicode
    
} 
$users_sw_block.Length
foreach($user in $users_sw_block)
{
    $user
    Add-ADGroupMember -Identity block -Members $user
} 
##################################





