$users = Get-ADUser -Filter 'Enabled -eq $true' -Properties * |?{$_.lastlogondate -lt (Get-Date).adddays(-35)}
$users = Get-ADUser -Filter 'Enabled -eq $true' -Properties * -server adsrv33.uremh.local |?{$_.lastlogondate -lt (Get-Date).adddays(-35)}
$users.Count
#padroes de login na Cooperativa e na Urehm
$pattern = @("^h[0-9]","^m[0-9]","^adm[0-9]","^tr[0-9]","^ja[0-9]","^c[0-9]","^e[0-9]","^h[0-9]","^pj[0-9]","^t[0-9]","^medico[0-9]","^uniemp[0-9]")

$pattern = @("^h[0-9]")

$usersFiltered = @()
foreach($user in $users)
{
    if($user.SamAccountName | Select-String -Pattern $pattern)
    {
        
        if(!(($user.CanonicalName -like "*Desabilitados*") -or ($user.CanonicalName -like "*Afastados*")  -or ($user.lastlogondate -eq $null)))
        {
            #$user.SamAccountName
            $usersFiltered += $user
        }
    }
    else
    {
        #Write-Host fora do padrão de login $user.SamAccountName -ForegroundColor Red
    }
} 
$usersFiltered.Count
$usersFiltered | select name, samaccountname, enabled, lastlogondate | export-csv C:\Temp\naologa35dias.csv -Encoding Unicode


($usersFiltered | ?{$_.samaccountname -like  "tr*"}).count |select name, samaccountname, enabled, lastlogondate 

