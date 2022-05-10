$vCenterIP = "vmvc-rj2-01.vmware"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

Get-VMHostStorage -VMHost esxi*.vmware -RescanAllHba -RescanVmfs


#esxcfg-volume -M DS-APP01
#esxcfg-volume -M DS-APP02
#esxcfg-volume -M DS-FS
#esxcfg-volume -M DS-TS01
#esxcfg-volume -M DS-TS02
#esxcfg-volume -M DS-EXC01
#esxcfg-volume -M DS-EXC02
#esxcfg-volume -M URJ-DS-REPLICA_LUN_471


$snapshots = get-vm | get-snapshot
$snapshots | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}



$esxcli.storage.filesystem.list() | ?{$_.volumename -like "DS-exc*"} | FT type, volumename, size

$esxcli.storage.filesystem.unmount($false,"DS-EXC01",$null,$null)


function get-RDMFromVM($vmname){
########################################################################################################
### lun id for RDM disks
$vmdisks = @()
$vm = $vmname
$Disks = Get-VM -name $vm  | Get-HardDisk -DiskType "RawPhysical","RawVirtual"
Foreach ($Disk in $Disks)
{ 
  $diskinfo = new-object PSObject
  $diskinfo  | add-member -type NoteProperty -Name "VM Name" -Value $disk.parent
  $diskinfo  | add-member -type NoteProperty -Name "Disk Name" -Value $disk.name
  $diskinfo  | add-member -type NoteProperty -Name "Disk Type" -Value $disk.DiskType
  $diskinfo  | add-member -type NoteProperty -Name "File Name" -Value $disk.filename
  $diskinfo  | add-member -type NoteProperty -Name "Capacity GB" -Value $disk.capacitygb
  $diskinfo  | add-member -type NoteProperty -Name "Scsi Canonical Name" -Value $disk.ScsiCanonicalName
  $diskinfo  | add-member -type NoteProperty -Name "Device Name" -Value $disk.deviceName
  $Lun = Get-SCSILun $Disk.SCSICanonicalName -VMHost (Get-VM -name $vm).VMHost
  $diskinfo  | add-member -type NoteProperty -Name "LUN Id" -Value $Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1)
  $vmdisks += $diskinfo
  
}
$vmdisks
}
########################################################################################################


get-RDMFromVM -vmname mbx*

VM Name             : UNIRJFS01
Disk Name           : Hard disk 7
Disk Type           : RawPhysical
File Name           : [DS-FS] UNIRJFS01/UNIRJFS01_1.vmdk
Capacity GB         : 2048
Scsi Canonical Name : naa.60060160b47142002256a15b8bfe1b2e
Device Name         : vml.020003000060060160b47142002256a15b8bfe1b2e565241494420
LUN Id              : 3

VM Name             : MBXSRV12
Disk Name           : Hard disk 14
Disk Type           : RawPhysical
File Name           : [DS-EXC02] MBXSRV12/MBXSRV12_8.vmdk
Capacity GB         : 2048
Scsi Canonical Name : naa.60060160b4714200c0f2a05bab67027d
Device Name         : vml.020002000060060160b4714200c0f2a05bab67027d565241494420
LUN Id              : 2