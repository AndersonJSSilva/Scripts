param($Identity,$Path);
#
# Import a JPEG file into Active Directory for use as the Exchange / Outlook GAL Photo
# Best results - Under 10K, 96 x 96
#
#usage -> .\Import-Picture.ps1 -Identity m41718 -Path c:\capturar.jpg
# 
# Steve Goodman
if (!$Identity)
{
    throw "Identity Missing";
}
if (!$Path)
{
    throw "Path Missing";
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
if (!(Test-Path -Path $Path))
{
    throw "File $($Path) not found";
}
$FileData = [Byte[]]$(Get-Content -Path $Path -Encoding Byte -ReadCount 0);
if($FileData.Count -gt 10240)
{
    throw "File size must be less than 10K";
}
$adsiUser = [ADSI]"LDAP://$($User.OriginatingServer)/$($User.DistinguishedName)";
$adsiUser.Put("thumbnailPhoto",$FileData);
$adsiUser.SetInfo()