$pathbenterreo = "OU=terreo,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben2andar = "OU=2_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben3andar = "OU=3_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathben4andar = "OU=4_Andar,OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"

$pathbarterreo = "OU=TERREO,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar1andar = "OU=1_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar2andar = "OU=2_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathbar3andar = "OU=3_andar,OU=_Barra,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"

$pathpdo7andar = "OU=7_ANDAR,OU=_centro,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathpdo8andar = "OU=8_ANDAR,OU=_centro,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathpdo9andar = "OU=9_ANDAR,OU=_centro,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathpdo10andar = "OU=10_ANDAR,OU=_centro,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$pathpdo11andar = "OU=11_ANDAR,OU=_centro,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"

$accounts = Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathbarterreo -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathbar1andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathbar2andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathbar3andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname

$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathbenterreo -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathben2andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathben3andar -SearchScope Subtree | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathben4andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname

$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathpdo7andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathpdo8andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathpdo9andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathpdo10andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname
$accounts += Get-ADComputer -filter {Name -like "*"} -Properties * -SearchBase $pathpdo11andar -SearchScope OneLevel | select name, ipv4address, canonicalname,lastlogondate,distinguishedname

$accounts.Length
$pcsmatch = @()
$pcsnomatch = @()
$pcsOUEspecial =@()
foreach($account in $accounts)
{
    if($account.ipv4address)
    {
        if(($account.canonicalname -notlike "*bloqueio*") -and ($account.canonicalname -notlike "*netbios*") -and ($account.canonicalname -notlike "*empreendimentos*"))
        {
        $ipv4=$account.ipv4address.ToString()

        ############ Benfica
        if(($ipv4 -like "10.101.10.*") -and ($account.canonicalname -notlike "*_benfica/terreo*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }        
        if(($ipv4 -like "10.101.11.*") -and ($account.canonicalname -notlike "*_benfica/2_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if(($ipv4 -like "10.101.12.*") -and ($account.canonicalname -notlike "*_benfica/3_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if(($ipv4 -like "10.101.13.*") -and ($account.canonicalname -notlike "*_benfica/4_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        
        ####### Barra
        if((($ipv4 -like "10.200.13.*") -or ($ipv4 -like "10.200.23.*") -or ($ipv4 -like "10.200.33.*")) -and ($account.canonicalname -notlike "*_Barra/3_ANDAR*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if((($ipv4 -like "10.200.12.*") -or ($ipv4 -like "10.200.22.*") -or ($ipv4 -like "10.200.32.*")) -and ($account.canonicalname -notlike "*_Barra/2_ANDAR*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if((($ipv4 -like "10.200.11.*") -or ($ipv4 -like "10.200.21.*") -or ($ipv4 -like "10.200.31.*")) -and ($account.canonicalname -notlike "*_Barra/1_ANDAR*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if((($ipv4 -like "10.200.10.*") -or ($ipv4 -like "10.200.20.*") -or ($ipv4 -like "10.200.30.*")) -and ($account.canonicalname -notlike "*_Barra/TERREO*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }

        ############ PDO
        if((($ipv4 -like "10.250.7.*"))-and ($account.canonicalname -notlike "*_centro/7_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }
        if((($ipv4 -like "10.250.8.*"))-and ($account.canonicalname -notlike "*_centro/8_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }

        if((($ipv4 -like "10.250.9.*"))-and ($account.canonicalname -notlike "*_centro/9_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }

        if((($ipv4 -like "10.250.10.*"))-and ($account.canonicalname -notlike "*_centro/10_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }

        if((($ipv4 -like "10.250.11.*"))-and ($account.canonicalname -notlike "*_centro/11_andar*"))
        {
            $pcsmatch  += $account
        }else
        {
            $pcsnomatch += $account
        }



        }else{$pcsOUEspecial += $account}
    }    
}
$pcsmatch  | ft -AutoSize
$pcsmatch.Length

$pcsmatch | Export-Csv c:\temp\movepcaccount.csv -Encoding Unicode

$pcsOUEspecial | ft -AutoSize
$pcsOUEspecial.Length

# move para as respectivas OU de acordo com o IP
foreach($pc in $pcsmatch)
{
    if($pc.ipv4address)
    {
        $ipv4=$pc.ipv4address.ToString()
        
        ############### benfica
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
        
        
        
        
        if($ipv4 -like "10.250.7*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathpdo7andar
        }
        if($ipv4 -like "10.250.8*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathpdo8andar
        }
        if($ipv4 -like "10.250.9*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathpdo9andar
        }
        if($ipv4 -like "10.250.10*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathpdo10andar
        }
        if($ipv4 -like "10.250.11*")
        {
            Move-ADObject -Identity $pc.distinguishedname -TargetPath $pathpdo11andar
        }

    }
}

#verifica movidos
$pcsmatch | %{Get-ADComputer -Identity $_.name -Properties * | select ipv4address,distinguishedname}
