param($Identity);
#
# Clear the GAL Picture attribute
# 
# Steve Goodman
if (!$Identity)
{
    throw "Identity Missing";
}
if (!(Get-Command Get-User))
{
    throw "Exchange Management Shell not loaded";
}
$User = Get-User $Identity -ErrorAction SilentlyContinue
if (!$User)
{
    throw "User $($Identity) not found";
}
$adsiUser = [ADSI]"LDAP://$($User.OriginatingServer)/$($User.DistinguishedName)";
$adsiUser.PutEx(1,"thumbnailPhoto",$null)
$adsiUser.SetInfo()