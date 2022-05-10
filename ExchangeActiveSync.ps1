Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

$hubs = @("hubcasprd01","hubcasprd02","excboxprd")
$output = @()
$hubs = Get-TransportServer
foreach($hub in $hubs)
{
    
    $output += get-MessageTrackingLog -Server $hub -Start "22/08/2014 16:00:00" -End "23/08/2014 23:59:59" -MessageSubject "interface extra" -EventId SEND | select Timestamp , RecipientCount, MessageSubject,Sender, Recipients, eventid
    
}

$output += get-messagetrackinglog -resultsize unlimited -server hubcasprd01 -Start "25/08/2014 00:00:00" -End "25/08/2014 23:20:00" -MessageSubject "interface extra" -EventId Expand | select sender, messagesubject, timestamp, eventid,RelatedRecipientAddress, recipients, RecipientCount
$output += get-messagetrackinglog -resultsize unlimited -server hubcasprd02 -Start "25/08/2014 00:00:00" -End "25/08/2014 23:20:00" -MessageSubject "interface extra" -EventId Expand | select sender, messagesubject, timestamp, eventid,RelatedRecipientAddress, recipients, RecipientCount
$output | Out-GridView


Get-ActiveSyncDeviceStatistics -Mailbox m41718 | select *time
Get-MailboxStatistics -Identity m41718 | select *
Get-CASMailbox -Filter {HasActivesyncDevicePartnership -eq $true}

$users = Get-CASMailbox | ?{$_.ActiveSyncEnabled -eq $True} 
$data = (Get-Date).AddDays(-60)
$resultado = @()
foreach($user in $users)
{
    $resultado += Get-ActiveSyncDeviceStatistics -mailbox $user.samaccountname -ErrorAction SilentlyContinue |
    Where{$_.LastSuccessSync -gt $data} |
    select @{name="EmailAddress";expression={$_.Identity.ToString().Split("\")[0]}}, LastSuccessSync, DeviceModel, DeviceType
}
$resultado | Out-GridView

