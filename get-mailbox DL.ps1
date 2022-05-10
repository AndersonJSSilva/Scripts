$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session

Get-DistributionGroup | ?{$_.RequireSenderAuthenticationEnabled -eq $true} | select name, RequireSenderAuthenticationEnabled

$groups = Get-DistributionGroup | ?{$_.RequireSenderAuthenticationEnabled -eq $true} | select name, RequireSenderAuthenticationEnabled

$groups | Export-Csv -Path C:\temp\group.csv -Encoding Unicode

$trclog = @()
$rcpt = "diretoria@jltbrasil.com"
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "05/04/2016 00:01AM" -End "05/04/2016 11:00PM" -sender $rcpt -Server "eris" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "05/04/2016 00:01AM" -End "05/04/2016 11:00PM" -sender $rcpt -Server "fobos" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt

Get-MessageTrackingLog -ResultSize unlimited -Recipients diretoria@jltbrasil.com -Server "eris"
 | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath

$trclog += get-messagetrackinglog -ResultSize Unlimited -Recipients $rcpt -Server "eris" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -ResultSize Unlimited -Recipients $rcpt -Server "fobos" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt

$trclog = @()
$rcpt = "relacionamento@premiador.com.br"
$trclog += get-messagetrackinglog -ResultSize Unlimited -sender $rcpt -Server "eris" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -ResultSize Unlimited -sender $rcpt -Server "fobos" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt