[xml]$metabase = $null
<#
$servers = @("POLNAPPPRD05","POLNAPPPRD04","HOSTV0017","NEOAPPPRD03","NEOAPPPDO02",`
"NEOAPPPRD01","NEOAPPPRD02","NEOAPPPRD04","NEOAPPPRD05","NEOAPPPRD06",`
"HOSTV0001","HOSTV0002","HOSTV0003","NEOAPPPDO01","HOSTV0015")
#>

$servers = @("neotst2012std")

foreach($server in $servers)
{

[xml]$metabase = Get-Content "\\$server\c$\windows\system32\inetsrv\metabase.xml"
#sites 
write-host "########################"  $server   "########################" -foreground red
write-host Sites -foreground Yellow
foreach($line in $metabase.GetElementsByTagName("IIsWebServer"))
{
   if($line.GetAttribute("Location") -notlike "*template*")
   {
        write-host `t Site/VirtualDirectory Name: $line.GetAttribute("ServerComment") `n`t Location:  $line.GetAttribute("Location") `n`t AnonymousUserName:  $line.GetAttribute("AnonymousUserName") `n`t UNCUsername: $line.GetAttribute("UNCUserName") `n
    }

}

#diretorio virtuais
write-host Virtual Directory -foreground Yellow
foreach($line in $metabase.GetElementsByTagName("IIsWebVirtualDir"))
{
        if(($line.GetAttribute("AnonymousUserName") -like "*administrator*") -or ($line.GetAttribute("UNCUserName") -like "*administrator*"))
        {
            write-host `t VirtualDirectory Name: $line.GetAttribute("Location") `n`t AnonymousUserName:  $line.GetAttribute("AnonymousUserName") `n`t UNCUsername: $line.GetAttribute("UNCUserName")`n
        }
}
<#
write-host IIsWebService -foreground Yellow
foreach($line in $metabase.GetElementsByTagName("IIsWebService"))
{

    write-host `t Apppool Name: $line.GetAttribute("AppPoolId") `n`t AnonymousUserName:  $line.GetAttribute("AnonymousUserName")`n
}
#>
write-host Web Files -foreground Yellow
#iis web file
foreach($line in $metabase.GetElementsByTagName("IIsWebFile"))
{

    write-host `t File Name: $line.GetAttribute("Location") `n`t AnonymousUserName:  $line.GetAttribute("AnonymousUserName")`n
}

write-host Web Directory -foreground Yellow
#web direcorty
foreach($line in $metabase.GetElementsByTagName("IIsWebDirectory"))
{
    if($line.GetAttribute("AnonymousUserName") -like "*administrator*") 
    {
        write-host `t File Name: $line.GetAttribute("Location") `n`t AnonymousUserName:  $line.GetAttribute("AnonymousUserName")`n
    }
}

write-host Aplication Pool -foreground Yellow
#app pool
foreach($line in $metabase.GetElementsByTagName("IIsApplicationPool"))
{
    if(($line.GetAttribute("WAMUserName") -like "*administrator*")-and($line.GetAttribute("AppPoolIdentityType")-eq "3"))
    {
        write-host `t File Name: $line.GetAttribute("Location") `n`t AnonymousUserName:  $line.GetAttribute("WAMUserName")`n
    }        

}


}