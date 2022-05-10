Add-PSSnapin vmware.vimautomation.core

Connect-VIServer -Server vmvcenter.unimedrj.root

# PowerCLI Commands

# Conectar no VCenter
Connect-VIServer vmvcenter

# Listar VMs com snapshot
get-vm | get-snapshot | format-list vm,name,Created,sizemb

# remover snapshot
$snapshot = get-vm -name Win2012lab02 | Get-Snapshot
echo $snapshot
Remove-Snapshot -Snapshot $snapshot -RunAsync

# PowerCLI Commands

# Conectar no VCenter
Connect-VIServer vmvcenter

# Listar VMs com snapshot
get-vm | get-snapshot | format-list vm,name,Created,sizemb

# Listas as máquinas com o estado diferente de PoweredOn
get-vm | ?{$_.powerstatus -ne "poweredon"} | sort powerstatus

# remover snapshot
$snapshot = get-vm -name Win2012lab02 | Get-Snapshot
echo $snapshot
Remove-Snapshot -Snapshot $snapshot -RunAsync

#maquinas que precisam de consolidação
Get-VM | Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded}

#PowerCLI command to consolidate the disks of a virtual machine called MyVM.
(Get-VM -Name "MyVM").ExtensionData.ConsolidateVMDisks_Task()

#If you want to wait until the task is finished before continuing with your PowerCLI script, you need to use the ConsolidateVMDisks method:
(Get-VM -Name "MyVM").ExtensionData.ConsolidateVMDisks()

#When you want to consolidate the disks of all virtual machines that need disks consolidation then you can use the script from listing 4.
Get-VM |
Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded} |
ForEach-Object {
  $_.ExtensionData.ConsolidateVMDisks()
}

#busca maquinas que precisam de consolidação
Get-VM|?{((get-harddisk $_).count*2)*((get-snapshot -vm $_).count + 1) -lt ($_.extensiondata.layoutex.file|?{$_.name -like "*vmdk"}).count}

 #busca maquinas que precisam de consolidação e consolida
$vms=Get-VM|?{((get-harddisk $_).count*2)*((get-snapshot -vm $_).count + 1) -lt ($_.extensiondata.layoutex.file|?{$_.name -like "*vmdk"}).count}
$vms.extensiondata|%{$_.consolidatevmdisks_task()}
