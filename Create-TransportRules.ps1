Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

$firstName = Read-Host "FisrtName"
$lastname = Read-Host "LastName"
$name = $firstName+' '+$lastname+' - UREMH'
$alias = $firstName+$lastname
$extmail = 'SMTP:'+$firstName+'.'+$lastname+'@unimedrioempreendimentos.com.br'
$mailOperadora = $firstName+'.'+$lastname+'@unimedrio.com.br'
$trasportRuleName = 'Redirect'+' '+$firstName+' '+$lastname

New-MailContact -ExternalEmailAddress $extmail -Name $name -Alias $alias -OrganizationalUnit 'unimedrj.root/_Barra/Contatos' -FirstName $firstName -Initials '' -LastName $lastname

$condition = Get-TransportRulePredicate sentTo
$condition.Addresses = @(Get-mailContact $name)
$action = Get-TransportRuleAction RedirectMessage
$action.Addresses = @(Get-Mailbox $mailOperadora)
New-TransportRule -Name $trasportRuleName -Comments "" -Conditions @($condition) -Actions @($action) -Enabled $True -Priority 3

Set-MailContact -Identity $name -HiddenFromAddressListsEnabled $true