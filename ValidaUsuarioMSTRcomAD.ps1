
$usermstr = Get-Content C:\temp\usersMSTR.txt

foreach($user in $usermstr)
{


    $usr = Get-ADUser -Filter {samaccountname -eq $user} | select samaccountname, name
    if($usr)
    {
         Write-Host $usr.samaccountname -ForegroundColor Green
    }
    else
    {
        $usr = Get-ADUser -Filter {samaccountname -eq $user} -server adsrv33.uremh.local | select samaccountname, name
        if($usr)
        {
            Write-Host $usr.samaccountname -ForegroundColor Green          
        }else{

            Write-Host $user -ForegroundColor Red
        }
    }


}