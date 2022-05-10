Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$password = Read-Host "Digite a senha:" -AsSecureString
#@ccounTSyS%

$name = 'Contas'
$lastname = 'a Receber - TRT'
$alias = $name + $lastname
$alias = ($alias -replace " ","").tolower()
$displayname = $name + " " + $lastname
$principalName = 'analiseconttrib@unimedrj.root'
$samaccountname = 'analiseconttrib'

New-Mailbox -Name $displayname -Alias $alias -OrganizationalUnit 'unimedrj.root/_Barra/Área de Tecnologia de Informação/Contas Novo Sistema' -UserPrincipalName $principalName -SamAccountName $samaccountname -FirstName $name -lastname $lastname -displayname $displayname -ResetPasswordOnNextLogon $false -Database 'EXCBOXPRD\50Mb\50Mb' -Password $password

pause
################################ Dá permissão full na conta para lista de usuários
$users = Get-Content C:\users.txt
foreach ($user in $users){
    Add-MailboxPermission -AccessRights FullAccess -Identity analisecontabiltributario -User $user
}

################################# lista usuários e permissões em uma caixa
Get-MailboxPermission -Identity analisecontabiltributario | ft user, AccessRights -AutoSize



$users = @()
$usersmailbox = Get-Mailbox -ResultSize unlimited
$usersmailbox.Length
foreach($mailbox in $usersmailbox)
{
    $users += Get-User -Identity $mailbox.alias |  select  samaccountname, name, firstname, lastname, displayname, title, company, department
}
$users.Length
$usersmailbox.Length
$users | Export-Csv "c:\temp\usuarios20141109.csv" -encoding "unicode"

$mailbox.alias

Get-User -Identity m41718 | select *

$users = @()
$users = Get-User -ResultSize unlimited |  select  SamAccountName,Company,Department,DisplayName,FirstName,HomePhone,Initials,LastName,Manager,MobilePhone,Notes,Office,Phone,RecipientType,Title,WindowsEmailAddress,Name,WhenChanged,WhenCreated
$users | Export-Csv "c:\temp\usuarios20141119-3.csv" -encoding "unicode"

#samaccountname, name, firstname, lastname, displayname, title, company, department


Get-User -Filter 'samaccountname -like "tr*"' -ResultSize 100

Get-Mailbox -ResultSize unlimited | ?{}

Get-Mailbox -ResultSize unlimited | Get-Mailboxpermission | ?{$_.user -eq "unimedrj\m17892"} | select identity


$dls = Get-DistributionGroup -ResultSize unlimited | select *
$dls | Export-Csv "c:\temp\DisLis20141122.csv" -encoding "unicode"


$g
$group = Get-Group -ResultSize unlimited | select *
$group | Export-Csv "c:\temp\groups20141122.csv" -encoding "unicode"

$grps = @("_admjurfin","_ureh_adm_jurfin","_ureh_user_jurfin","_user_jurfin")
foreach($g in $grps)
{

    $group | ?{$_.samaccountname -like '*g*'}

}

#GroupType,SamAccountName,OrganizationalUnit,DisplayName,EmailAddresses,PrimarySmtpAddress,RecipientType


$emails = Get-Content C:\temp\siebelhmg.txt
$result = @()
foreach($email in $emails)
{
    $result += Get-Mailbox -Identity $email | select samaccountname, windowsemailaddress
}
$result

$cnts = Get-Content C:\temp\emailsPRDHMG.txt
$cnts.Length
foreach($cnt in $cnts)
{
    
    #Set-ADUser -Identity $cnt -Description "Siebel HMG"
    #Get-ADUser -filter {samaccountname -eq $cnt} -Properties * | select samaccountname,emailaddress, description
    Get-Mailbox -Identity $cnt | sort Displayname | select displayname,samaccountname,PrimarySmtpAddress,CustomAttribute1
    #Set-Mailbox -Identity $cnt -CustomAttribute1 "Siebel HMG"

}

Get-ADUser -filter {samaccountname -like "SACEmpreend*"} -Properties * | select samaccountname,mail, description

Get-Mailbox -Filter {samaccountname -like "SACEmpreend*"} | select displayname,alias,samaccountname,PrimarySmtpAddress

