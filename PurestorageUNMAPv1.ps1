$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

#$esxcli=get-esxcli -VMHost esxiprd26.unimedrj.root


$dts = Get-Datastore -Name compellent*
foreach($dt in $dts)
{
    
    write-host cd /vmfs/volumes/$dt
    $blocks = [convert]::ToInt32(($dt.FreeSpaceMB*15 )/ 100)
    write-host vmkfstools -y 15

}
write-host 

#$esxcli=get-esxcli -VMHost esxiprd26.unimedrj.root
#$esxcli.storage.vmfs.unmap($blocks, $dt.name, $null)





