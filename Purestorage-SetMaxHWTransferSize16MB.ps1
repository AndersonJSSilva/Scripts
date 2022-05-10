$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

$hosts = Get-Cluster POC-PureStorage | Get-VMHost 
foreach ($esx in $hosts) 
{
    $esxcli=get-esxcli -VMHost $esx 
    $esx | Get-AdvancedSetting -Name DataMover.MaxHWTransferSize | Set-AdvancedSetting -Value 16384 -Confirm:$false
}