$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://boxprd01/PowerShell -Authentication Kerberos
Import-PSSession $session

###############################################################################################
$trclog = @()
$rcpt = "noreply@unimedrio.com.br"
$trclog += get-messagetrackinglog -Sender $rcpt -Server "boxprd01" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -Sender $rcpt -Server "boxprd02" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt
###############################################################################################
###############################################################################################
$trclog = @()
$msgsubject = "[Unimed Rio] LOG ERRO"
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "12/10/2015 02:30AM" -End "12/14/2015 08:00PM" -MessageSubject $msgsubject  -Server "boxprd01" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "12/10/2015 02:30AM" -End "12/14/2015 08:00PM" -MessageSubject $msgsubject  -Server "boxprd02" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $msgsubject
###############################################################################################
###############################################################################################
$trclog = @()
$rcpt = "atualizacadastro@unimedrio.com.br"
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "12/26/2015 00:01AM" -End "12/26/2015 11:00PM" -Sender $rcpt -Server "boxprd01" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -ResultSize Unlimited -Start "12/26/2015 00:01AM" -End "12/26/2015 11:00PM" -Sender $rcpt -Server "boxprd02" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt
############################################################################################### 


$vasculaine = Get-MessageTrackingLog -ResultSize Unlimited -Start "11/25/2015 8:00AM" -End "12/29/2015 07:00PM" -recipients "atualizacadastro@unimedrio.com.br" | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath

$vasculaine | Out-GridView

fernando@emsventura.com.br