Import-Module ActiveDirectory

$folders = Get-childItem -Path e:\ | ?{($_.name -ne "FilesServer$") -and ($_.name -ne "Users")}

foreach($folder in $folders)
{
    $path = $folder.FullName
    $share = $folder.Name
    $tmpAdm = ("_adm"+$folder.name) -replace "\$",""
    $tmpUser= ("_User"+$folder.name) -replace "\$",""
    $samAdm = "UNIMEDRJ\"+(Get-ADGroup -Filter {name -eq $tmpAdm}).samaccountname
    $samUser= "UNIMEDRJ\"+(Get-ADGroup -Filter {name -eq $tmpUser}).samaccountname
    New-FSRMQuota -Path $path -Template "Limite de 10 GB"
    Add-NTFSAccess -Path $path -AccessRights Modify -Account $samAdm
    Add-NTFSAccess -Path $path -AccessRights Read -Account $samUser
    Add-NTFSAccess -Path $path -AccessRights FullControl -Account "UNIMEDRJ\domain admins"
    try{Set-NTFSInheritance -Path $path -AccessInheritanceEnabled $false -ErrorAction SilentlyContinue}catch{}
    New-SmbShare –Name $share –Path $path -ChangeAccess $samAdm,"UNIMEDRJ\domain admins" -ReadAccess $samUser
}

Get-SmbShare
