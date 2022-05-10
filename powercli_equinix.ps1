$vCenterIP = "vmvc-rj2-01.uremh.local"
Add-PSSnapin VMware.VimAutomation.Core
$cred = Get-Credential -UserName "vsphere.local\administrator" -Message "digiet a senha"
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1


Get-VMHost -Name "esxiapp-h*" | Get-ScsiLun | where {$_.Vendor -eq "COMPELNT" } | Set-ScsiLun -Multipathpolicy RoundRobin


Get-VMHost -Name "esxiapp-h*" | Get-ScsiLun | select vendor, CapacityGB, MultipathPolicy