Get-Mailbox -Identity SACEmpreenddev | select displayname,primarysmtpaddress,samaccountname, CustomAttribute1
Set-Mailbox -Identity SACEmpreenddev -CustomAttribute1 "Siebel DEV"

Get-ADUser -Identity "respostafacilitadortrt"

New-Mailbox -Name 'Contas a Receber - TRT' -Alias 'contasarecebertrt' -OrganizationalUnit 'unimedrj.root/_Barra/Área de Tecnologia de Informação/Contas Novo Sistema' -UserPrincipalName 'contasarecebertrt@unimedrj.root' -SamAccountName 'contasarecebertrt' -FirstName 'Contas' -Initials '' -LastName 'a Receber - TRT' -Password $password -ResetPasswordOnNextLogon $false -Database 'EXCBOXPRD\50Mb\50Mb'
$tmp = $null
$userneo = @()
$cnts = Get-Content C:\temp\samaccountMorto.txt
foreach($cnt in $cnts)
{
    
    try
    {
    
    $tmp = get-ADUser -Identity $cnt -Properties Department,title  #| select Samaccountname,name,title, Department
    $userneo += $tmp.Samaccountname+";"+$tmp.name+";"+$tmp.title+";"+$tmp.Department

    }catch
    {
        $userneo += $cnt+";"+"não encontrado"
    }


}
$userneo | Set-Content C:\temp\outputMorto2.csv

Set-Content c:\temp\outputMorto.csv $userneo

$password = Read-Host "Digite a senha:" -AsSecureString
$cnts = Get-Content C:\temp\samaccount.txt
foreach($cnt in $cnts)
{
    Set-ADAccountPassword -Identity $cnt -Reset -NewPassword $password
}

Get-ADUser -filter {enabled -eq $false} | select samaccountname, name

Function Test-ADCredentials {
	Param($username, $password, $domain)
	Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	$ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
	$pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ct, $domain)
	New-Object PSObject -Property @{
		UserName = $username;
		IsValid = $pc.ValidateCredentials($username, $password).ToString()
	}
}

$cnts = Get-Content C:\temp\samaccount.txt
foreach($cnt in $cnts)
{
    Test-ADCredentials $cnt "Unimed#09" "unimedrj"
}

$siebeltrt = get-aduser -Filter {description -like "Siebel*"} -Properties Name,samaccountname,mail,description
$siebeltrt.Length
foreach($account in $siebeltrt)
{
    Set-Mailbox -Identity $account.SamAccountName -CustomAttribute1 "Siebel"

}

Set-Mailbox -Identity DefesaCons -CustomAttribute1 "Siebel PRD"

$siebeltrt | ft Name,samaccountname,mail,description

$mbx = Get-Mailbox -Filter {(CustomAttribute1 -like "Siebel*")} `
| sort displayname | select displayname,samaccountname,PrimarySmtpAddress,CustomAttribute1
$mbx.Length
$mbx

$mbx =@()
$mbx = Get-Mailbox -Filter {CustomAttribute1 -like "Siebel HMG*"} | sort displayname | select displayname,samaccountname,PrimarySmtpAddress,CustomAttribute1
$mbx.Length

foreach($mb in $mbx)
{
    $tmp = $mb.SamAccountName
    $tmp 
    #Get-MailboxStatistics -Identity $tmp | ft Displayname, itemcount
    Set-ADUser -Identity $tmp -Description "Siebel HMG"
    Set-Mailbox -Identity $tmp -CustomAttribute1 "Siebel HMG"
    
}

Get-Mailbox -ResultSize unlimited | sort displayname | Get-MailboxStatistics | select DisplayName,@{l="Total Size (MB)"; e={$_.TotalItemSize.value.toMB()}}, DatabaseName | Export-Csv c:\temp\mailboxesStats.csv -Encoding Unicode

Get-Mailbox -Filter {samaccountname -like "solicitacaoreemb*"}

Get-Mailbox -Identity m41718| Get-MailboxStatistics | Add-Member -MemberType ScriptProperty -Name TotalItemSizeinMB -Value {$this.totalitemsize.value.ToMB()} -PassThru | Format-Table DisplayName,TotalItem*
Get-Mailbox -Identity m41718 | select database 