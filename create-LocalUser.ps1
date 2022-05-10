#$servers = @("osappdsv01","osapphmg01","osapphmg02","osltprd01","osappprd01","osappprd02","osappprd03","osappprd04")
$servers = @("crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02")
#$servers = @("polnappprd04","polnappprd05")

$accountName = "appsiebser"
$password = '$13b3ls3r@'
foreach($server in $servers)
{
    
  
   $comp = [adsi] "WinNT://$server"
   $user = $comp.Create("User", $accountName)
   $user.SetPassword($password)
   $user.SetInfo()
   $user.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD 
   $user.SetInfo()
   #$user.Put("Description","Usuário AppPool IIS Poln")
   #$user.SetInfo()

   [ADSI]$group="WinNT://" + $server + "/IIS_WPG,Group"
   $group.add($user.Path)
   $group.setinfo()
   #[ADSI]$group="WinNT://" + $server + "/Administrators,Group"
   #$group.add($user.Path)
   #$group.setinfo()

}

$servers = @(`
"polndev01",`
"polndev02",`
"poln64hmg01",`
"polnhmg02",`
"polnappprd04",`
"polnappprd05",`
"polnwsprd01",`
"polnwsprd02"`
)


$computer = [ADSI]"WinNT://poln64hmg01"
 $flags = $computer.psbase.Children | Where-Object { $_.psbase.schemaclassname -eq 'user' } | select name, userflags
 $flags
 $flags | select -ExpandProperty userflags | %{$_ -band 0x0002}
