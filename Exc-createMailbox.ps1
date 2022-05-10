Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$password = Read-Host "Digite a senha:" -AsSecureString
#s13B3l@ccounT%

$name = 'SAC'
$lastname = ' - Guia - HMG'
$alias = $name + $lastname
$alias = ($alias -replace " - ","").tolower()
$description = "Siebel"
$SamAccountName = "sacguiahmg"
$displayname = $name + "" + $lastname
$principalName = $alias + '@unimedrj.root'
$emailtoremove = ($name+"."+$lastname+"@unimedrio.com.br") -replace " ",""
$email = $alias +"@unimedrio.com.br"

New-Mailbox -Name $displayname -Alias $alias -OrganizationalUnit 'unimedrj.root/_Barra/¡rea de Tecnologia de InformaÁ„o/Contas Novo Sistema' -UserPrincipalName $principalName -SamAccountName $SamAccountName -FirstName $name -lastname $lastname -displayname $displayname -ResetPasswordOnNextLogon $false -Database 'EXCBOXPRD\50Mb\50Mb' -Password $password

Set-Mailbox -Identity $alias -EmailAddressPolicyEnabled $false
Set-Mailbox -Identity $alias -PrimarySmtpAddress $email

$user = Get-Mailbox $alias 
$user.emailAddresses-=$emailtoremove 
Set-Mailbox $user -emailAddresses $user.emailAddresses


get-mailbox -Identity $alias | select *address*

###############################################################################################################

Add-MailboxPermission tr2176 -User administrator -AccessRights FullAccess
Export-Mailbox -Identity tr2176 -PSTFolderPath c:\pst\ -StartDate "09/21/2013 12:01:00" -EndDate "09/21/2013 23:59:00"
Remove-MailboxPermission -Identity tr2176 -User administrator -AccessRight FullAccess -confirm:$false

###############################################################################################################

#####criar contato
New-MailContact -ExternalEmailAddress 'SMTP:_Carga_DW@unimedrio.com.br' -Name '_Carga_DW' -Alias '_Carga_DW' -OrganizationalUnit 'unimedrj.root/_Barra/Contatos' -FirstName '_Carga_DW' -Initials '' -LastName ''

####criar grupo de distribui√ß√£o
New-DistributionGroup -Name "_Grupodedistribuicao" -OrganizationalUnit 'unimedrj.root/_Barra/Grupo de Seguran√ßa e Distribui√ß√£o' -SAMAccountName "_Grupodedistribuicao" -Type "Distribution"

atualizacadastrowf@unimedrio.com.br
atualizacadastrowfhmg@unimedrio.com.br
atualizacadastrowfdsv@unimedrio.com.br
sacguia@unimedrio.com.br
sacguiahmg@unimedrio.com.br
sacguiadsv@unimedrio.com.br

get-mailbox -Identity sacguia

