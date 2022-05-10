Import-Module ActiveDirectory

Function get-Inheritance { 
    param($ObjectPath) 
    $ACL = Get-ACL -path "AD:\$ObjectPath" 
    If ($acl.AreAccessRulesProtected){ 
    Write-Host "Herança não habilitada para o objeto:" $ObjectPath   
    } else { Write-Host "Herança habilitada para o objeto:" $ObjectPath }
     
} 

function set-acl_SCSM_SA {
param($ObjectPath)

$acl = Get-ACL -path "AD:\$ObjectPath"
#$acl.access #to get access right of the OU
$userSCSM = get-aduser -Identity scsm_sa -Properties *
$sid = [System.Security.Principal.SecurityIdentifier] $userSCSM.SID
# Create a new access control entry to allow access to the OU
$identity = [System.Security.Principal.IdentityReference] $SID
$adRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
$type = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,$type,$inheritanceType
# Add the ACE to the ACL, then set the ACL to save the changes
$acl.AddAccessRule($ace)
set-acl -aclobject $acl -path "AD:\$ObjectPath" 

}

Function Set-Inheritance { 
    param($ObjectPath) 
    $ACL = Get-ACL -path "AD:\$ObjectPath" 
    If ($acl.AreAccessRulesProtected){ 
         $ACL.SetAccessRuleProtection($False, $True) 
        Set-ACL -AclObject $ACL -path "AD:\$ObjectPath" 
        Write-Host "Herança aplicada para: "$ObjectPath 
    } 
} 

#OU=Área de Tecnologia de Informação,OU=_barra,

$userSemHeranca = @()
$users = get-aduser -Properties nTSecurityDescriptor -SearchBase "OU=Área de Tecnologia de Informação,OU=_barra,DC=unimedrj,DC=root" -Filter {(samaccountname -like "*")} 
foreach ($user in $users)
{
    

    if($user.SamAccountName.Length -gt 3)
    {
    if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[0-9]")
    {
        if($user.nTSecurityDescriptor.AreAccessRulesProtected)
        {
            $user | select name, samaccountname
             $userSemHeranca +=$user
        }
    } else
    {
        if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[0-9]")
        { 
            if($user.nTSecurityDescriptor.AreAccessRulesProtected)
            {
                $user | select name, samaccountname
                $userSemHeranca +=$user
            }
        } else
        {
            if($user.SamAccountName.Substring(0,1) -match "[a-z]" -and $user.SamAccountName.Substring(1,1) -match "[a-z]" -and $user.SamAccountName.Substring(2,1) -match "[a-z]" -and $user.SamAccountName.Substring(3,1) -match "[0-9]")
            {            
                if($user.nTSecurityDescriptor.AreAccessRulesProtected)
                {
                    $user | select name, samaccountname
                    $userSemHeranca +=$user
                }
            } 
        }
    }
    }
    


}
$userSemHeranca.Length

$userSemHeranca  | foreach {Set-Inheritance $_.distinguishedname}

$usrtmp = get-aduser -Identity m30331 -Properties distinguishedname
get-Inheritance $usrtmp.distinguishedname

$usrtmp = get-aduser -Identity adm41718 -Properties distinguishedname
set-Inheritance $usrtmp.distinguishedname


Get-ADUser -LDAPFilter “(objectcategory=person)(samaccountname=*)(admincount=1)” | select samaccountname,name