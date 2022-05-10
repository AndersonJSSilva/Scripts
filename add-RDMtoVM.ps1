Get-SCSILun -VMhost esxidb-rj2-01.vmware -LunType Disk | Select ConsoleDeviceName,CapacityGB,runtimename


Get-ScsiLun -VMHost esxidb-rj2-01.vmware -LunType disk |
Select ConsoleDeviceName, RuntimeName,CapacityGB |
Sort-Object -Property {$_.RuntimeName.Split(‘:’)[0],
[int]($_.RuntimeName.Split(‘:’)[1].TrimStart(‘C’))},
{[int]($_.RuntimeName.Split(‘:’)[2].TrimStart(‘T’))},
{[int]($_.RuntimeName.Split(‘:’)[3].TrimStart(‘L’))}


vmhba2:C0:T0:L127 /vmfs/devices/disks/naa.60060160b47142005493a35b1ff7f739           130
vmhba2:C0:T0:L128 /vmfs/devices/disks/naa.60060160b47142005493a35b5b0938b2           130
vmhba2:C0:T0:L129 /vmfs/devices/disks/naa.60060160b47142005693a35bd25c5c03           130
vmhba2:C0:T0:L130 /vmfs/devices/disks/naa.60060160b47142005693a35b3dc7f121           130
vmhba2:C0:T0:L131 /vmfs/devices/disks/naa.60060160b47142005793a35b3dc90877           130
vmhba2:C0:T0:L132 /vmfs/devices/disks/naa.60060160b47142005893a35bb6f0f738           130
vmhba2:C0:T0:L133 /vmfs/devices/disks/naa.60060160b47142005993a35b9f7073d4           130
vmhba2:C0:T0:L134 /vmfs/devices/disks/naa.60060160b47142005993a35b683a67b4           130
vmhba2:C0:T0:L135 /vmfs/devices/disks/naa.60060160b4714200a293a35bbcc3cd91            51
vmhba2:C0:T0:L136 /vmfs/devices/disks/naa.60060160b4714200a393a35b7d5794be            51
vmhba2:C0:T0:L137 /vmfs/devices/disks/naa.60060160b4714200a493a35b51069cff            51


$vm = "tasydbtst01"
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005493a35b1ff7f739 | New-ScsiController
$controller = get-vm $vm | Get-ScsiController -Name "SCSI controller 1"
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005493a35b5b0938b2          -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005693a35bd25c5c03        -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005693a35b3dc7f121          -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005793a35b3dc90877          -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005893a35bb6f0f738      -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005993a35b9f7073d4      -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b47142005993a35b683a67b4          -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b4714200a293a35bbcc3cd91        -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b4714200a393a35b7d5794be         -Controller $controller
New-HardDisk -VM $vm -DiskType RawPhysical -DeviceName /vmfs/devices/disks/naa.60060160b4714200a493a35b51069cff          -Controller $controller


get-vm $vm | Get-HardDisk | select name, disktype, filename, capacityGB