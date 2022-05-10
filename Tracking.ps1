Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin

###############################################################################################
$trclog = @()
$rcpt = ""
$startdate = "02/21/2016 00:00:00"

$trclog += get-messagetrackinglog -MessageSubject $rcpt -Server "boxprd01" -Start $startdate -EventId send | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog += get-messagetrackinglog -MessageSubject $rcpt -Server "boxprd02" -Start $startdate -EventId send | select timestamp,source,eventid,recipients,messagesubject,sender,returnpath
$trclog | Out-GridView -Title $rcpt