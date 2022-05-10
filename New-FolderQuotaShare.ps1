Import-Module NTFSSecurity

$user = "m41718"
$share = $user+"$"
$domainUser = "unimedrj\$user"
$path = "E:\users\"+$share

New-Item -ItemType Directory -Path $path
New-FSRMQuota -Path $path -Template "Limite de 100 MB"
Add-NTFSAccess -Path $path -AccessRights Modify -Account $domainUser
Add-NTFSAccess -Path $path -AccessRights FullControl -Account "UNIMEDRJ\domain admins"
try{Set-NTFSInheritance -Path $path -AccessInheritanceEnabled $false -ErrorAction SilentlyContinue}catch{}
New-SmbShare –Name $share –Path $path -ChangeAccess $domainUser,"UNIMEDRJ\domain admins"

<#

Get-NTFSInheritance -Path $path
Get-NTFSAccess -Path $path
Remove-SmbShare -Name $share
Remove-FsrmQuota -Path $path -Confirm:$false
Remove-Item -Path $path -Recurse -Force

#>