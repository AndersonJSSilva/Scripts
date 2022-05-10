function Print-LastLogonData([string]$time)
{
  if($time -gt 0) 
  {
    $dt = [DateTime]::FromFileTime($time)
    return $dt
  }
  else{return 0}
 } 
$data = (Get-Date).AddDays(-60)
$users = get-aduser -filter {LastLogon -lt $data} -Properties LastLogon, displayname | select samaccountname, displayname, @{Label="LastLogon";Expression={Print-LastLogonData -time $_.LastLogon}} , enabled
$users | Export-Csv  -Encoding Unicode