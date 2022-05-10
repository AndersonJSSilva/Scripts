$usersrm = Get-Content C:\temp\usersRMMat.txt
$usersrm.count
$usersfound = @()
foreach($rm in $usersrm)
{    
        if($rm.StartsWith("E"))
        {
            $rm = $rm -replace "E",""
            $rm = "e" + $rm.TrimStart('0')

            try{$usersfound += get-aduser -Identity $rm -Properties *
               #write-host Found $rm -ForegroundColor Green
            }catch{write-host Not found $rm -ForegroundColor Yellow}


        }else
        {
            if($rm.StartsWith("02"))
            {
                $rm = "est"+$rm.TrimStart('0')
                try{$usersfound += get-aduser -Identity $rm -Properties *
                #write-host Found $rm -ForegroundColor Green
                }catch{
                    
                    $rm = $rm.TrimStart('est2')  
                    $rm = "est"+$rm.TrimStart('0')     
                    try{$usersfound += get-aduser -Identity $rm -Properties *
                    #write-host Found $rm -ForegroundColor Green
                    }catch{write-host Not found $rm -ForegroundColor Yellow}
                
                }
            }
            else
            {
                    $rm = "m" + $rm.TrimStart('0')
                    try{$usersfound += get-aduser -Identity $rm -Properties *
                    #write-host Found $rm -ForegroundColor Green
                    }catch{
                    
                    $rm = $rm.TrimStart('m')  
                    $rm = "ja"+$rm.TrimStart('0')     
                    try{$usersfound += get-aduser -Identity $rm -Properties *
                    #write-host Found $rm -ForegroundColor Green
                    }catch{
                    $rm = $rm.TrimStart("ja")
                    write-host Not found $rm -ForegroundColor Yellow}

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
        try{Add-ADGroupMember -Identity WorkplaceUsers -Members $user -ErrorAction Continue}
        catch [Exception]{Write-host $user.SamAccountName $_.Exception.Message -ForegroundColor Red}
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