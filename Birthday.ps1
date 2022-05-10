$user = Get-ADUser -Identity m50610 -Properties extensionAttribute1, extensionAttribute2
Set-ADUser -Identity $user -add @{"extensionAttribute1" = "22/06/1983"} 
Set-ADUser -Identity $user -add @{"extensionAttribute2" = "054.484.607-98"} 
$birthday = get-date $user.extensionAttribute1
$birthday 

$dataatual = [datetime]::now
if( ($dataatual - $birthday).Days/365 -gt 18)
{
    "maior ou igual a 18"
}else
{
    "menor a 18"
}


