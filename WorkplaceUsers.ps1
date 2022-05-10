$users = get-content C:\temp\mailsworkplace.txt
$users.Count
$usersAD =@()

foreach ($mail in $users)
{
    $user = Get-ADUser -filter {mail -eq $mail} -Properties mail
    Add-ADGroupMember -Identity WorkplaceUsers -Members $user
    if($user){$usersad += $user}else{write-host nao encontrado $mail -ForegroundColor Red}
    $user = $null
}
$usersad.Count