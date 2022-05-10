$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1
Disconnect-VIServer -Confirm:$false

$LunID = "naa.6000d310008a1b000000000000000003"
$VMHost = Get-VMHost -Name esxiprd11.unimedrj.root

function Detach-Disk {
    param(
        [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VMHostImpl]$VMHost,
        [string]$CanonicalName    )

    $storSys = Get-View $VMHost.Extensiondata.ConfigManager.StorageSystem
    $lunUuid = (Get-ScsiLun -VmHost $VMHost | where {$_.CanonicalName -eq $CanonicalName}).ExtensionData.Uuid

    $storSys.DetachScsiLun($lunUuid)
}

$ClusterHosts = Get-Cluster cluster-m62* | Get-VMHost

Foreach($VMHost in $ClusterHosts)
{

Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000002b

}





<# 

#esxcli storage core device detached list

You see output similar to:

Device UID State
------------------------------------ -----
naa.50060160c46036df50060160c46036df off
naa.6006016094602800c8e3e1c5d3c8e011 off 

To permanently remove the device configuration information from the system, run this command:

# esxcli storage core device detached remove -d NAA_ID


#>