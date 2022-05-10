Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$password = Read-Host "Digite a senha:" -AsSecureString
#s13B3l@ccounT%

$name = 'SAC'
$lastname = 'Guia - HMG'
$alias = $name +' - '+ $lastname
$alias = ($alias -replace " - ","").tolower()
$description = "Siebel"
$SamAccountName = $alias
$displayname = $name + " - " + $lastname
$principalName = $alias + '@unimedrj.root'
$emailtoremove = ($name+"."+$lastname+"@unimedrio.com.br") -replace " ",""
$email = $alias +"@unimedrio.com.br"

New-Mailbox -Name $displayname -Alias $alias -OrganizationalUnit 'unimedrj.root/_Barra/¡rea de Tecnologia de InformaÁ„o/Contas Novo Sistema' -UserPrincipalName $principalName -SamAccountName $SamAccountName -FirstName $name -lastname $lastname -displayname $displayname -ResetPasswordOnNextLogon $false -Database 'EXCBOXPRD\50Mb\50Mb' -Password $password

Set-Mailbox -Identity $alias -EmailAddressPolicyEnabled $false
Set-Mailbox -Identity $alias -PrimarySmtpAddress $email
Set-Mailbox -Identity $alias -HiddenFromAddressListsEnabled $true

$user = Get-Mailbox $alias 
$user.emailAddresses-=$emailtoremove 
Set-Mailbox $user -emailAddresses $user.emailAddresses

get-mailbox -Identity $alias | select *address*


########################################################## remove smtp -= 
$user = Get-Mailbox m41718 
$user.emailAddresses-="carlos@unimedrio.com.br"
Set-Mailbox $user -emailAddresses $user.emailAddresses
Set-Mailbox -Identity m41718 -HiddenFromAddressListsEnabled $false


###############################################################################################################

Add-MailboxPermission tr2176 -User administrator -AccessRights FullAccess
Export-Mailbox -Identity tr2176 -PSTFolderPath c:\pst\ -StartDate "09/21/2013 12:01:00" -EndDate "09/21/2013 23:59:00"
Remove-MailboxPermission -Identity tr2176 -User administrator -AccessRight FullAccess -confirm:$false

###############################################################################################################

##### criar contato
New-MailContact -ExternalEmailAddress 'SMTP:_Carga_DW@unimedrio.com.br' -Name '_Carga_DW' -Alias '_Carga_DW' -OrganizationalUnit 'unimedrj.root/_Barra/Contatos' -FirstName '_Carga_DW' -Initials '' -LastName ''

##### criar grupo de distribuicao
New-DistributionGroup -Name "_Grupodedistribuicao" -OrganizationalUnit 'unimedrj.root/_Barra/Grupo de Seguran√ßa e Distribui√ß√£o' -SAMAccountName "_Grupodedistribuicao" -Type "Distribution"


###############################################################################################
$trclog = @()
$rcpt = "grazilima@ibest.com.br"
$startdate = "24/02/2015 00:00:00"
$enddate = "24/02/2015 23:59:00"
$trclog += get-messagetrackinglog -Sender $rcpt -Server "hubcasprd01" -Start $startdate -End $enddate | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -Sender $rcpt -Server "hubcasprd02" -Start $startdate -End $enddate | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -Sender $rcpt -Server "excboxprd" -Start $startdate -End $enddate | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt
###############################################################################################

###############################################################################################
$trclog = @()
$rcpt = ""
$startdate = "01/01/2015 00:00:00"
$enddate = "29/01/2015 23:59:00"
$trclog += get-messagetrackinglog -MessageSubject $rcpt -Server "hubcasprd01" -Start $startdate -End $enddate -ResultSize unlimited | select timestamp,source,eventid,sender,recipients,messagesubject,returnpath
$trclog += get-messagetrackinglog -MessageSubject $rcpt -Server "hubcasprd02" -Start $startdate -End $enddate -ResultSize unlimited | select timestamp,source,eventid,sender,recipients,messagesubject,returnpath
$trclog += get-messagetrackinglog -MessageSubject $rcpt -Server "excboxprd" -Start $startdate -End $enddate -ResultSize unlimited | select timestamp,source,eventid,sender,recipients,messagesubject,returnpath
$trclog | Out-GridView -Title $rcpt
###############################################################################################


New-MailContact -ExternalEmailAddress 'SMTP:alessandra.cabral@unimedrioempreendimentos.com.br' -Name 'Alessandra Cabral - UREMH' -Alias 'AlessandraCabral' -OrganizationalUnit 'unimedrj.root/_Barra/Contatos' -FirstName 'Alessandra' -Initials '' -LastName 'Cabral'

# create transport Rule
$condition = Get-TransportRulePredicate sentTo
$condition.Addresses = @(Get-Mailbox adm41718)
$action = Get-TransportRuleAction RedirectMessage
$action.Addresses = @(Get-Mailbox m41718)
New-TransportRule -Name "redirect ADM41718" -Comments "redirect ADM41718" -Conditions @($condition) -Actions @($action) -Enabled $True -Priority 10
######################################

get-TransportRule -Identity "Redirect Salomao"

Get-MailboxStatistics -Identity ouvelogio | select itemcount
Get-MailboxFolderStatistics ouvelogio -FolderScope Inbox | Select identity,FolderSize,ItemsinFolder

$mails =@("ouvreclreemb","ouvreclfinanc","ouvreclcadastro","ouvreclautoriz","ouvreclatend","ouvsugestao","ouvelogio")
foreach($mail in $mails)
{
    Get-MailboxFolderStatistics $mail -FolderScope Inbox | Select identity,ItemsinFolder
}

Get-Mailbox -ResultSize unlimited | Get-MailboxPermission -User m17892 | select  identity, user, accessrights

Get-mailbox -ResultSize unlimited | Remove-MailboxPermission -User m17892  -AccessRight FullAccess,DeleteItem,ReadPermission -confirm:$false -ErrorAction SilentlyContinue



Get-MailboxPermission -identity Cooperadoeletiva  | select  user, accessrights


