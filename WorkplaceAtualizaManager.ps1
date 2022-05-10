$emails = Get-Content C:\temp\usersWorkplace.txt


foreach($email in $emails)
{ 

    $manager = get-aduser -identity (Get-ADUser -Filter {mail -eq $email } -Properties mail, manager).manager -Properties mail
    $idmanager = UnimedWorkplace-getUserId -email $manager.mail
    $usuario = UnimedWorkplace-GetUser -email $email

    
    if($usuario -and $idmanager)
    {
        if($usuario.id -ne $idmanager)
        {
            UnimedWorkplace-SetManager -usuario $usuario -idmanager $idmanager
        }
    }
}
