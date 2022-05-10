<#
.Synopsis
   Sets manager property on AD group and grants change membership rights.
.DESCRIPTION
   Sets manager property on AD group and grants change membership rights.
   This is done by manipulating properties directly on the DirectoryEntry object
   obtained with ADSI. This sets the managedBy property and adds an ACE to the DACL
   allowing said manager to modify group membership.
.EXAMPLE
   Set-GroupManager -ManagerDN "CN=some manager,OU=All Users,DC=Initech,DC=com" -GroupDN "CN=TPS Reports Dir,OU=All Groups,DC=Initech,DC=com"
.EXAMPLE
   (Get-AdGroup -Filter {Name -like "sharehost - *"}).DistinguishedName | % {Set-GroupManager "CN=some manager,OU=All Users,DC=Initech,DC=com" $_}
#>
function Set-GroupManager {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$false, ValueFromPipelinebyPropertyName=$True, Position=0)]
        [string]$ManagerDN,
        [Parameter(Mandatory=$true, ValueFromPipeline=$false, ValueFromPipelinebyPropertyName=$True, Position=1)]
        [string]$GroupDN
        )
    
    try {
        Import-Module ActiveDirectory -NoClobber
 
        $mgr = [ADSI]"LDAP://$ManagerDN";
        $identityRef = (Get-ADUser -Filter {DistinguishedName -like $ManagerDN}).SID.Value
        $sid = New-Object System.Security.Principal.SecurityIdentifier ($identityRef);
 
        $adRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule ($sid, `
                    [System.DirectoryServices.ActiveDirectoryRights]::WriteProperty, `
                    [System.Security.AccessControl.AccessControlType]::Allow, `
                    [Guid]"bf9679c0-0de6-11d0-a285-00aa003049e2");
 
        $grp = [ADSI]"LDAP://$GroupDN";
 
        $grp.InvokeSet("managedBy", @("$ManagerDN"));
        $grp.CommitChanges();
 
        # Taken from here: http://blogs.msdn.com/b/dsadsi/archive/2013/07/09/setting-active-directory-object-permissions-using-powershell-and-system-directoryservices.aspx
        [System.DirectoryServices.DirectoryEntryConfiguration]$SecOptions = $grp.get_Options();
        $SecOptions.SecurityMasks = [System.DirectoryServices.SecurityMasks]'Dacl'
                
        $grp.get_ObjectSecurity().AddAccessRule($adRule);
        $grp.CommitChanges();
    }
    catch {
        throw
    }
}