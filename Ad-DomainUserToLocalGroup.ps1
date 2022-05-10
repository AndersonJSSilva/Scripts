$computers =@("osappdsv01","osappdsv02","osappprd01","osappprd02","osappprd03","osappprd04","osdcprd01","osltprd01","osapphmg01","osapphmg02","osappinv01")
$group = "administrators"
$domain = "unimedrj"
$user = "tr2333"

foreach($computer in $computers)
{
    $computer
    $de = [ADSI]"WinNT://$computer/$Group,group" 
    $de.psbase.Invoke("Add",([ADSI]"WinNT://$domain/$user").path)
}





