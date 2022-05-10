Import-module C:\powershell\UnimedrioWorkplaceFunctions.ps1



$users = UnimedWorkplace-GetAllUsersV2
$users | ?{$_.active -eq $true -and $_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited -eq $false} | ft @{Label="name";Expression={$_.name.formatted}}, username, active,@{Label="Invited";Expression={$_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited}}

$unimedrio = $users | ?{$_.username -like "*tos.com.br" -and $_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited -eq $false} | ft @{Label="name";Expression={$_.name.formatted}}, username, active,@{Label="Invited";Expression={$_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited}}
$unimedrio.count

foreach($u in $unimedrio)
{
    $tmp = $u.userName
    $userad = Get-ADUser -Filter {mail -eq $tmp} -Properties mail -Server adsrv33.uremh.local

    if($userad.DistinguishedName -like "*demitido*" -and $userad.Enabled -eq $false)
    {
        "Demitido: " + $userad.DistinguishedName
    }else
    {
        if( $userad.Enabled -eq $true)
        {
            "Ativo: " + $userad.DistinguishedName
        }else
        {
            #"Desatvidado: " +$u.name
        }
    }
}