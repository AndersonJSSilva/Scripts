﻿$vCenterIP = "vmvc-rj2-01.vmware"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP

$numclones = 20
$vmtemplate = "unirjts"
$newname = "wincabritex"

for($i=1;$i-lt$numclones+1;$i++)
{
$sourceVM = Get-VM $vmtemplate | Get-View
if(($i.ToString()).Length -lt 2)
{
$num = "0"+ $i.ToString()
} else{$num =  $i.ToString() }
$cloneName = $newname+"_linkedclone_" + $num
$cloneFolder = $sourceVM.parent
$cloneSpec = new-object Vmware.Vim.VirtualMachineCloneSpec
$cloneSpec.Snapshot = $sourceVM.Snapshot.CurrentSnapshot
$cloneSpec.Location = new-object Vmware.Vim.VirtualMachineRelocateSpec
$cloneSpec.Location.DiskMoveType = [Vmware.Vim.VirtualMachineRelocateDiskMoveOptions]::createNewChildDiskBacking
$sourceVM.CloneVM_Task($cloneFolder, $cloneName, $cloneSpec)
}