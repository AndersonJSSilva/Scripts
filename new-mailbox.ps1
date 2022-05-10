$name = "Planejamento Desenvolvimento"+" - DSV"
$aliasaccount = "plandesenv"+"dsv"
$userPrincipalName = $aliasaccount+"@unimedrj.root"
$samacountname = $aliasaccount
$fisrtname = "Planej"
$lastname = "Desenvolvimento"+" DSV"
$ou = "unimedrj.root/_Barra/Área de Tecnologia de Informação/Contas Novo Sistema"
$database = "EXCBOXPRD\Usuarios_M-Z\Usuarios_M-Z"
New-Mailbox -Name $name -Alias $aliasaccount -OrganizationalUnit $ou -UserPrincipalName $userPrincipalName -SamAccountName $samacountname -FirstName $fisrtname -Initials '' -LastName $lastname -Password $password -ResetPasswordOnNextLogon $false -Database $database

Planej.desenvimento@unimedrio.com.br
Planej.desenvimentohmg@unimedrio.com.br
Planej.desenvimentodsv@unimedrio.com.br

get-mailbox -server excboxprd -SortBy alias -ResultSize unlimited | where-object {$_.samaccountname -like "plan*"} | Format-Table -property name,samaccountname,PrimarySmtpAddress