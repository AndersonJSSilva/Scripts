$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session
$password = Read-Host "Digite a senha:" -AsSecureString


$entrada = Import-Csv C:\temp\mailboxes.csv
foreach($mbx in $entrada)
{
$displayname = $mbx.nome
$principalName = $mbx.samaccountname + '@unimedrj.root'
New-Mailbox -shared -Name $displayname -OrganizationalUnit 'unimedrj.root/Contas Corporativas' -UserPrincipalName $principalName -displayname $displayname -ResetPasswordOnNextLogon $false -Database '50Mb_2013' -Password $password
}

foreach($mbx in $entrada)
{
$displayname = $mbx.nome
$login = $mbx.samaccountname
Add-MailboxPermission -Identity $login -User m50610 -AccessRights FullAccess -AutoMapping $true -InheritanceType All
}

foreach($mbx in $entrada)
{
$displayname = $mbx.nome
$login = $mbx.samaccountname
remove-MailboxPermission -Identity $login -User m50610 
}


foreach($mbx in $entrada)
{
    $displayname ="\"+ $mbx.nome
    Get-PublicFolder -Identity $displayname | Get-PublicFolderClientPermission |?{($_.user -notlike "NT:*") -and ($_.user -notlike "adm *") -and ($_.user -notlike "adm50*") -and ($_.user -notlike "default*") -and ($_.user -notlike "jean r*") -and ($_.user -notlike "Rogério P*") -and ($_.user -notlike "Anonym*")}| ft -AutoSize
}

