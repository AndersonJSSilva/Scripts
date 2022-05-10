Function Test-ADAuthentication {
    param($userlogin,$userpassword)
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null
}




if (Test-ADAuthentication "c24hteste" "unimed#01")
{
    Write-Host "login e senha ok" -ForegroundColor Green
}
else
{
    Write-Host "login ou senha errada" -ForegroundColor Red
}

dir \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\*.* | select -first 10
