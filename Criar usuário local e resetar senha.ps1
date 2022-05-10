#############CRIAR USUÁRIO#################

$servers = Get-Content -Path C:\temp\servers.txt
$users = 'unimedrj\testelocal'
$password = 'Unimed#01'
$desc = 'Automatically created local admin account'
$saida = $null

foreach ($server in $servers)
{ 
    $comp = [ADSI]"WinNT://$server,computer"
    $user = $comp.create("user",$users)
    if ($comp)
    {
    $user.SetPassword($password)
    $user.Setinfo()
    $user.description = $desc
    $user.setinfo()
    $user.UserFlags = 65536
    $user.SetInfo()
    $group = [ADSI]("WinNT://$server/administrators,group")
    $group.add($user.Path)

    Write-Host $comp.Name $user.FullName
    #$saida += "`n" +$comp.Name + "`t"+ $user.FullName + "`n"
   }
}

Set-Content -Path C:\temp\userlocal.txt -Value $saida


####################RESETAR SENHA#######################################


$computers = Get-Content -Path C:\temp\servers.txt
$users = 'testelocal'

foreach ($computer in $computers)

{
([adsi]"WinNT://$computer/$users,user").setPassword("P@ssw0rd")
}


######################REMOVER USUÁRIO LOCAL#############################

$servers = Get-Content -Path C:\temp\servers.txt
$users = 'testelocal'

foreach ($server in $servers)
{

$comp = [ADSI]"WinNT://$server,computer"
$user = $comp.delete("user",$users)


}

#####################Desabilitar Usuário####################


$servers = Get-Content -Path C:\temp\servers.txt
$users = 'testelocal'

foreach ($server in $servers)
{

$user = [ADSI]"WinNT://$server/$users,User"

$user.UserFlags = 2
$user.SetInfo()

}


#####################Habilitar Usuário####################


$servers = Get-Content -Path C:\temp\servers.txt
$users = 'testelocal'

foreach ($server in $servers)
{


$user = [ADSI]"WinNT://$server/$users,User"
$user.UserFlags = 512
$user.SetInfo()

}


###################Adicionar Usuário do dominio no grupo local#############

$Domain = "unimedrj"
$servers = Get-Content -Path C:\temp\servers.txt
$Username = "testelocal"


foreach ($server in $servers)

{

if ($server)
{
# Bind to the local Administrators group on the computer.
$Group = [ADSI]"WinNT://$server/Administrators,group"


# Bind to the domain user.
$User = [ADSI]"WinNT://$Domain/$Username,user"

# Add the domain user to the group.
$Group.Add($User.Path)

Write-Host $server $group.Name "-" $user.FullName

}

}

######################REMOVER USUÁRIO DOMÍNIO#############################

$Domain = "unimedrj"
$servers = Get-Content -Path C:\temp\servers.txt
$users = 'testelocal'
foreach ($server in $servers)

{

if ($server)
{
# Bind to the local Administrators group on the computer.
$Group = [ADSI]"WinNT://$server/Administrators,group"


# Bind to the domain user.
$User = [ADSI]"WinNT://$Domain/$Username,user"

# Add the domain user to the group.

$Group.remove($User.Path)

Write-Host $server $group.Name "-" $user.FullName

}

}