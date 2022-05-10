function Get-DistinguishedName {
#Param($UserName)
   $ads = New-Object System.DirectoryServices.DirectorySearcher([ADSI]'')
   $ads.filter = "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=65536))"
   $s = $ads.FindAll()
   return $s.GetDirectoryEntry().DistinguishedName
}
 
Get-DistinguishedName #$usuario


