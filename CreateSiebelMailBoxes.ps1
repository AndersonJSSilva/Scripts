Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin
$password = Read-Host "Digite a senha:" -AsSecureString

<#

PRD -> #s13B3l@ccounT%
TST -> SiebelTs#01
DEV -> Unimed#08
HMG ->
TRT ->

#>


$logins = import-csv '\\10.200.5.57\c$\temp\emailsibtrt.csv'
$logins.Count
foreach($lgn in $logins)
{
$alias = $lgn.samaccountname
$description = $lgn.description
$SamAccountName = $lgn.samaccountname
if($lgn.name -eq "SAC")
{
    $displayname = $lgn.name +" - "+$lgn.lastname
}else{
$displayname = $lgn.name +" "+$lgn.lastname
}
$principalName = $alias + '@unimedrj.root'
$emailtoremove = ($lgn.name+"."+$lgn.lastname+"@unimedrio.com.br") -replace " ",""
$email = $lgn.smtpaddress

Write-host Alias: $alias
Write-host Description: $description
Write-host samaccountname: $SamAccountName
Write-host displayname: $displayname
Write-host principalname: $principalName
Write-host email: $email
Write-host

#New-Mailbox -Name $displayname -Alias $alias -OrganizationalUnit 'unimedrj.root/_Barra/Área de Tecnologia de Informação/Contas Novo Sistema' -UserPrincipalName $principalName -SamAccountName $SamAccountName -FirstName $lgn.name -lastname $lgn.lastname -displayname $displayname -ResetPasswordOnNextLogon $false -Database '50Mb_2013' -Password $password


<#Set-Mailbox -Identity $alias -EmailAddressPolicyEnabled $false
Set-Mailbox -Identity $alias -PrimarySmtpAddress $email
Set-Mailbox -Identity $alias -HiddenFromAddressListsEnabled $true#>

$user = Get-Mailbox $alias 
$user.emailAddresses-=$emailtoremove 
Set-Mailbox $user -emailAddresses $user.emailAddresses

}

foreach($lgn in $logins)
{
   
    $user = Get-ADuser -Identity $lgn.samaccountname
    set-aduser -Identity $lgn.samaccountname -PasswordNeverExpires $true -Description $lgn.description
    #Set-ADAccountPassword -Identity $lgn.samaccountname -NewPassword $Password -Reset
    Add-ADGroupMember -Identity _Sysaccounts -Members $user

}

foreach($lgn in $logins)
{
   
    Get-ADuser -Identity $lgn.samaccountname -Properties *| select samaccountname, *emailaddress*, displayname, description
    
}

Get-ADuser -filter{description -like "Siebel*"} -Properties *| select samaccountname, *emailaddress*, displayname, description | Sort-Object samaccountname

Get-MailboxStatistics -identity proconcariocahmg




