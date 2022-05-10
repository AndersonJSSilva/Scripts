$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP

################################################################################

$vms = get-datacenter -Name "Unimed rio - barra" |
Get-datastore -name "datastore-emc" |
get-vm | ?{$_.name -notlike "vmvcenter*"} | Sort-Object -Property Name
$vms.Length
$vms = $vms | ?{$_.name -notlike "osapp*"}
$vms = $vms | ?{$_.name -notlike "host0005*"}  
$vms = $vms | ?{$_.PowerState -notlike "PoweredOff*"}
$vms.Length
foreach($vm in $vms)
{
    #$vm | Shutdown-VMGuest -Confirm:$false
    #$vm | Start-VM
}

$vms.GetType()


####################### Datastore "POC_DELL" ########################

$vms2 = get-datacenter -Name "Unimed rio - barra" |
Get-datastore -name "POC_DELL" |
get-vm | Sort-Object -Property Name
$vms2.Length
foreach($vm1 in $vms2)
{
    #$vm1 | Shutdown-VMGuest -Confirm:$false
    #$vm1 | Start-VM
}

##################################################################### 
