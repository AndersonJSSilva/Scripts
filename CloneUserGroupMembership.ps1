$de = "m46027"
$para = "m77526"

$grupos = (get-aduser -Identity $de -Properties *).MemberOf
foreach ($gpr in $grupos )
{
    Add-ADGroupMember -Identity $gpr -Members $para
}

#(get-aduser -Identity $para -Properties *).MemberOf
#(Get-ADGroup "_Admins Locais de estações autorizados" -Properties *).members


