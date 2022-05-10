$NewUser = "opmon"
$NewUserPassword = "#Un1m3dMon"
$NewUserDesc = "Opmon User"
$HOSTCredentials = Get-Credential -Credential root
$ESXhost = 'esxiprd18.unimedrj.root'
 
Connect-VIServer $ESXhost -Credential $HOSTCredentials
New-VMHostAccount -Id $NewUser -Password $NewUserPassword -Description $NewUserDesc -UserAccount -GrantShellAccess
$AuthMgr = Get-View (Get-View ServiceInstance).Content.AuthorizationManager
$Entity = Get-Folder ha-folder-root | Get-View
$Perm = New-Object VMware.Vim.Permission
$Perm.entity = $Entity.MoRef
$Perm.group = $false
$Perm.principal = $NewUser
$Perm.propagate = $true
# You can either specify roleID or use the line below if you know the role name.
# $Perm.roleId = ($AuthMgr.RoleList | where {$_.Name -eq "ReadOnly"}).RoleId
$Perm.roleId = "-2"
$AuthMgr.SetEntityPermissions($Entity.MoRef,$Perm)
 
Disconnect-VIServer -Server $ESXhost -Confirm:$false

get-VMHostAccount
