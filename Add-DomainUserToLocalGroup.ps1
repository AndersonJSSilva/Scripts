$computer = "localhost"
$group = "Usuários da área de trabalho remota"
$domain = "Unimedrj"
$user = "m41718"
$de = [ADSI]"WinNT://$computer/$Group,group" 
$de.psbase.Invoke("Add",([ADSI]"WinNT://$domain/$user").path)