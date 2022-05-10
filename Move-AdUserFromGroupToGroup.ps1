function Move-ADGroupMembers{
    Param(            
        [string]$de,            
        [string]$para         
        ) 
$members = Get-ADGroupMember -Identity $de
Add-ADGroupMember -Members $members -identity $para
}

Move-ADGroupMembers -de "_aplicativosbarra" -para "_admaplicativos"