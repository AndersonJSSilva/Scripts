$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session

$users = get-MailboxPermission -Identity Atendimento-PPE


$users | %{

$tmp = ($_.user).tostring()
$tmp = $tmp -replace "unimedrj\\",""
try{$user = Get-ADUser -identity $tmp -Properties *| select displayname -ErrorAction Stop 

    if($user)
    {
        Write-Host $user.displayname ";" $_.AccessRights

    }

}catch{}
$user = $null
}
