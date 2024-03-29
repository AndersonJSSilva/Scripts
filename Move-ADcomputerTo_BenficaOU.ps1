﻿$pathbenterreo = "OU=terreo,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben2andar = "OU=2_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben3andar = "OU=3_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben4andar = "OU=4_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbarterreo = "OU=TERREO,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar1andar = "OU=1_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar2andar = "OU=2_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar3andar = "OU=3_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"

$accounts = Get-ADComputer -filter {Name -like "*"} -Properties * | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts.Length
$pcsmatch = @()
$pcsnomatch = @()
foreach($account in $accounts)
{
    if($account.ipv4address)
    {
        $ipv4=($account.ipv4address).toString()
        if(($ipv4 -like "10.101.[10-13]*") -and ($account.canonicalname -notlike "*benfica*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if((($ipv4 -like "10.200.1[0-3].*") -or ($ipv4 -like "10.200.2[0-3].*") -or ($ipv4 -like "10.200.3[0-3].*")) -and ($account.canonicalname -notlike "*barra*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
    }    
}
$pcsmatch  | ft -AutoSize
$pcsmatch.Length
#$pcsnomatch| ft -AutoSize
#$pcsnomatch.Length

# move para as respectivas OU de acordo com o IP
foreach($pc in $pcsmatch)
{
    if($pc.ipv4address)
    {
        $ipv4=($pc.ipv4address).toString()
        if($ipv4 -like "10.101.10*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathbenterreo
        }
        if($ipv4 -like "10.101.11*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathben2andar
        }
        if($ipv4 -like "10.101.12*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathben3andar
        }
        if($ipv4 -like "10.101.13*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathben4andar
        }
        if(($ipv4 -like "10.200.10.*") -or ($ipv4 -like "10.200.20.*") -or ($ipv4 -like "10.200.30.*") )
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathbarterreo
        }
        if(($ipv4 -like "10.200.11.*") -or ($ipv4 -like "10.200.21.*") -or ($ipv4 -like "10.200.31.*") )
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathbar1andar
        }
        if(($ipv4 -like "10.200.12.*") -or ($ipv4 -like "10.200.22.*") -or ($ipv4 -like "10.200.32.*") )
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathbar2andar
        }
        if(($ipv4 -like "10.200.13.*") -or ($ipv4 -like "10.200.23.*") -or ($ipv4 -like "10.200.33.*") )
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathbar3andar
        }
    }
}


#verifica movidos
$pcsmatch | %{Get-ADComputer -Identity $_.name -Properties * | select distinguishedname}
