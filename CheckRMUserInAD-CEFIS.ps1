$usersrm = Get-Content C:\temp\usersRMMatcefis.txt
$usersrm.count
$usersfound = @()
foreach($rm in $usersrm)
{    
        if($rm.StartsWith("C"))
        {

            try{$usersfound += get-aduser -Identity $rm -Properties *
               #write-host Found $rm -ForegroundColor Green
            }catch{
            
             $rm = $rm -replace "C",""
                $rm = "c" + $rm.TrimStart('0')
                try{$usersfound += get-aduser -Identity $rm -Properties *
                #write-host Found $rm -ForegroundColor Green
                }catch{
                    
                    write-host not Found $rm -ForegroundColor red
                }            
            }
        }
}
$usersfound.Count


#usuários desativados
$usersfound |?{$_.enabled -eq $false} | ft name, samaccountname, mail, manager, enabled

#usuários sem email
$usersfound |?{$_.mail -eq $null} | ft name, samaccountname, mail, manager, enabled


(Get-ADGroupMember -Identity WorkplaceUsers).count

foreach($user in $usersfound)
{

    if($user.CanonicalName -notlike "*demitido*")
    {
        #try{Add-ADGroupMember -Identity WorkplaceUsers -Members $user -ErrorAction Continue}
        #catch [Exception]{Write-host $user.SamAccountName $_.Exception.Message -ForegroundColor Red}
    }else{
        Write-host $user.SamAccountName está na OU demitidos -ForegroundColor Red
    }
}


$patternsworkplace = @("workplace")
foreach($user in $usersfound)
{
    if($user.MemberOf| Select-String -Pattern $patternsworkplace)
    {
       # write-host está no grupo workplace

    }else{
        write-host $user.SamAccountName nao está no grupo workplace -ForegroundColor Red

    }

}