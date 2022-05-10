$manager = $user = $userdn = $null
$manager = Read-host  "matricula do gerente"
try{
    $user = Get-ADUser -identity $manager
    $userdn = ($user.DistinguishedName).tostring()
    Get-aduser -Filter {manager -eq $userdn} -Properties *| ft name, samaccountname, description
}catch{write-host Usuário nao localizado -ForegroundColor Red}
