$password = convertto-securestring "@cessoUnimed01" -asplaintext -force
New-ADUser -Name "Oracle Grid Windows" -GivenName "Oracle Grid" -Surname "Windows" -SamAccountName orlgridwin -AccountPassword $password -PasswordNeverExpires $true `
-Path "OU=Contas Novo Sistema,OU=Área de Tecnologia de Informação,OU=_Barra,DC=unimedrj,DC=root" -UserPrincipalName "orlgridwin@unimedrj.root" -PassThru | Enable-ADAccount
Add-ADGroupMember -Identity _vpnunimed -Members orlgridwin
Add-ADGroupMember -Identity _SysAccounts -Members orlgridwin
Add-ADGroupMember -Identity "Account Operators" -Members orlgridwin
Add-ADGroupMember -Identity "Domain Admins" -Members orlgridwin




