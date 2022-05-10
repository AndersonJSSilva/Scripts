$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

$dts = Get-Datastore | ?{$_.name -like "*compellent*"}
$free = $dts.FreeSpaceGB
$capacity = $dts.CapacityGB
if($free -gt (($capacity/10)*2))
{
    $saida = "{0:N0}" -f $free
    Write-Host $dts.Name : $saida GB Livres de ("{0:N0}" -f $dts.CapacityGB) GB
    #exit 0
}
if(($free -gt (($capacity/10)*1))-and $free -lt (($capacity/10)*2))
{
    $saida = "{0:N0}" -f $free
    Write-Host $saida GB Livres de ("{0:N0}" -f $dts.CapacityGB) GB
    #exit 1
}
if($free -le (($capacity/10)*1))
{
    $saida = "{0:N0}" -f $free
    Write-Host $saida GB Livres de ("{0:N0}" -f $dts.CapacityGB) GB
    #exit 2
}

Disconnect-VIServer -Confirm:$false