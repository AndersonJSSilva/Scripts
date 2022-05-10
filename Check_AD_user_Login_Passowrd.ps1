Function Test-ADAuthentication {
    param($userlogin,$userpassword)
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null
}




if(Test-ADAuthentication 'sadmin' '$13b3ls3r@#')
{
    Write-Host "login e senha ok" -ForegroundColor Green
}
else
{
    Write-Host "login ou senha errada" -ForegroundColor Red
}

